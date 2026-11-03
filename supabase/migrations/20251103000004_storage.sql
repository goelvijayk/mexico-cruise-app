insert into storage.buckets (id, name, public, file_size_limit)
values ('trip-docs', 'trip-docs', false, 52428800)
on conflict (id) do update set file_size_limit = 52428800;

create policy trip_docs_select on storage.objects
  for select to authenticated
  using (bucket_id = 'trip-docs');

create policy trip_docs_insert on storage.objects
  for insert to authenticated
  with check (bucket_id = 'trip-docs');

create policy trip_docs_update on storage.objects
  for update to authenticated
  using (bucket_id = 'trip-docs');
