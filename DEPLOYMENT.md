# TrackBite EventsHub — Hostinger Deployment Guide

## What's in this package

```
trackbite-eventshub/
├── server-deploy.mjs          ← Bundled Node.js server (API + serves React app)
├── pino-worker.mjs            ← Logging worker (required, don't delete)
├── pino-file.mjs              ← Logging worker (required, don't delete)
├── pino-pretty.mjs            ← Logging worker (required, don't delete)
├── thread-stream-worker.mjs   ← Logging worker (required, don't delete)
├── public/                    ← Compiled React frontend (static files)
│   ├── index.html
│   └── assets/
├── package.json
├── .env.example               ← Copy to .env and fill in your values
├── setup.sql                  ← Run once to create the database table
└── DEPLOYMENT.md              ← This file
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| Node.js | **v20 or later** (set in Hostinger control panel) |
| PostgreSQL | Any PostgreSQL 14+ instance (Hostinger, Neon, Supabase, etc.) |
| Gmail account | For sending demo-request notification emails |

---

## Step-by-Step Setup

### 1. Upload files to Hostinger

- Log in to **Hostinger hPanel → Hosting → Manage → File Manager**
- Navigate to your Node.js app root (usually `~/domains/yourdomain.com/public_nodejs/`)
- Upload and extract the contents of this zip into that folder
- The directory should look exactly like the tree above

### 2. Set Node.js entry point

- In hPanel → **Node.js** → your app → **Edit**
- **Entry Point:** `server-deploy.mjs`
- **Node.js version:** `20.x` (or latest LTS)
- Click **Save**

### 3. Create and configure `.env`

Via **SSH** or **File Manager**, copy `.env.example` to `.env` and fill in all values:

```bash
cp .env.example .env
nano .env        # fill in DATABASE_URL, SMTP_USER, SMTP_PASS, etc.
```

> **Gmail App Password:** You must use an App Password, not your regular Gmail password.
> Generate one at: https://myaccount.google.com/apppasswords

### 4. Install dependencies

Connect via **SSH** and run in your app root:

```bash
npm install
```

This installs the only runtime dependency (`nodemailer`). Everything else is already bundled.

### 5. Set up the database

Run the SQL setup script once against your PostgreSQL database:

```bash
# Replace the URL with your actual DATABASE_URL from .env
psql "postgresql://user:password@host:5432/dbname" -f setup.sql
```

Alternatively, paste the contents of `setup.sql` into your database management tool (pgAdmin, TablePlus, Hostinger's phpPgAdmin, etc.).

### 6. Start the app

- In hPanel → **Node.js** → click **Restart** (or **Start**)
- Check the logs in hPanel to confirm you see:
  ```
  {"port":3000,"msg":"TrackBite EventsHub server listening"}
  ```

---

## Environment Variables Reference

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `PORT` | Auto | Set by Hostinger automatically — leave blank |
| `SMTP_HOST` | Yes | `smtp.gmail.com` |
| `SMTP_PORT` | Yes | `587` |
| `SMTP_USER` | Yes | Your Gmail address |
| `SMTP_PASS` | Yes | Gmail App Password (16 chars) |
| `DEMO_NOTIFICATION_EMAIL` | Yes | Where demo request emails are sent |
| `SESSION_SECRET` | Yes | Random 32+ char string (`openssl rand -base64 32`) |
| `NODE_ENV` | Yes | `production` |
| `LOG_LEVEL` | No | `info` (default) |

---

## API Endpoints

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/healthz` | Health check — returns `{"status":"ok"}` |
| `POST` | `/api/demo-requests` | Submit a demo request |
| `GET` | `/api/demo-requests` | List all demo requests |

---

## Troubleshooting

**App won't start**
- Check the Hostinger Node.js log panel for error messages
- Make sure `.env` exists and has `DATABASE_URL` set
- Confirm the entry point is `server-deploy.mjs`

**Database connection error**
- Test your `DATABASE_URL` from SSH: `psql "$DATABASE_URL" -c "SELECT 1"`
- Make sure `setup.sql` has been run

**Emails not sending**
- Confirm you are using a **Gmail App Password**, not your regular password
- Check that `SMTP_USER`, `SMTP_PASS`, and `DEMO_NOTIFICATION_EMAIL` are all set in `.env`
- "Less secure apps" is deprecated — App Passwords are the correct method

**Frontend shows blank page**
- Ensure the `public/` folder was uploaded correctly and contains `index.html`
- Clear your browser cache

---

## Support

For platform questions visit: **https://trackbite.in**  
Email: **support@trackbite.in**
