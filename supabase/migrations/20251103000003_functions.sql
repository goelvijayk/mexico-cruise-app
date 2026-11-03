create or replace function server_time() returns timestamptz
language sql stable as $$ select now() $$;

-- Ingestion + app row upsert. On events conflict: LWW by updated_at; never overwrite notes;
-- skip columns listed in existing edited_fields (see ingestion/SCHEMA_ASSUMPTIONS.md).
create or replace function apply_changes(tbl text, rows jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  r jsonb;
  accepted uuid[] := '{}';
  rejected uuid[] := '{}';
  row_id uuid;
  existing events%rowtype;
  incoming_ts timestamptz;
begin
  if auth.role() is distinct from 'authenticated'
     and auth.role() is distinct from 'service_role' then
    raise exception 'not authorized';
  end if;

  if tbl = 'events' then
    for r in select * from jsonb_array_elements(rows)
    loop
      row_id := (r->>'id')::uuid;
      incoming_ts := coalesce((r->>'updated_at')::timestamptz, now());
      select * into existing from events where id = row_id;

      if not found then
        insert into events (
          id, trip_id, type, status, title, start_local, start_tz, end_local, end_tz, all_day,
          location, provider, booking_ref, details, travelers, cost, notes, source, review_state,
          edited_fields, field_meta, created_at, created_by, updated_at, updated_by, deleted_at
        ) values (
          row_id,
          r->>'trip_id',
          r->>'type',
          coalesce(r->>'status', 'confirmed'),
          r->>'title',
          (r->>'start_local')::timestamp,
          r->>'start_tz',
          nullif(r->>'end_local', '')::timestamp,
          r->>'end_tz',
          coalesce((r->>'all_day')::boolean, false),
          r->'location',
          r->>'provider',
          r->>'booking_ref',
          r->'details',
          coalesce(array(select jsonb_array_elements_text(r->'travelers')), '{}'),
          r->'cost',
          r->>'notes',
          coalesce(r->'source', '{}'::jsonb),
          coalesce(r->>'review_state', 'none'),
          coalesce(array(select jsonb_array_elements_text(r->'edited_fields')), '{}'),
          coalesce(r->'field_meta', '{}'::jsonb),
          coalesce((r->>'created_at')::timestamptz, incoming_ts),
          coalesce(r->>'created_by', 'ingestion'),
          incoming_ts,
          coalesce(r->>'updated_by', 'ingestion'),
          nullif(r->>'deleted_at', '')::timestamptz
        );
        accepted := array_append(accepted, row_id);
      elsif existing.updated_at < incoming_ts then
        update events set
          trip_id = case when 'trip_id' = any(edited_fields) then trip_id else coalesce(r->>'trip_id', trip_id) end,
          type = case when 'type' = any(edited_fields) then type else coalesce(r->>'type', type) end,
          status = case when 'status' = any(edited_fields) then status else coalesce(r->>'status', status) end,
          title = case when 'title' = any(edited_fields) then title else coalesce(r->>'title', title) end,
          start_local = case when 'start_local' = any(edited_fields) then start_local else coalesce((r->>'start_local')::timestamp, start_local) end,
          start_tz = case when 'start_tz' = any(edited_fields) then start_tz else coalesce(r->>'start_tz', start_tz) end,
          end_local = case when 'end_local' = any(edited_fields) then end_local else coalesce(nullif(r->>'end_local', '')::timestamp, end_local) end,
          end_tz = case when 'end_tz' = any(edited_fields) then end_tz else coalesce(r->>'end_tz', end_tz) end,
          all_day = case when 'all_day' = any(edited_fields) then all_day else coalesce((r->>'all_day')::boolean, all_day) end,
          location = case when 'location' = any(edited_fields) then location else coalesce(r->'location', location) end,
          provider = case when 'provider' = any(edited_fields) then provider else coalesce(r->>'provider', provider) end,
          booking_ref = case when 'booking_ref' = any(edited_fields) then booking_ref else coalesce(r->>'booking_ref', booking_ref) end,
          details = case when 'details' = any(edited_fields) then details else coalesce(r->'details', details) end,
          travelers = case when 'travelers' = any(edited_fields) then travelers else coalesce(array(select jsonb_array_elements_text(r->'travelers')), travelers) end,
          cost = case when 'cost' = any(edited_fields) then cost else coalesce(r->'cost', cost) end,
          notes = notes,
          source = coalesce(r->'source', source),
          review_state = case when 'review_state' = any(edited_fields) then review_state else coalesce(r->>'review_state', review_state) end,
          field_meta = coalesce(r->'field_meta', field_meta),
          updated_at = incoming_ts,
          updated_by = coalesce(r->>'updated_by', updated_by),
          deleted_at = coalesce(nullif(r->>'deleted_at', '')::timestamptz, deleted_at)
        where id = row_id;
        accepted := array_append(accepted, row_id);
      else
        rejected := array_append(rejected, row_id);
      end if;
    end loop;

  elsif tbl = 'attachments' then
    for r in select * from jsonb_array_elements(rows)
    loop
      row_id := (r->>'id')::uuid;
      incoming_ts := coalesce((r->>'updated_at')::timestamptz, now());
      if not exists (select 1 from attachments a where a.id = row_id) then
        insert into attachments (
          id, trip_id, event_id, kind, file_name, mime_type, size_bytes, sha256, storage_path,
          page_count, source, created_at, created_by, updated_at, updated_by, deleted_at
        ) values (
          row_id,
          r->>'trip_id',
          nullif(r->>'event_id', '')::uuid,
          coalesce(r->>'kind', 'document'),
          r->>'file_name',
          r->>'mime_type',
          (r->>'size_bytes')::bigint,
          r->>'sha256',
          r->>'storage_path',
          nullif(r->>'page_count', '')::int,
          coalesce(r->'source', '{}'::jsonb),
          coalesce((r->>'created_at')::timestamptz, incoming_ts),
          coalesce(r->>'created_by', 'ingestion'),
          incoming_ts,
          coalesce(r->>'updated_by', 'ingestion'),
          nullif(r->>'deleted_at', '')::timestamptz
        );
        accepted := array_append(accepted, row_id);
      elsif (select updated_at from attachments where id = row_id) < incoming_ts then
        update attachments set
          trip_id = coalesce(r->>'trip_id', trip_id),
          event_id = coalesce(nullif(r->>'event_id', '')::uuid, event_id),
          kind = coalesce(r->>'kind', kind),
          file_name = coalesce(r->>'file_name', file_name),
          mime_type = coalesce(r->>'mime_type', mime_type),
          size_bytes = coalesce((r->>'size_bytes')::bigint, size_bytes),
          sha256 = coalesce(r->>'sha256', sha256),
          storage_path = coalesce(r->>'storage_path', storage_path),
          page_count = coalesce(nullif(r->>'page_count', '')::int, page_count),
          source = coalesce(r->'source', source),
          updated_at = incoming_ts,
          updated_by = coalesce(r->>'updated_by', updated_by),
          deleted_at = nullif(r->>'deleted_at', '')::timestamptz
        where id = row_id;
        accepted := array_append(accepted, row_id);
      else
        rejected := array_append(rejected, row_id);
      end if;
    end loop;

  elsif tbl = 'revision_requests' then
    for r in select * from jsonb_array_elements(rows)
    loop
      row_id := (r->>'id')::uuid;
      incoming_ts := coalesce((r->>'updated_at')::timestamptz, now());
      insert into revision_requests (
        id, event_id, note, requested_by, requested_at, status, result_note, diff, applied_at, updated_at
      ) values (
        row_id,
        (r->>'event_id')::uuid,
        r->>'note',
        r->>'requested_by',
        coalesce((r->>'requested_at')::timestamptz, now()),
        coalesce(r->>'status', 'open'),
        r->>'result_note',
        r->'diff',
        nullif(r->>'applied_at', '')::timestamptz,
        incoming_ts
      )
      on conflict (id) do update set
        status = excluded.status,
        result_note = excluded.result_note,
        diff = excluded.diff,
        applied_at = excluded.applied_at,
        updated_at = excluded.updated_at
      where revision_requests.updated_at < excluded.updated_at;
      if found then
        accepted := array_append(accepted, row_id);
      else
        rejected := array_append(rejected, row_id);
      end if;
    end loop;

  else
    raise exception 'unknown table % (use PostgREST upsert for ingested_emails)', tbl;
  end if;

  return jsonb_build_object('accepted', accepted, 'rejected', rejected);
end;
$$;

grant execute on function apply_changes(text, jsonb) to authenticated, service_role;

-- Phone outbox: field-level merge via events.field_meta (app extension; not used by ingestion).
create or replace function apply_field_patches(patches jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  p jsonb;
  accepted text[] := '{}';
  rejected text[] := '{}';
  patch_id text;
  row_id uuid;
  field_name text;
  patch_ts timestamptz;
  patch_by text;
  patch_val jsonb;
  cur_meta jsonb;
  cur_ts timestamptz;
  allowed text[] := array[
    'trip_id','type','status','title','start_local','start_tz','end_local','end_tz','all_day',
    'location','provider','booking_ref','details','travelers','cost','notes','source',
    'review_state','edited_fields','deleted_at'
  ];
  v_text text;
  v_ts timestamp;
  v_tstz timestamptz;
  v_bool boolean;
  v_travelers text[];
begin
  if auth.role() is distinct from 'authenticated' then
    raise exception 'not authorized';
  end if;

  for p in
    select value from jsonb_array_elements(patches) as t(value)
    order by (value->>'updated_at')::timestamptz asc nulls last, value->>'patch_id' asc
  loop
    patch_id := p->>'patch_id';
    row_id := (p->>'row_id')::uuid;
    field_name := p->>'field';
    patch_ts := (p->>'updated_at')::timestamptz;
    patch_by := coalesce(p->>'updated_by', 'unknown');
    patch_val := p->'value';

    if field_name is null or not (field_name = any(allowed)) then
      rejected := array_append(rejected, patch_id);
      continue;
    end if;

    if not exists (select 1 from events where id = row_id) then
      insert into events (
        id, trip_id, type, status, title, start_local, start_tz, source,
        created_at, created_by, updated_at, updated_by, field_meta
      ) values (
        row_id,
        coalesce(p->>'trip_id', 'mex-2026-12'),
        coalesce(p->>'event_type', 'other'),
        'confirmed',
        coalesce(p->>'bootstrap_title', 'New event'),
        coalesce((p->>'bootstrap_start')::timestamp, now()::timestamp),
        coalesce(p->>'bootstrap_tz', 'America/Los_Angeles'),
        coalesce(p->'bootstrap_source', '{"kind":"manual"}'::jsonb),
        patch_ts, patch_by, patch_ts, patch_by, '{}'::jsonb
      );
    end if;

    select field_meta into cur_meta from events where id = row_id;
    cur_ts := nullif(cur_meta->field_name->>'updated_at', '')::timestamptz;

    if cur_ts is not null and patch_ts < cur_ts then
      rejected := array_append(rejected, patch_id);
      continue;
    end if;

    if field_name in ('location','details','cost','source') then
      update events set
        location = case when field_name = 'location' then patch_val else location end,
        details = case when field_name = 'details' then patch_val else details end,
        cost = case when field_name = 'cost' then patch_val else cost end,
        source = case when field_name = 'source' then patch_val else source end,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    elsif field_name = 'travelers' then
      v_travelers := array(select jsonb_array_elements_text(patch_val));
      update events set travelers = v_travelers,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    elsif field_name = 'edited_fields' then
      v_travelers := array(select jsonb_array_elements_text(patch_val));
      update events set edited_fields = v_travelers,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by
      where id = row_id;
    elsif field_name = 'start_local' then
      v_ts := (patch_val #>> '{}')::timestamp;
      update events set start_local = v_ts,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    elsif field_name = 'end_local' then
      v_ts := nullif(patch_val #>> '{}', '')::timestamp;
      update events set end_local = v_ts,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    elsif field_name = 'deleted_at' then
      v_tstz := nullif(patch_val #>> '{}', '')::timestamptz;
      update events set deleted_at = v_tstz,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    elsif field_name = 'all_day' then
      v_bool := (patch_val #>> '{}')::boolean;
      update events set all_day = v_bool,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    else
      v_text := patch_val #>> '{}';
      update events set
        trip_id = case when field_name = 'trip_id' then v_text else trip_id end,
        type = case when field_name = 'type' then v_text else type end,
        status = case when field_name = 'status' then v_text else status end,
        title = case when field_name = 'title' then v_text else title end,
        start_tz = case when field_name = 'start_tz' then v_text else start_tz end,
        end_tz = case when field_name = 'end_tz' then v_text else end_tz end,
        provider = case when field_name = 'provider' then v_text else provider end,
        booking_ref = case when field_name = 'booking_ref' then v_text else booking_ref end,
        notes = case when field_name = 'notes' then v_text else notes end,
        review_state = case when field_name = 'review_state' then v_text else review_state end,
        field_meta = jsonb_set(coalesce(field_meta, '{}'::jsonb), array[field_name],
          jsonb_build_object('updated_at', patch_ts, 'updated_by', patch_by), true),
        updated_at = greatest(updated_at, patch_ts),
        updated_by = patch_by,
        edited_fields = case
          when patch_by <> 'ingestion' and not (field_name = any(edited_fields))
          then array_append(edited_fields, field_name) else edited_fields end
      where id = row_id;
    end if;

    accepted := array_append(accepted, patch_id);
  end loop;

  return jsonb_build_object('accepted', accepted, 'rejected', rejected);
end;
$$;

grant execute on function apply_field_patches(jsonb) to authenticated;
