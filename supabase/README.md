# Supabase setup

1. Create a Supabase project.
2. Open SQL Editor.
3. Run every file in `migrations/` in numeric order (`001` through `010`).
4. Run `seed/seed.sql` after all migrations.
5. Optionally run `seed/validate_seed.sql` to confirm the demo catalog counts and exam mappings.
6. Put project URL and keys in the frontend/backend `.env` files.

To make a registered user an administrator:

```sql
update public.profiles set role='admin' where id='<AUTH_USER_UUID>';
```

The backend must use the service-role key. Never put that key in frontend code.
