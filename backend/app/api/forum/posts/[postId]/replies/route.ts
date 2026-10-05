import { NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth/get-session-user';
import { createReply, listReplies } from '@/lib/services/forum-service';

export async function GET(request: Request, { params }: { params: Promise<{ postId: string }> }) {
  const session = await getSessionUser(request);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { postId } = await params;
  return NextResponse.json(await listReplies(postId, session.token));
}

export async function POST(request: Request, { params }: { params: Promise<{ postId: string }> }) {
  const session = await getSessionUser(request);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { postId } = await params;
  const { content, isAnonymous = true } = await request.json();
  if (!content?.trim()) return NextResponse.json({ error: 'Content is required' }, { status: 400 });

  const reply = await createReply({ postId, content, isAnonymous, authorId: session.user.id, token: session.token });
  return NextResponse.json(reply, { status: 201 });
}