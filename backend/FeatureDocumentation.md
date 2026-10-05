# Feature Documentation

## Overview
This document outlines the core features of the application and their responsibilities.

---

## FR1: Sign-up/Login Flow Logic - ISIKO 

**Description**: Handles user authentication including account creation and login functionality.

**Responsibilities**:
- User registration logic
- User login logic
- Authentication flow management

**Dependencies**: Works closely with [Name 3] (Database) on schema-dependent logic

---

## FR2/FR3: Mood Entry Management

**Description**: Server Actions and API logic for managing user mood entries.

**Responsibilities**:
- Mood entry creation
- Mood entry retrieval

**Dependencies**: Works closely with [Name 3] (Database) on schema-dependent logic

---

## FR5/FR6: Forum Post/Reply Management

**Description**: Server Actions for forum discussions.

**Responsibilities**:
- Forum post creation
- Forum reply creation

**Dependencies**: Works closely with [Name 3] (Database) on schema-dependent logic

---

## Content Moderation: Report Post Logic

**Description**: Flags posts for manual review by moderation team.

**Responsibilities**:
- Post flagging mechanism
- Manual review workflow

**Dependencies**: Works closely with [Name 3] (Database) on schema-dependent logic

---

## Cross-Feature Dependencies

All features are schema-dependent and require coordination with [Name 3] (Database) for implementation.

## curl examples (verified working)

All examples assume:
```bash
export TOKEN="your-access-token-here"
```

### Create a post (anonymous)

```bash
curl -X POST http://localhost:3000/api/forum/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Feeling overwhelmed with finals","topic":"stress","isAnonymous":true}'
```

Response:
```json
{
  "id": "c66ab7d2-5358-4cab-a575-745996bead1c",
  "content": "Feeling overwhelmed with finals",
  "topic": "stress",
  "is_anonymous": true,
  "created_at": "2026-10-05T10:57:07.832737+00:00"
}
```

### Create a post (not anonymous)

```bash
curl -X POST http://localhost:3000/api/forum/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Sharing my study routine","topic":"mindfulness","isAnonymous":false}'
```

### List posts

```bash
curl http://localhost:3000/api/forum/posts \
  -H "Authorization: Bearer $TOKEN"
```

Response — note `author` resolves differently per post based on `isAnonymous`:
```json
[
  {
    "id": "5fc1e3a0-613f-4903-bcd5-04d3dd99d256",
    "content": "Sharing my study routine",
    "topic": "mindfulness",
    "created_at": "2026-10-05T11:05:00.804942+00:00",
    "author": "Student"
  },
  {
    "id": "c66ab7d2-5358-4cab-a575-745996bead1c",
    "content": "Feeling overwhelmed with finals",
    "topic": "stress",
    "created_at": "2026-10-05T10:57:07.832737+00:00",
    "author": "Anonymous Student"
  }
]
```
`"Student"` is the fallback shown when a non-anonymous post's author has no `anonymous_handle` set in their profile yet.

### Reply to a post

```bash
curl -X POST http://localhost:3000/api/forum/posts/POST_ID_HERE/replies \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"You are not alone in this","isAnonymous":true}'
```

Response:
```json
{
  "id": "6b11e886-bf80-4f3c-a31d-4ac1ffecd5f0",
  "post_id": "c66ab7d2-5358-4cab-a575-745996bead1c",
  "content": "You are not alone in this",
  "is_anonymous": true,
  "created_at": "2026-10-05T11:13:32.98097+00:00"
}
```

### List replies for a post

```bash
curl http://localhost:3000/api/forum/posts/POST_ID_HERE/replies \
  -H "Authorization: Bearer $TOKEN"
```

Response:
```json
[
  {
    "id": "6b11e886-bf80-4f3c-a31d-4ac1ffecd5f0",
    "content": "You are not alone in this",
    "created_at": "2026-10-05T11:13:32.98097+00:00",
    "author": "Anonymous Student"
  }
]
```