alter table trip enable row level security;
alter table events enable row level security;
alter table attachments enable row level security;
alter table ingested_emails enable row level security;
alter table revision_requests enable row level security;

create policy authenticated_all_trip on trip
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy authenticated_all_events on events
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy authenticated_all_attachments on attachments
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy authenticated_all_ingested_emails on ingested_emails
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy authenticated_all_revision_requests on revision_requests
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');
