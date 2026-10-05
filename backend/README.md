# Backend — YouperMVP

Next.js (App Router) backend. Supabase is used for storage (Postgres + Auth) — all business logic (validation, anonymity rules, future moderation/rate-limiting) lives in this app, not in Supabase.

## Setup (do this after every `git pull` that touches `package.json`)

```bash
cd backend
npm install
```

You'll also need a `.env.local` file in `backend/` (not committed — get the values from a teammate):

```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

## Running locally

```bash
npm run dev
```

Server runs at `http://localhost:3000`. API routes are available under `http://localhost:3000/api/...`.

## Folder structure

```
backend/
├── app/
│   └── api/
│       └── <feature>/          # one folder per feature, e.g. forum/, mood/
│           └── route.ts        # GET/POST/etc. handlers
├── lib/
│   ├── auth/                   # session/auth helpers, shared across features
│   ├── services/                # business logic — one file per feature
│   └── supabase/                # Supabase client setup
├── database/
│   └── schema.sql               # current schema reference
├── .env.local                   # local secrets, gitignored
├── package.json
├── tsconfig.json
└── next.config.js
```

## Conventions for adding a new feature

- Create your routes under `app/api/<your-feature>/`. Don't add routes outside `app/api/`.
- Keep route files thin: auth check → validate input → call a service function → return response. No business logic directly in `route.ts`.
- Put your actual logic in `lib/services/<your-feature>-service.ts`.
- If you need your own Supabase tables, add a new migration file in `database/` rather than editing another feature's tables.
- Don't modify `tsconfig.json`, `next.config.js`, or `package.json`'s existing scripts unless the whole team needs the change — raise it in the group chat first.

## Existing features

| Feature | Routes | Service file | Notes |
|---|---|---|---|
| Forum (FR5/FR6) | `/api/forum/posts`, `/api/forum/posts/[postId]/replies` | `lib/services/forum-service.ts` | Supports anonymous/non-anonymous posting — see `FeatureDocumentation.md` for the full API contract |

## Troubleshooting

- **"Cannot find module '@/...'"** — run `npm install` again; make sure `tsconfig.json` wasn't accidentally deleted.
- **Module format errors** — don't remove `"type": "module"` from `package.json`; all `.js`/`.ts` files in this project use ES module syntax (`import`/`export`), not CommonJS (`require`/`module.exports`).
- **`{"error":"Unauthorized"}`** on any endpoint — expected if you're testing without a real Supabase session token. This means auth is working correctly, not broken.