import { getServerSupabase } from '@/lib/supabase/server';

export async function createPost({ content, topic, isAnonymous, authorId, token }:
  { content: string; topic?: string; isAnonymous: boolean; authorId: string; token: string }) {
  const supabase = getServerSupabase(token);
  const { data, error } = await supabase
    .from('forum_posts')
    .insert({ author_id: authorId, content, topic, is_anonymous: isAnonymous })
    .select('id, content, topic, is_anonymous, created_at')
    .single();
  if (error) throw error;
  return data;
}

export async function listPosts(token: string) {
  const supabase = getServerSupabase(token);
  const { data, error } = await supabase
    .from('forum_posts')
    .select('id, content, topic, is_anonymous, created_at, profiles(anonymous_handle)')
    .order('created_at', { ascending: false });
  if (error) throw error;

  return data.map((p: any) => ({
    id: p.id, content: p.content, topic: p.topic, created_at: p.created_at,
    author: p.is_anonymous ? 'Anonymous Student' : (p.profiles?.anonymous_handle ?? 'Student'),
  }));
}

export async function createReply({ postId, content, isAnonymous, authorId, token }:
  { postId: string; content: string; isAnonymous: boolean; authorId: string; token: string }) {
  const supabase = getServerSupabase(token);
  const { data, error } = await supabase
    .from('forum_replies')
    .insert({ post_id: postId, author_id: authorId, content, is_anonymous: isAnonymous })
    .select('id, post_id, content, is_anonymous, created_at')
    .single();
  if (error) throw error;
  return data;
}

export async function listReplies(postId: string, token: string) {
  const supabase = getServerSupabase(token);
  const { data, error } = await supabase
    .from('forum_replies')
    .select('id, content, is_anonymous, created_at, profiles(anonymous_handle)')
    .eq('post_id', postId)
    .order('created_at', { ascending: true });
  if (error) throw error;

  return data.map((r: any) => ({
    id: r.id, content: r.content, created_at: r.created_at,
    author: r.is_anonymous ? 'Anonymous Student' : (r.profiles?.anonymous_handle ?? 'Student'),
  }));
}