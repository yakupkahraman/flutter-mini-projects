-- Run this once in your Supabase project: Dashboard → SQL Editor → New query.

-- One table holds every message in the group chat.
create table public.messages (
  id bigint generated always as identity primary key,
  -- Filled in by the database from the signed-in user, so the app never sends these.
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  username text not null default (auth.jwt() -> 'user_metadata' ->> 'username'),
  content text not null check (char_length(content) between 1 and 1000),
  created_at timestamptz not null default now()
);

-- Row Level Security: without a matching policy, nobody can read or write.
alter table public.messages enable row level security;

grant select, insert on public.messages to authenticated;

-- Any signed-in user can read the chat.
create policy "Signed-in users can read messages"
  on public.messages for select
  to authenticated
  using (true);

-- Users can only post as themselves, under their own username.
create policy "Users can send messages as themselves"
  on public.messages for insert
  to authenticated
  with check (
    user_id = (select auth.uid())
    and username = (select auth.jwt() -> 'user_metadata' ->> 'username')
  );

-- Turn on Realtime for this table so new messages are pushed to the app.
alter publication supabase_realtime add table public.messages;
