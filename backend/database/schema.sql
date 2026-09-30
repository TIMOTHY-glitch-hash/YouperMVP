drop extension if exists "pg_net";

create schema if not exists "private";


  create table "public"."forum_posts" (
    "id" uuid not null default gen_random_uuid(),
    "author_id" uuid not null,
    "content" text not null,
    "topic" text,
    "flagged" boolean not null default false,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."forum_posts" enable row level security;


  create table "public"."forum_replies" (
    "id" uuid not null default gen_random_uuid(),
    "post_id" uuid not null,
    "author_id" uuid not null,
    "content" text not null,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."forum_replies" enable row level security;


  create table "public"."mood_entries" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "mood_score" integer not null,
    "note" text,
    "logged_at" timestamp with time zone not null default now()
      );


alter table "public"."mood_entries" enable row level security;


  create table "public"."profiles" (
    "id" uuid not null,
    "anonymous_handle" text,
    "theme_preference" text default 'light'::text,
    "role" text not null default 'user'::text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."profiles" enable row level security;

CREATE UNIQUE INDEX forum_posts_pkey ON public.forum_posts USING btree (id);

CREATE UNIQUE INDEX forum_replies_pkey ON public.forum_replies USING btree (id);

CREATE UNIQUE INDEX mood_entries_pkey ON public.mood_entries USING btree (id);

CREATE UNIQUE INDEX profiles_anonymous_handle_key ON public.profiles USING btree (anonymous_handle);

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

alter table "public"."forum_posts" add constraint "forum_posts_pkey" PRIMARY KEY using index "forum_posts_pkey";

alter table "public"."forum_replies" add constraint "forum_replies_pkey" PRIMARY KEY using index "forum_replies_pkey";

alter table "public"."mood_entries" add constraint "mood_entries_pkey" PRIMARY KEY using index "mood_entries_pkey";

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."forum_posts" add constraint "forum_posts_author_id_fkey" FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."forum_posts" validate constraint "forum_posts_author_id_fkey";

alter table "public"."forum_replies" add constraint "forum_replies_author_id_fkey" FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."forum_replies" validate constraint "forum_replies_author_id_fkey";

alter table "public"."forum_replies" add constraint "forum_replies_post_id_fkey" FOREIGN KEY (post_id) REFERENCES public.forum_posts(id) ON DELETE CASCADE not valid;

alter table "public"."forum_replies" validate constraint "forum_replies_post_id_fkey";

alter table "public"."mood_entries" add constraint "mood_entries_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."mood_entries" validate constraint "mood_entries_student_id_fkey";

alter table "public"."mood_entries" add constraint "mood_score_check" CHECK (((mood_score >= 1) AND (mood_score <= 10))) not valid;

alter table "public"."mood_entries" validate constraint "mood_score_check";

alter table "public"."profiles" add constraint "profiles_anonymous_handle_key" UNIQUE using index "profiles_anonymous_handle_key";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."profiles" add constraint "profiles_role_check" CHECK ((role = ANY (ARRAY['user'::text, 'admin'::text]))) not valid;

alter table "public"."profiles" validate constraint "profiles_role_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION private.is_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles
        WHERE id = (SELECT auth.uid())
        AND role = 'admin'
    );
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
BEGIN
    INSERT INTO public.profiles (
        id,
        role
    )
    VALUES (
        NEW.id,
        'user'
    );

    RETURN NEW;
END;
$function$
;

grant delete on table "public"."forum_posts" to "anon";

grant insert on table "public"."forum_posts" to "anon";

grant references on table "public"."forum_posts" to "anon";

grant select on table "public"."forum_posts" to "anon";

grant trigger on table "public"."forum_posts" to "anon";

grant truncate on table "public"."forum_posts" to "anon";

grant update on table "public"."forum_posts" to "anon";

grant delete on table "public"."forum_posts" to "authenticated";

grant insert on table "public"."forum_posts" to "authenticated";

grant references on table "public"."forum_posts" to "authenticated";

grant select on table "public"."forum_posts" to "authenticated";

grant trigger on table "public"."forum_posts" to "authenticated";

grant truncate on table "public"."forum_posts" to "authenticated";

grant update on table "public"."forum_posts" to "authenticated";

grant delete on table "public"."forum_posts" to "service_role";

grant insert on table "public"."forum_posts" to "service_role";

grant references on table "public"."forum_posts" to "service_role";

grant select on table "public"."forum_posts" to "service_role";

grant trigger on table "public"."forum_posts" to "service_role";

grant truncate on table "public"."forum_posts" to "service_role";

grant update on table "public"."forum_posts" to "service_role";

grant delete on table "public"."forum_replies" to "anon";

grant insert on table "public"."forum_replies" to "anon";

grant references on table "public"."forum_replies" to "anon";

grant select on table "public"."forum_replies" to "anon";

grant trigger on table "public"."forum_replies" to "anon";

grant truncate on table "public"."forum_replies" to "anon";

grant update on table "public"."forum_replies" to "anon";

grant delete on table "public"."forum_replies" to "authenticated";

grant insert on table "public"."forum_replies" to "authenticated";

grant references on table "public"."forum_replies" to "authenticated";

grant select on table "public"."forum_replies" to "authenticated";

grant trigger on table "public"."forum_replies" to "authenticated";

grant truncate on table "public"."forum_replies" to "authenticated";

grant update on table "public"."forum_replies" to "authenticated";

grant delete on table "public"."forum_replies" to "service_role";

grant insert on table "public"."forum_replies" to "service_role";

grant references on table "public"."forum_replies" to "service_role";

grant select on table "public"."forum_replies" to "service_role";

grant trigger on table "public"."forum_replies" to "service_role";

grant truncate on table "public"."forum_replies" to "service_role";

grant update on table "public"."forum_replies" to "service_role";

grant delete on table "public"."mood_entries" to "anon";

grant insert on table "public"."mood_entries" to "anon";

grant references on table "public"."mood_entries" to "anon";

grant select on table "public"."mood_entries" to "anon";

grant trigger on table "public"."mood_entries" to "anon";

grant truncate on table "public"."mood_entries" to "anon";

grant update on table "public"."mood_entries" to "anon";

grant delete on table "public"."mood_entries" to "authenticated";

grant insert on table "public"."mood_entries" to "authenticated";

grant references on table "public"."mood_entries" to "authenticated";

grant select on table "public"."mood_entries" to "authenticated";

grant trigger on table "public"."mood_entries" to "authenticated";

grant truncate on table "public"."mood_entries" to "authenticated";

grant update on table "public"."mood_entries" to "authenticated";

grant delete on table "public"."mood_entries" to "service_role";

grant insert on table "public"."mood_entries" to "service_role";

grant references on table "public"."mood_entries" to "service_role";

grant select on table "public"."mood_entries" to "service_role";

grant trigger on table "public"."mood_entries" to "service_role";

grant truncate on table "public"."mood_entries" to "service_role";

grant update on table "public"."mood_entries" to "service_role";

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";


  create policy "Authenticated users can view forum posts"
  on "public"."forum_posts"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Users can create forum posts"
  on "public"."forum_posts"
  as permissive
  for insert
  to authenticated
with check ((author_id = ( SELECT auth.uid() AS uid)));



  create policy "Users can delete their own forum posts"
  on "public"."forum_posts"
  as permissive
  for delete
  to authenticated
using (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can update their own forum posts"
  on "public"."forum_posts"
  as permissive
  for update
  to authenticated
using (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)))
with check (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Authenticated users can view forum replies"
  on "public"."forum_replies"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Users can create forum replies"
  on "public"."forum_replies"
  as permissive
  for insert
  to authenticated
with check ((author_id = ( SELECT auth.uid() AS uid)));



  create policy "Users can delete their own forum replies"
  on "public"."forum_replies"
  as permissive
  for delete
  to authenticated
using (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can update their own forum replies"
  on "public"."forum_replies"
  as permissive
  for update
  to authenticated
using (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)))
with check (((author_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can create their own mood entries"
  on "public"."mood_entries"
  as permissive
  for insert
  to authenticated
with check ((student_id = ( SELECT auth.uid() AS uid)));



  create policy "Users can delete their own mood entries"
  on "public"."mood_entries"
  as permissive
  for delete
  to authenticated
using (((student_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can update their own mood entries"
  on "public"."mood_entries"
  as permissive
  for update
  to authenticated
using (((student_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)))
with check (((student_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can view their own mood entries"
  on "public"."mood_entries"
  as permissive
  for select
  to authenticated
using (((student_id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Admins can delete profiles"
  on "public"."profiles"
  as permissive
  for delete
  to authenticated
using (( SELECT private.is_admin() AS is_admin));



  create policy "Users can update their own profile"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using (((id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)))
with check ((((id = ( SELECT auth.uid() AS uid)) AND (role = 'user'::text)) OR ( SELECT private.is_admin() AS is_admin)));



  create policy "Users can view their own profile"
  on "public"."profiles"
  as permissive
  for select
  to authenticated
using (((id = ( SELECT auth.uid() AS uid)) OR ( SELECT private.is_admin() AS is_admin)));


CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


