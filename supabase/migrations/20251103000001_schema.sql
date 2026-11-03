-- Mexico Cruise — core schema (PRD §4.1 + field_meta for merge)
create extension if not exists "pgcrypto";

create table trip (
  id text primary key,
  name text not null,
  start_date date not null,
  end_date date not null,
  ship_time_zone text not null,
  home_time_zone text not null,
  default_currency text not null default 'USD',
  updated_at timestamptz not null default now()
);

create table events (
  id uuid primary key,
  trip_id text not null references trip(id),
  type text not null check (type in ('flight','hotel','cruise_embark','cruise_disembark',
        'port_call','sea_day','excursion','transfer','dining','meetup','other')),
  status text not null default 'confirmed' check (status in ('confirmed','tentative','cancelled')),
  title text not null,
  start_local timestamp not null,
  start_tz text not null,
  end_local timestamp,
  end_tz text,
  all_day boolean not null default false,
  start_day date generated always as (start_local::date) stored,
  end_day date generated always as (coalesce(end_local, start_local)::date) stored,
  location jsonb,
  provider text,
  booking_ref text,
  details jsonb,
  travelers text[],
  cost jsonb,
  notes text,
  source jsonb not null,
  review_state text not null default 'none' check (review_state in ('none','flagged','revised','needs_human')),
  edited_fields text[] not null default '{}',
  field_meta jsonb not null default '{}',
  created_at timestamptz not null default now(),
  created_by text not null,
  updated_at timestamptz not null default now(),
  updated_by text not null,
  deleted_at timestamptz
);
create index events_trip_days_idx on events (trip_id, start_day, end_day) where deleted_at is null;
create index events_updated_at_idx on events (updated_at);

create table attachments (
  id uuid primary key,
  trip_id text not null references trip(id),
  event_id uuid references events(id),
  kind text not null default 'document' check (kind in ('boarding_pass','ticket','confirmation','voucher','itinerary','contract','map','document')),
  file_name text not null,
  mime_type text not null,
  size_bytes bigint not null,
  sha256 text not null,
  storage_path text not null,
  page_count int,
  source jsonb not null,
  created_at timestamptz not null default now(),
  created_by text not null,
  updated_at timestamptz not null default now(),
  updated_by text not null,
  deleted_at timestamptz
);
create unique index attachments_trip_sha_idx on attachments (trip_id, sha256) where deleted_at is null;
create index attachments_updated_at_idx on attachments (updated_at);

create table ingested_emails (
  gmail_message_id text primary key,
  trip_id text not null references trip(id),
  thread_id text not null,
  from_addr text not null,
  subject text not null,
  received_at timestamptz not null,
  snippet text not null,
  body_text text not null,
  gmail_link text not null,
  status text not null check (status in ('parsed','failed','ignored','manual_done')),
  failure_reason text,
  event_ids uuid[] not null default '{}',
  attachment_count int not null default 0,
  reparse_requested boolean not null default false,
  reparse_note text,
  handled_by text,
  handled_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index ingested_emails_status_idx on ingested_emails (status) where deleted_at is null;
create index ingested_emails_updated_at_idx on ingested_emails (updated_at);

create table revision_requests (
  id uuid primary key,
  event_id uuid not null references events(id),
  note text not null,
  requested_by text not null,
  requested_at timestamptz not null default now(),
  status text not null default 'open' check (status in ('open','applied','needs_human','failed')),
  result_note text,
  diff jsonb,
  applied_at timestamptz,
  updated_at timestamptz not null default now()
);
create index revision_requests_status_idx on revision_requests (status);
create index revision_requests_updated_at_idx on revision_requests (updated_at);
