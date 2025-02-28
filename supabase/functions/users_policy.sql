alter policy "Allow users to insert their own words"
on "public"."words"
to authenticated
with check (
  (auth.uid() = user_id)
);

alter policy "Enable insert for authenticated users only"
on "public"."words"
to authenticated
with check (
    true
);
alter policy Allow users to insert their own words
on "public"."words"
rename to "Enable insert for authenticated users only";

alter policy "Enable insert for users based on user_id"
on "public"."words"
to public
with check (
  (select auth.uid()) = user_id
);
alter policy Allow users to insert their own words
on "public"."words"
rename to "Enable insert for users based on user_id";


