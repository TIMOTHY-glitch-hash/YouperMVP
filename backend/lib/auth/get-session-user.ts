import { getServerSupabase } from '@/lib/supabase/server';



export async function getSessionUser(request: Request) {
  const token = request.headers.get('authorization')?.replace('Bearer ', '');
  console.log('RECEIVED TOKEN:', token);
  if (!token) return null;

  const supabase = getServerSupabase(token);
  const { data, error } = await supabase.auth.getUser(token);
  console.log('SUPABASE AUTH ERROR:', error); // add this
  console.log('SUPABASE AUTH DATA:', data);
  if (error || !data.user) return null;

  return { user: data.user, token };
}