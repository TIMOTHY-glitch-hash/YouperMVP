import { NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth/get-session-user';
import { createPost, listPosts } from '@/lib/services/forum-service';

export async function GET(request: Request) {
  const session = await getSessionUser(request);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  return NextResponse.json(await listPosts(session.token));
}

export async function POST(request: Request) {
  const session = await getSessionUser(request);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { content, topic, isAnonymous = true } = await request.json();
  if (!content?.trim()) return NextResponse.json({ error: 'Content is required' }, { status: 400 });

  const post = await createPost({ content, topic, isAnonymous, authorId: session.user.id, token: session.token });
  return NextResponse.json(post, { status: 201 });
}