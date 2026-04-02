# my_schedule

## Design System (Default)

The project default design system lives in `lib/src/core/design_system`.
Every new widget and every new screen must follow this design system by default.
Use `AppTheme.light()` in `MaterialApp` and the tokens `AppColors`,
`AppTypography`, `AppSpacing`, and `AppRadius` when creating new components.

## Supabase

This app uses Supabase Auth and a `profiles` table to store user roles.
Expected columns: `user_id` (UUID) and `role` (text).

Suggested schema:

```sql
create table if not exists profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'user')),
  created_at timestamptz default now()
);

alter table profiles enable row level security;

create policy "Profiles are readable by owner"
  on profiles for select
  using (auth.uid() = user_id);

create policy "Profiles are writable by owner"
  on profiles for insert
  with check (auth.uid() = user_id);
```

Development setup:

1. Add Supabase credentials to `.dev.env.json`:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
2. Run the app with:
   `flutter run -d chrome --dart-define-from-file=.dev.env.json`
