alter table public.forum_posts add column is_anonymous boolean not null default true;
alter table public.forum_replies add column is_anonymous boolean not null default true;