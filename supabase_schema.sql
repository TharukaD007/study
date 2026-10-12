-- Run this in Supabase SQL Editor before enabling cloud sync.
-- This stores one JSON document per authenticated user; RLS is essential.
create table if not exists public.daymark_data (
  id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.daymark_data enable row level security;

-- Re-runnable policy setup.
drop policy if exists "Users can read own Daymark data" on public.daymark_data;
drop policy if exists "Users can insert own Daymark data" on public.daymark_data;
drop policy if exists "Users can update own Daymark data" on public.daymark_data;

create policy "Users can read own Daymark data"
  on public.daymark_data for select to authenticated
  using (auth.uid() = id);

create policy "Users can insert own Daymark data"
  on public.daymark_data for insert to authenticated
  with check (auth.uid() = id);

create policy "Users can update own Daymark data"
  on public.daymark_data for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

grant select, insert, update on public.daymark_data to authenticated;
