# ClaudeClaw

```
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝╚══════╝

 ██████╗██╗      █████╗ ██╗    ██╗
██╔════╝██║     ██╔══██╗██║    ██║
██║     ██║     ███████║██║ █╗ ██║
██║     ██║     ██╔══██║██║███╗██║
╚██████╗███████╗██║  ██║╚███╔███╔╝
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝
```

> Your Claude Code CLI, delivered to your phone via Telegram.

ClaudeClaw is not a chatbot wrapper. It spawns the actual `claude` CLI on your Mac or Linux machine and pipes the result back to your Telegram chat. Everything that works in your terminal — your skills, your tools, your context — works from your phone.

---

## Get started

![ClaudeClaw setup flow](assets/setup-flow.jpeg)

Follow these steps in order. The whole thing takes about 5 minutes.

---

### Step 1 — What you need before anything else

| Requirement | Notes |
|-------------|-------|
| **Node.js 20+** | Check: `node --version`. Download at [nodejs.org](https://nodejs.org) |
| **Git** | Check: `git --version`. If you've never used git, also run the two commands below |
| **Claude Code CLI** | Install: `npm i -g @anthropic-ai/claude-code` |
| **Claude account** | Log in: `claude login` (free, Pro, or Max plan) |
| **Telegram account** | Any existing account works |

**First time using git?** Run these two commands first (use your own name and email):
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
Without this, git operations will fail with a confusing error about missing identity.

**macOS users:** After starting ClaudeClaw for the first time, your Mac may show "Node wants to access..." permission dialogs. You need to click Allow on each one or the bot will silently hang. Keep an eye on your Mac screen during the first run.

**Which Claude plan works best?** ClaudeClaw runs the `claude` CLI, so any plan works (Free, Pro, Max). However, complex multi-step tasks (building skills, debugging code, multi-agent work) perform significantly better on **Opus**. If you're on the Free or Pro plan and Claude struggles with a task, the model matters. Sonnet is fast but often can't handle the kind of agentic work ClaudeClaw enables. Max ($100 or $200) with Opus is the recommended experience.

**New to the terminal?** Download [Warp](https://www.warp.dev) — it's a modern terminal with AI built in. If you hit any OS-level issues during setup (permissions, missing tools, PATH problems), type `/agent` in Warp and describe what went wrong. It will walk you through fixing it. This alone will save you hours of Googling.

That's it for hard requirements. Everything else (voice, video, WhatsApp) is optional and the setup wizard will ask about them.

---

### Step 2 — Create a Telegram bot

You need a bot token from Telegram. This is what ClaudeClaw uses to send and receive messages.

1. Open Telegram and search for **@BotFather**
2. Send `/newbot`
3. Follow the prompts — give it a name and a username (e.g. `MyAssistantBot`)
4. Copy the token BotFather gives you — it looks like `1234567890:AAFxxxxxxx`

Keep this token handy for the next step.

---

### Step 3 — Clone and install

```bash
git clone https://github.com/earlyaidopters/claudeclaw.git
cd claudeclaw
npm install
```

---

### Step 4 — Run the setup wizard

```bash
npm run setup
```

The wizard walks you through everything interactively:

- Checks your environment (Node, Claude CLI, builds if needed)
- Asks which features you want — voice input, voice output, video analysis, WhatsApp
- Offers to clone other Claw projects for inspiration (NanoClaw, OpenClaw, TinyClaw)
- Opens your editor to personalize `CLAUDE.md`
- Lists the skills you'll want to install and where to get them
- Prompts for API keys **only for the features you selected**
- Installs a background service (launchd on macOS, systemd on Linux, PM2 on Windows)

> **Prefer to let Claude handle it?** After cloning, `cd` into the repo, run `claude`, and paste:
> ```
> I just cloned ClaudeClaw. Please read README.md and set me up completely —
> install deps, configure .env, help me get any API keys I need, and set up
> the background service for my OS.
> ```

---

### Step 5 — Get your Telegram chat ID

Your chat ID locks the bot to you — no one else can use it.

1. Start the bot: `npm start`
2. Open Telegram and message your bot
3. Send `/chatid`
4. The bot replies with a number — that's your chat ID
5. Add it to `.env`:
   ```
   ALLOWED_CHAT_ID=your_number_here
   ```
6. Restart: stop the bot (Ctrl+C) and run `npm start` again

> The setup wizard does this step automatically if you run `npm run setup` before starting.

---

### Step 6 — Send your first message

With the bot running, send any message. Try:

```
What can you do?
```

or

```
Check my calendar for today
```

or just start talking. Claude Code is running on your machine — it has access to your files, the web, and every skill you've installed.

---

### Step 7 — Run as a background service

You probably want ClaudeClaw running automatically, not manually in a terminal.

**macOS** — the setup wizard installs a launchd agent. Or manually:
```bash
# After running npm run setup, it's already installed.
# Logs:
tail -f /tmp/claudeclaw.log
```

**Linux** — the setup wizard installs a systemd user service:
```bash
systemctl --user status claudeclaw
journalctl --user -u claudeclaw -f
```

**Windows** — use WSL2 (recommended) and follow the Linux steps, or:
```bash
npm install -g pm2
pm2 start dist/index.js --name claudeclaw
pm2 save && pm2 startup
```

---

### Step 8 — Check everything is healthy

```bash
npm run status
```

Output looks like:
```
  ✓  Node v22.3.0
  ✓  Claude CLI 1.0.12
  ✓  Bot token: @YourBotName
  ✓  Chat ID: 1234567890
  ✓  Voice STT: Groq (configured)
  ⚠  Voice TTS: not configured
  ✓  Service: running (PID 12345)
  ✓  Memory DB: 47 memories stored
  ─────────────────
  All systems go.
```

---

## Updating ClaudeClaw

When a new version is released, update in 4 commands:

```bash
cd claudeclaw          # go to your ClaudeClaw directory
git pull               # pull the latest code
npm install            # install any new dependencies
npm run build          # recompile TypeScript
```

Then restart the bot (Ctrl+C and `npm start`, or restart the background service).

**Do not** point Claude at the GitHub URL to read updates. Claude works with local files, so you need the repo cloned on your machine. `git pull` is how you stay current.

**Upgrading from V1?** If you heavily customized V1, start fresh with V2 and copy over your `.env` and any CLAUDE.md customizations. If you kept V1 mostly stock, `git pull` will work.

---

## How it works

![ClaudeClaw architecture](assets/architecture.jpeg)

## What's included

### Zero extra API keys needed

With just `TELEGRAM_BOT_TOKEN` and `ALLOWED_CHAT_ID`:

| Feature | Works? | Notes |
|---------|--------|-------|
| Text messaging | ✅ | Full Claude Code, all tools |
| Photos | ✅ | Claude reads and analyzes them |
| Documents | ✅ | PDF, code, text — anything Claude Code can open |
| SQLite memory | ✅ | Auto-initialized on first run, nothing to configure |
| Session persistence | ✅ | Context carries across every message |
| Scheduled tasks | ✅ | Ask Claude to run anything on a cron schedule |
| All your skills | ✅ | Every skill in `~/.claude/skills/` auto-loads |
| WhatsApp (`/wa`) | ✅ | No API key, but needs the wa-daemon running |
| Voice input | ❌ | Needs `GROQ_API_KEY` |
| Voice output | ❌ | Needs `ELEVENLABS_API_KEY` + `ELEVENLABS_VOICE_ID` |
| Video analysis | ❌ | Needs `GOOGLE_API_KEY` + `gemini-api-dev` skill |

---

## API keys — what each does and alternatives

### Telegram Bot Token (required)

**Get it:** [@BotFather](https://t.me/botfather) → `/newbot` — free, instant.

---

### Groq — voice input (optional)

**What it does:** Transcribes your voice notes using Whisper before passing them to Claude.

**Get it:** [console.groq.com](https://console.groq.com) — free tier, no card needed.

**Model:** `whisper-large-v3`

| Alternative | Cost | Notes |
|-------------|------|-------|
| **Groq** (default) | Free | Fastest to set up |
| OpenAI Whisper | ~$0.006/min | Swap `transcribeAudio()` in `src/voice.ts` |
| AssemblyAI | Free tier | More features |
| Local Whisper.cpp | Free | No API, runs on your Mac — needs code change |

---

### ElevenLabs — voice output (optional)

**What it does:** Converts Claude's responses to audio in your cloned voice.

**Get it:** [elevenlabs.io](https://elevenlabs.io) → clone your voice under "Voice Lab" → copy the Voice ID string.

**Model:** `eleven_turbo_v2_5`

**Tuning:** Edit `src/voice.ts` if the cloned voice sounds off:
```
stability: 0.5        (higher = more consistent but robotic)
similarity_boost: 0.75  (higher = closer to you but can distort)
```

| Alternative | Cost | Notes |
|-------------|------|-------|
| **ElevenLabs** (default) | Free tier + paid | Best cloning quality |
| OpenAI TTS | ~$0.015/1k chars | Good quality, no cloning |
| Google Cloud TTS | Free tier | More robotic |
| Coqui TTS | Free, open source | Run locally — needs code change |

---

### Google — video analysis (optional)

**What it does:** Analyzes videos you send using Gemini. Also handles images, audio, function calling, structured output, and code execution via the `gemini-api-dev` skill.

**Get it:** [aistudio.google.com](https://aistudio.google.com) → "Get API key" — free tier.

**Skill to install:** The `gemini-api-dev` skill is published by Google at:
- Skill docs: [github.com/google-gemini/gemini-skills/.../gemini-api-dev/SKILL.md](https://github.com/google-gemini/gemini-skills/blob/main/skills/gemini-api-dev/SKILL.md)
- Repo: [github.com/google-gemini/gemini-skills](https://github.com/google-gemini/gemini-skills)
- Install: copy the `gemini-api-dev` folder into `~/.claude/skills/`

The skill reads `GOOGLE_API_KEY` from the environment automatically.

---

### Anthropic API key (optional)

**What it does:** Bypasses your Max subscription and uses pay-per-token billing instead.

**When to use it:** Server deployments, or if you want zero ambiguity about billing. The Max plan assumes "ordinary individual usage" — an always-on bot can hit limits faster than expected.

**Get it:** [console.anthropic.com](https://console.anthropic.com)

---

## Default behaviors

### Voice notes → text reply (default)

![Voice pipeline](assets/voice-pipeline.jpeg)

Sending a voice note transcribes it and executes it as a command. **The reply comes back as text by default** — not audio.

To get a voice reply back from a specific voice note, say one of these anywhere in your message:
```
"respond with voice"    "respond via voice"    "respond in voice"
"send me a voice note"  "send a voice back"    "voice reply"
"reply with voice"      "reply via voice"
```

To toggle voice replies on permanently for all messages, send `/voice`. Send it again to turn it off. Resets on restart.

If ElevenLabs fails for any reason, it falls back to text automatically.

### Voice pipeline

```
Voice note sent
  ↓
.oga file downloaded → renamed .ogg (Groq requires this)
  ↓
Groq Whisper → transcribed text
  ↓
Check for voice-back trigger phrases
  ├── found → Claude runs → ElevenLabs TTS → audio reply
  └── not found → Claude runs → text reply
```

### Photos → analyzed immediately

Send a photo with or without a caption. Caption becomes the instruction. No caption — Claude describes what it sees.

### Documents → read and processed

Any file Claude Code can open: PDFs, code, markdown, CSV, plain text. Caption is the instruction.

### Videos → Gemini analysis

ClaudeClaw downloads the video to `workspace/uploads/` and tells Claude to analyze it with the `gemini-api-dev` skill. Without `GOOGLE_API_KEY`, Claude receives the file path but can't understand the content. Telegram caps downloads at 20MB.

### Sessions persist

Claude Code sessions carry full context across messages. Reference something from earlier — Claude knows. Send `/newchat` to start fresh.

### Skills load automatically

Every skill in `~/.claude/skills/` loads on every session. Call them directly (`/gmail check inbox`) or describe what you want — Claude routes automatically if you've listed the skill in `CLAUDE.md`.

---

## Bot commands

| Command | What it does |
|---------|-------------|
| `/start` | Confirm the bot is online |
| `/chatid` | Get your Telegram chat ID |
| `/newchat` | Start a fresh Claude Code session |
| `/respin` | After `/newchat`, pull the last 20 conversation turns back as context |
| `/voice` | Toggle voice response mode on/off |
| `/memory` | Show recent memories for this chat |
| `/forget` | Clear current session |
| `/wa` | Open the WhatsApp interface |
| `/slack` | Open the Slack interface |

Any other `/command` passes through to Claude and routes to the matching skill.

### /newchat + /respin workflow

Context windows fill up over long conversations. When things start feeling off or Claude starts missing context:

1. Send `/newchat` to start a completely fresh session
2. Send `/respin` immediately after

`/respin` pulls the last 20 conversation turns from the database and feeds them back into the new session as context. Claude sees what you discussed recently without carrying the full token weight of the old session. It's like a soft restart.

The pulled-in turns are marked as historical context (not new messages), so Claude treats them as background rather than active conversation.

### /slack interface

Send `/slack` to enter Slack mode. It works like the WhatsApp interface:

```
/slack           list recent conversations (unread first)
1                open conversation #1, show last 15 messages
r <text>         reply to the open conversation
r 2 <text>       quick-reply to conversation #2 without opening it
```

Type anything that isn't a number or `r <text>` to exit Slack mode and return to normal Claude.

---

## Slack (optional)

Requires a Slack User OAuth Token. This connects to your workspace so ClaudeClaw can read and send messages on your behalf.

### Step 1 — Create a Slack app

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Click the green **Create New App** button (top right)
3. In the popup, choose **From scratch** (not "From an app manifest")
4. Fill in:
   - **App Name**: anything you want (e.g. `ClaudeClaw`)
   - **Pick a workspace**: select the Slack workspace you want to connect
5. Click **Create App**

You'll land on the **Basic Information** page for your new app.

### Step 2 — Add User Token Scopes

This is the critical step. You need to add permissions so the app can read and send messages as you.

1. In the **left sidebar**, click **OAuth & Permissions**
2. Scroll down past "OAuth Tokens for Your Workspace" until you see the **Scopes** section
3. You'll see two subsections: **Bot Token Scopes** and **User Token Scopes**
4. **Ignore Bot Token Scopes entirely.** Click **Add an OAuth Scope** under **User Token Scopes**
5. Add each of these scopes one at a time (click **Add an OAuth Scope**, type the name, select it):

   | Scope | Description |
   |-------|-------------|
   | `channels:history` | View messages and other content in public channels |
   | `channels:read` | View basic information about public channels in a workspace |
   | `chat:write` | Send messages on a user's behalf |
   | `groups:history` | View messages and other content in private channels |
   | `groups:read` | View basic information about private channels |
   | `im:history` | View messages and other content in direct messages |
   | `im:read` | View basic information about direct messages |
   | `mpim:history` | View messages and other content in group direct messages |
   | `mpim:read` | View basic information about group direct messages |
   | `search:read` | Search a workspace's content |
   | `users:read` | View people in a workspace |

   After adding all 11, your User Token Scopes section should show all of them listed.

### Step 3 — Install the app to your workspace

1. Scroll back up to the top of the **OAuth & Permissions** page
2. Under **OAuth Tokens for Your Workspace**, click **Install to Workspace**
3. Slack will show a permissions screen listing everything the app can do
4. Click **Allow**
5. You'll be redirected back to the OAuth & Permissions page
6. You'll now see a **User OAuth Token** field with a token that starts with `xoxp-`
7. Click **Copy** to copy the token

### Step 4 — Add the token to ClaudeClaw

1. Open your `.env` file in the ClaudeClaw project directory
2. Add the token:
   ```
   SLACK_USER_TOKEN=xoxp-your-token-here
   ```
3. Restart ClaudeClaw

### Step 5 — Verify it works

Send `/slack` in your Telegram chat. You should see a numbered list of your recent Slack conversations with unread counts.

If you get "Slack not connected", double-check:
- The token starts with `xoxp-` (not `xoxb-` which is a bot token)
- The `.env` file has no extra spaces around the `=` sign
- You restarted ClaudeClaw after adding the token

### Using Slack from Claude Code (skill)

ClaudeClaw ships with a Slack CLI at `dist/slack-cli.js` and a matching skill in `skills/slack/`. To use Slack via natural language from any Claude Code session:

```bash
cp -r skills/slack ~/.claude/skills/slack
```

Then just say "check my slack" or "message Jane on slack saying hey" and Claude handles the rest.

### Slack CLI reference

```bash
cd /path/to/claudeclaw

node dist/slack-cli.js list              # List conversations with unread counts
node dist/slack-cli.js list --limit 10   # Limit results
node dist/slack-cli.js read <channel_id> # Read messages from a conversation
node dist/slack-cli.js send <channel_id> "message"  # Send a message
node dist/slack-cli.js send <channel_id> "reply" --thread-ts 1234.5678  # Thread reply
node dist/slack-cli.js search "jane"     # Find conversations by name
```

---

## WhatsApp (optional)

![WhatsApp bridge](assets/whatsapp-bridge.jpeg)

No API key needed. Uses your existing WhatsApp account via Linked Devices.

### Start the daemon

```bash
npx tsx scripts/wa-daemon.ts
```

A QR code prints. Open WhatsApp → Settings → Linked Devices → scan within 30 seconds. Session saves to `store/waweb/` — you only scan once.

### Use it from Telegram

```
/wa              list 5 most recent chats (unread first)
1                open chat #1, show last 10 messages
r <text>         reply to the open chat
r 2 <text>       quick-reply to chat #2 without opening it
```

### Incoming message notifications

When someone messages you on WhatsApp:
```
📱 John Smith — new message
/wa to view & reply
```

No content is forwarded automatically. You pull it on demand.

### How the outbox works

Messages you send via the bot go into a `wa_outbox` SQLite table. The daemon's outbox poller (every 3 seconds) picks them up and delivers them. If the daemon is temporarily down, messages queue and deliver when it comes back.

---

## Memory

![ClaudeClaw memory system diagram](assets/memory-diagram.jpeg)

ClaudeClaw has three layers of context working simultaneously, all automatic, nothing to configure.

### Layer 1 — Session resumption

Every time you send a message, Claude Code resumes the same session using a stored session ID. This means Claude carries your full conversation history — tool use, reasoning, prior decisions — across messages without you re-sending anything. It's the same as if you never left the terminal.

Use `/newchat` to start a completely fresh session when you want a clean slate.

### Layer 2 — SQLite memory with FTS5 search

Every meaningful message is saved to SQLite with a salience score and automatically recalled on relevant future messages. This works across `/newchat` resets — it's persistent, not session-bound.

**How saving works:**

| Message type | Sector | Decay rate |
|-------------|--------|-----------|
| Contains: `my`, `I am`, `I prefer`, `remember`, `always`, `never` | `semantic` | Slow — long-lived |
| Any other message over 20 chars (not a `/command`) | `episodic` | Faster |

**How salience works:**
- Every memory starts at `1.0`
- Each time a memory is retrieved and used: `+0.1` (capped at `5.0`)
- Every day, all memories older than 24 hours: `× 0.98` (2% decay)
- When salience drops below `0.1`: automatically deleted

Things you mention often survive longer. Things you only said once fade away.

### Layer 3 — Context injection

Before every message you send, two searches run in parallel:
1. **FTS5 keyword search** — matches your message text against all stored memories, returns top 3
2. **Recency fallback** — the 5 most recently accessed memories

The results are deduplicated and prepended to your message as a block Claude sees:

```
[Memory context]
- you prefer short bullet replies over long paragraphs (semantic)
- working on the YouTube channel rebrand this week (episodic)
- always send Telegram updates for heavy tasks (semantic)
[End memory context]
```

Claude uses this to answer without you re-explaining context every time.

### Commands

```
/memory    show the most recent memories stored for this chat
/forget    clear the current session (memories keep decaying naturally)
```

### Changing how memory works

Memory behavior is controlled by two files you can edit:

**`src/memory.ts`** — controls what gets saved and when:
```typescript
const SEMANTIC_SIGNALS = /\b(my|i am|i'm|i prefer|remember|always|never)\b/i;
```
Add words to this regex to make more things save as long-lived semantic memories.

**`src/db.ts`** — controls decay constants:
```typescript
db.prepare('UPDATE memories SET salience = salience * 0.98 WHERE ...')  // decay rate
db.prepare('DELETE FROM memories WHERE salience < 0.1')                 // deletion threshold
```

**Prompts you can send Claude to manage memory:**

```
"Remember that I always want responses in bullet points"
→ Saved as semantic memory (high salience, slow decay)

"Remember my Obsidian vault is at ~/Documents/Notes"
→ Saved as semantic memory

"What do you remember about me?"
→ Claude searches memories and summarizes

"Forget everything we've talked about today"
→ Tell Claude to run: DELETE FROM memories WHERE created_at > strftime('%s','now','-1 day')

"Show me all my stored memories"
→ Claude runs: SELECT content, sector, salience FROM memories ORDER BY salience DESC
```

You can also ask Claude to manually insert a high-salience memory about anything:
```
"Remember permanently that I run a YouTube channel about AI and my timezone is EST"
```
Claude will insert it directly into the memories table with high salience.

---

## Scheduled tasks

Tell Claude what you want, in plain language:

```
Every Monday at 9am, summarize AI news from the past week and send it to me
Every weekday at 8am, check my calendar and inbox and give me a briefing
Every 4 hours, check for new emails from clients and flag anything urgent
```

Claude creates and manages tasks via the built-in CLI. Manage them directly too:

```bash
node dist/schedule-cli.js list
node dist/schedule-cli.js create "summarize AI news" "0 9 * * 1"
node dist/schedule-cli.js pause <id>
node dist/schedule-cli.js delete <id>
```

| Cron pattern | Meaning |
|-------------|---------|
| `0 9 * * 1` | Every Monday at 9am |
| `0 8 * * 1-5` | Every weekday at 8am |
| `0 9 1 * *` | First of the month at 9am |
| `0 */4 * * *` | Every 4 hours |
| `0 7 * * *` | Every day at 7am |

---

## Database

ClaudeClaw ships with SQLite and **creates everything automatically on first run**. No migrations, no setup, no external database server. File lives at `store/claudeclaw.db`.

**Schema:**

```sql
sessions         -- Claude Code session IDs, one per chat
memories         -- Conversation memory with FTS5 search and salience decay
memories_fts     -- Virtual FTS5 table, auto-synced via triggers
scheduled_tasks  -- Cron-scheduled autonomous tasks
wa_message_map   -- Maps Telegram message IDs to WhatsApp chats
wa_outbox        -- Queued outgoing WhatsApp messages
wa_messages      -- Incoming WhatsApp message history
slack_messages   -- Slack message history
conversation_log -- Full conversation turns (used by /respin)
```

Inspect it directly:

```bash
sqlite3 store/claudeclaw.db

SELECT * FROM memories ORDER BY accessed_at DESC LIMIT 10;
SELECT * FROM scheduled_tasks;
SELECT * FROM sessions;
SELECT * FROM wa_outbox WHERE sent_at IS NULL;
```

---

## Customizing your assistant (CLAUDE.md)

`CLAUDE.md` is loaded into every Claude Code session. It's the personality and context file — the main thing to edit to make ClaudeClaw yours.

The sections that matter most:

**Personality rules** — Be specific. "No em dashes, ever" and "don't narrate what you're about to do, just do it" change behavior on every single message.

**Who you are** — What you do, your projects, your context. The more specific, the less you have to explain per message.

**Your environment** — File paths Claude should be able to reach without being told: your Obsidian vault, project directories, anything you reference regularly.

**Skills table** — Maps skill names to trigger phrases. This teaches Claude to invoke them automatically when you describe a task.

**Message format** — How responses should look in Telegram: tight and scannable, summary-first for long outputs, how to handle task lists.

---

## Customizing the ASCII art

The startup banner is in `banner.txt` at the project root. Replace it with anything or leave it empty. It's read fresh on every start.

---

## Skills to install

ClaudeClaw auto-loads every skill in `~/.claude/skills/`. Install a skill by copying its folder there.

### Bundled skills

ClaudeClaw ships with ready-to-use skills in the `skills/` directory. Copy any of these to activate them:

```bash
# Gmail — read, triage, reply, send, create filters
cp -r skills/gmail ~/.claude/skills/gmail

# Google Calendar — schedule meetings, check availability, send invites
cp -r skills/google-calendar ~/.claude/skills/google-calendar

# Slack — list conversations, read messages, send replies
cp -r skills/slack ~/.claude/skills/slack
```

**Gmail + Calendar require Google OAuth credentials.** See `.env.example` for the variables and each skill's `SKILL.md` for one-time setup instructions (create a Google Cloud project, enable the API, download credentials, run auth once).

**Slack requires a User OAuth Token.** See the [Slack setup section](#slack-optional) above for step-by-step instructions.

### Other recommended skills

- `todo` — read tasks from Obsidian or text files
- `agent-browser` — browse the web, fill forms, scrape data
- `maestro` — run multiple tasks in parallel with sub-agents

**For video analysis:**
- `gemini-api-dev` — published by Google, handles video/image/audio/text
  - Docs: [github.com/google-gemini/gemini-skills/.../gemini-api-dev/SKILL.md](https://github.com/google-gemini/gemini-skills/blob/main/skills/gemini-api-dev/SKILL.md)
  - Install: copy the `gemini-api-dev` folder to `~/.claude/skills/`

Browse more: [github.com/anthropics/claude-code](https://github.com/anthropics/claude-code)

---

## Configuration reference

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | From [@BotFather](https://t.me/botfather) |
| `ALLOWED_CHAT_ID` | Yes | Your chat ID — send `/chatid` to get it |
| `ANTHROPIC_API_KEY` | No | Pay-per-token instead of Max subscription |
| `GROQ_API_KEY` | No | Voice input — [console.groq.com](https://console.groq.com) |
| `ELEVENLABS_API_KEY` | No | Voice output — [elevenlabs.io](https://elevenlabs.io) |
| `ELEVENLABS_VOICE_ID` | No | Your ElevenLabs voice ID string |
| `GOOGLE_API_KEY` | No | Gemini — [aistudio.google.com](https://aistudio.google.com) |
| `SLACK_USER_TOKEN` | No | Slack User OAuth Token (starts with `xoxp-`) |
| `GOOGLE_CREDS_PATH` | No | Path to Google OAuth credentials.json (default: `~/.config/gmail/credentials.json`) |
| `GMAIL_TOKEN_PATH` | No | Path to Gmail OAuth token (default: `~/.config/gmail/token.json`) |
| `GCAL_TOKEN_PATH` | No | Path to Calendar OAuth token (default: `~/.config/calendar/token.json`) |
| `CLAUDE_CODE_OAUTH_TOKEN` | No | Override which Claude account is used |

---

## Available scripts

```bash
npm run setup     # Interactive setup wizard
npm run status    # Health check — env, bot, DB, service
npm run build     # Compile TypeScript → dist/
npm start         # Run compiled bot (production)
npm run dev       # Run with tsx, no build needed (development)
npm test          # Run test suite (vitest)
npm run typecheck # Type-check without compiling
```

---

## Is this compliant with Anthropic's Terms of Service?

**Yes.** On February 19, 2026, Anthropic published their [Legal and Compliance page](https://docs.anthropic.com/en/docs/legal-and-compliance) banning OAuth tokens in third-party tools. ClaudeClaw is not affected.

**What's banned:** Tools that extract your OAuth token and make API calls with it from third-party code — impersonating Claude Code without running it (e.g. the old OpenClaw).

**Why ClaudeClaw is different:** `@anthropic-ai/claude-agent-sdk`'s `query()` spawns the `claude` binary as a child process. That subprocess manages its own OAuth from `~/.claude/`. ClaudeClaw never reads or transmits your token. It runs Claude Code and reads the output — identical to `claude -p "message"` in a terminal.

| | ClaudeClaw | Token-extraction tools |
|---|---|---|
| Runs the official `claude` CLI | ✅ | ❌ |
| OAuth stays in `~/.claude/` | ✅ | ❌ |
| Uses Anthropic-published SDK | ✅ | ❌ |
| Single-user, personal machine | ✅ | ❌ |
| Anthropic telemetry intact | ✅ | ❌ |

For server or multi-user deployments, set `ANTHROPIC_API_KEY` to use pay-per-token billing.

---

## Security notes

ClaudeClaw is designed to run on your personal machine for your own use. A few things to be aware of:

**`bypassPermissions` mode.** The bot runs Claude Code with `permissionMode: 'bypassPermissions'`. This is required because there's no terminal to approve tool-use prompts. It means Claude can execute any tool (shell commands, file reads, web requests) without confirmation. This is safe when the bot is locked to your chat ID on your own machine. Do not expose it to untrusted users.

**WhatsApp daemon runs on localhost only.** The `wa-daemon` HTTP API (port 4242) and Chrome DevTools Protocol (port 9222) bind to `127.0.0.1`. They are not accessible from outside your machine, but any process running locally can reach them. If you run untrusted code on the same machine, be aware that it could interact with your WhatsApp session.

**`notify.sh` is called by Claude.** The notification script sends Telegram messages via `curl`. Since Claude has full shell access, it can call this script with any content. This is by design (it's how progress updates work), but be aware that prompt injection via external content (web pages, files) could theoretically cause Claude to send unexpected messages.

**Set `ALLOWED_CHAT_ID` immediately.** Until this is set, the bot responds to any Telegram user who messages it. The setup wizard helps you configure this, but if you start the bot manually before setting it, it's open to everyone who knows the bot username.

---

## Troubleshooting

**Bot doesn't respond**
- Check `ALLOWED_CHAT_ID` matches the number from `/chatid`
- Check logs: `tail -f /tmp/claudeclaw.log`
- Run `npm run status` for a full health check
- Verify Claude auth: `claude --version`
- **macOS:** Check if your Mac is showing "Node wants to access..." permission dialogs. The bot hangs until you click Allow. This is easy to miss if your Mac screen is off or in the background.

**Setup fails at bracket placeholders**
- `CLAUDE.md` ships with `[BRACKETED]` placeholder values like `[YOUR NAME]` and `[YOUR ASSISTANT NAME]`
- These **must** be replaced before the bot can work properly
- The setup wizard opens `CLAUDE.md` in your editor for this, but if you skip it or your editor doesn't save, edit it manually: open `CLAUDE.md` in any text editor, find/replace all `[BRACKETED]` values with your actual info
- You do **not** need to fill in every bracket. At minimum: `[YOUR ASSISTANT NAME]`, `[YOUR NAME]`, and `[PATH TO CLAUDECLAW]` (the full path to your claudeclaw directory)

**Git errors during setup**
- "Please tell me who you are" — run `git config --global user.name "Your Name"` and `git config --global user.email "you@email.com"`
- Git needs these set once, globally, before it can do anything

**Can't access the internet / "break out"**
- ClaudeClaw runs the real Claude Code CLI, which has full internet access through its built-in tools (web search, web fetch, bash with curl, etc.)
- If Claude says it can't access the internet, it's likely a skill or prompt issue, not a ClaudeClaw limitation
- Make sure your Claude Code CLI works in the terminal first: open a terminal, run `claude`, and ask it to search the web

**Voice notes return an error**
- `GROQ_API_KEY` must be in `.env` and the bot restarted after adding it

**Voice replies not working**
- Both `ELEVENLABS_API_KEY` and `ELEVENLABS_VOICE_ID` must be set
- Voice ID is a string like `21m00Tcm4TlvDq8ikWAM`, not the voice name
- Either `/voice` mode must be on, or say "respond with voice" in your message

**WhatsApp not connecting**
- `wa-daemon` must be running separately: `npx tsx scripts/wa-daemon.ts`
- QR code expires after ~30s — kill and restart the daemon if it timed out
- To force re-authentication, delete `store/waweb/` and restart the daemon

**"409 Conflict: terminated by other getUpdates request"**
- Two instances running. Kill the old one: `kill $(cat store/claudeclaw.pid)`

**Session feels off or confused**
- Send `/newchat` for a fresh start

**File downloads fail**
- Telegram caps downloads at 20MB — this is a Telegram API limit, not a ClaudeClaw one

---

## Common confusions

**"Do I need the mega prompt / Rebuild_Prompt.md?"**
No. There is no separate prompt to execute and no `Rebuild_Prompt.md` file. `CLAUDE.md` in the repo **is** the prompt — it loads automatically into every Claude Code session. You personalize it once (replace the `[BRACKETED]` placeholders with your info) and forget about it. Just clone the repo, run setup, and go. When you `git pull` updates, your personalized `.env` stays untouched (gitignored) and `CLAUDE.md` changes are merged by git.

**"Does this use Claude Remote?"**
No. ClaudeClaw has nothing to do with Anthropic's Remote product. It runs the `claude` CLI locally on your own machine (Mac, Linux, or Windows via WSL2) and pipes results to Telegram. No cloud VMs, no remote sessions.

**"Does this work on Windows?"**
Yes, through WSL2. Install WSL2, clone ClaudeClaw inside the WSL filesystem, and follow the normal Linux setup steps. The setup wizard detects Windows and offers WSL2 or PM2 options.

**"What is GOOGLE_API_KEY for?"**
Video analysis via Google Gemini. It is **not** for Gmail or Google Calendar (those use separate OAuth credentials via the gmail and google-calendar skills). Get it free at [aistudio.google.com](https://aistudio.google.com).

**"Should I watch the Claude Code video first?"**
Recommended but not required. The video covers how Claude Code works under the hood, which helps you understand what ClaudeClaw is actually doing. But you can set up ClaudeClaw first and watch it later.

**"How do I update when a new version drops?"**
`cd claudeclaw && git pull && npm install && npm run build` then restart. See [Updating ClaudeClaw](#updating-claudeclaw) above.

**"Telegram formatting looks broken / not formatting properly"**
ClaudeClaw converts Claude's Markdown to Telegram-safe HTML (bold, italic, code blocks, links). Telegram's formatting support is limited compared to a full web page. If something looks off, it's usually Telegram's rendering, not a bug. For very long or complex responses, the formatting is intentionally kept simple to avoid Telegram parse errors.

**"Can I add extra security like 2FA?"**
`ALLOWED_CHAT_ID` restricts the bot to your Telegram account, which is the default security layer. Community members have added Google Authenticator (TOTP) for tiered permissions (read-only vs elevated actions with time-limited re-auth). This isn't built in yet, but it's a straightforward addition to `handleMessage()` in `src/bot.ts` if you want that extra layer.

---

## Architecture

```mermaid
flowchart TD
    Phone["📱 Telegram App"] -->|message| TGAPI["Telegram Bot API"]
    TGAPI -->|long-poll| Bot["bot.ts\n(grammy)"]

    Bot -->|voice note| STT["Groq Whisper\nTranscription"]
    Bot -->|photo / doc / video| DL["Media Download\nworkspace/uploads/"]
    STT --> Handler
    DL --> Handler
    Bot -->|text| Handler["handleMessage()"]

    Handler -->|FTS5 + recency| Mem["Memory Layer\nSQLite"]
    Mem -->|context block| Agent

    Agent["agent.ts\nClaude Agent SDK"] -->|spawns subprocess| CC["claude CLI\n~/.claude/ auth"]
    CC -->|loads| Config["CLAUDE.md\n+ ~/.claude/skills/"]
    CC -->|uses| Tools["Bash · Web · MCP\nFile system · APIs"]
    CC -->|result| Agent

    Agent --> Format["Format + Split\nMarkdown → HTML"]
    Format -->|reply| TGAPI

    Sched["Scheduler\ncron tasks"] -->|every 60s| Agent
    WA["WhatsApp daemon\n:4242"] --> Bot

    DB[("SQLite\nstore/claudeclaw.db")] --- Mem
    DB --- Sched
    DB --- WA
```

---

## Project structure

```
claudeclaw/
│
│  ← Files you'll actually touch
├── CLAUDE.md             ← START HERE: your assistant's personality and context
├── banner.txt            ← ASCII art shown on startup — edit or replace freely
├── .env                  ← Your API keys (created by setup wizard, gitignored)
│
│  ← Configuration and setup
├── .env.example          Template for .env — shows all available variables
├── claudeclaw.plist      macOS LaunchAgent template (setup wizard uses this)
├── package.json          npm scripts and dependencies
├── tsconfig.json         TypeScript compiler config
│
│  ← Bot source code (src/)
├── src/
│   ├── index.ts          Main entrypoint — starts everything
│   ├── bot.ts            Handles all Telegram messages (text, voice, photo, etc.)
│   ├── agent.ts          Runs Claude Code — the core integration
│   ├── db.ts             SQLite database — all tables and queries
│   ├── memory.ts         Memory saving, searching, and decay logic
│   ├── scheduler.ts      Cron task runner — fires tasks every 60 seconds
│   ├── voice.ts          Voice transcription (Groq) and synthesis (ElevenLabs)
│   ├── media.ts          Downloads files from Telegram, cleans up after 24h
│   ├── slack.ts           Slack API client (conversations, messages, send)
│   ├── slack-cli.ts       CLI wrapper for Slack (used by the slack skill)
│   ├── whatsapp.ts        WhatsApp client via whatsapp-web.js
│   ├── config.ts          Reads .env safely (never pollutes process.env)
│   ├── env.ts             Low-level .env file parser
│   └── schedule-cli.ts    CLI tool for managing scheduled tasks
│
│  ← Skills (copy to ~/.claude/skills/ to activate)
├── skills/
│   ├── gmail/SKILL.md     Gmail inbox management
│   ├── google-calendar/   Calendar events, invites, availability
│   └── slack/SKILL.md     Slack conversations and messages
│
│  ← Scripts (scripts/)
├── scripts/
│   ├── setup.ts          Interactive setup wizard — run with: npm run setup
│   ├── status.ts         Health check — run with: npm run status
│   ├── notify.sh         Sends a Telegram message from the shell (used by Claude)
│   └── wa-daemon.ts      WhatsApp daemon — run separately for WhatsApp bridge
│
│  ← Runtime data (auto-created, gitignored)
├── store/
│   ├── claudeclaw.db     SQLite database — created automatically on first run
│   ├── claudeclaw.pid    Tracks the running process to prevent duplicates
│   └── waweb/            WhatsApp session — scan QR once, persists here
│
└── workspace/
    └── uploads/          Telegram media downloads — auto-deleted after 24 hours
```

**The only files you need to edit to get started:**
1. `CLAUDE.md` — fill in your name, what you do, your file paths, your skills
2. `.env` — add your API keys (the setup wizard does this for you)

Everything else runs without modification.

---

## Other channels

The same `runAgent()` pattern in `src/agent.ts` works on any channel:

- **[NanoClaw](https://github.com/qwibitai/nanoclaw)** — WhatsApp, isolated Linux containers
- **[OpenClaw](https://github.com/openclaw/openclaw)** — Telegram, WhatsApp, Slack, Discord, iMessage, Signal, and more
- **[TinyClaw](https://github.com/jlia0/tinyclaw)** — ~400 lines of shell, Claude Code + tmux, zero dependencies

---

## License

MIT
