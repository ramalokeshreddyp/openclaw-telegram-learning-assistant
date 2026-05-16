# OpenClaw Telegram Learning Assistant 🦞

A personalized AI learning assistant that delivers daily curated technical content, interview questions, and insights tailored to your interests and experience level.

![Status](https://img.shields.io/badge/status-production--ready-brightgreen)
![Node](https://img.shields.io/badge/node-%3E%3D20.0.0-green)
![Docker](https://img.shields.io/badge/docker-%3E%3D24.0-blue)
![License](https://img.shields.io/badge/license-MIT-blue)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup Instructions](#detailed-setup-instructions)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Design Decisions](#design-decisions)
- [Project Structure](#project-structure)
- [Contributing](#contributing)

## Overview

This project implements a sophisticated Telegram bot powered by **OpenClaw**, an open-source personal AI assistant framework. The bot:

1. **Onboards new users** to understand their technical interests, experience level, and learning goals
2. **Conducts daily web searches** for fresh content in the user's domains of interest
3. **Generates personalized content** including 5 interview questions and 3-5 technical insights
4. **Delivers automated messages** every evening at 9 PM in the user's local timezone

The system showcases advanced AI agent patterns: skills-based instruction, tool integration, persistent memory management, and autonomous scheduling.

## Features

✨ **User Onboarding Workflow**
- Conversational, step-by-step user profiling
- Captures technical domains, experience level, learning goals, and timezone
- Persistent memory storage for user preferences

📚 **Daily Personalized Briefs**
- Web search integration for fresh, recent content
- AI-generated interview questions tailored to user's level
- Technical tidbits and insights from the latest industry trends
- Beautiful Telegram Markdown formatting

⏰ **Autonomous Scheduling**
- Cron-based job scheduling (runs at 9 PM user time)
- Timezone-aware delivery
- Reliable, repeatable execution

🎯 **Intelligent Content Generation**
- Difficulty-matched interview questions (junior to staff level)
- Question type variety (conceptual, coding, system design, behavioral)
- Freshness-aware search and content filtering
- Memory-based repetition avoidance

🔐 **Privacy-First Architecture**
- Self-hosted option with Ollama for local LLMs
- Optional cloud provider support (OpenAI, Anthropic, Google)
- All user data stored locally in persistent memory
- No dependency on external AI services for data analysis

## System Architecture

The system consists of several integrated components:

```
┌─────────────────────────────────────────────────────────────┐
│                    User on Telegram                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│         OpenClaw Gateway (Self-Hosted)                      │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Telegram Channel Plugin                             │  │
│  └────────────────┬─────────────────────────────────────┘  │
│                   │                                         │
│  ┌────────────────▼──────────┐                             │
│  │  Agent Core (LLM Powered) │                             │
│  │  - Claude/GPT-4/Llama3    │                             │
│  └────────────────┬──────────┘                             │
│                   │                                         │
│  ┌────────────────▼────────────────────────────────────┐  │
│  │        Skill Executor & Tool Integration            │  │
│  │  - user-onboarding/SKILL.md                         │  │
│  │  - daily-quiz/SKILL.md                              │  │
│  │  - web_search tool                                  │  │
│  │  - memory_store tool                                │  │
│  └────────────────┬─────────────────────────────────────┘  │
│                   │                                         │
│  ┌────────────────▼──────────┐  ┌──────────────────────┐  │
│  │  Persistent Memory Store   │  │  Cron Scheduler      │  │
│  │  (User Profiles, State)    │  │  (Daily Jobs)        │  │
│  └────────────────────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
    DuckDuckGo       Ollama LLM    (Optional)
    Web Search       Local Model   Cloud APIs
```

### Component Roles

| Component | Purpose |
|-----------|---------|
| **OpenClaw Gateway** | Central orchestrator managing all operations |
| **Telegram Plugin** | Bidirectional communication bridge with Telegram |
| **Agent Core** | LLM powered reasoning engine |
| **Skills** | Markdown-defined instruction sets for complex workflows |
| **Memory Store** | Persistent JSON-based user profiles and state |
| **Cron Scheduler** | Autonomous task execution at specified times |
| **Tool Executor** | Invokes web search, memory operations, and actions |

## Prerequisites

Before starting, ensure you have:

- **Node.js** >= 20.0.0 ([download](https://nodejs.org))
- **Docker** >= 24.0 ([download](https://www.docker.com))
- **Docker Compose** >= 2.0
- **Telegram** account and access to @BotFather
- **Git** (for cloning and version control)

### Optional (for cloud LLM provider)
- OpenAI API key (for GPT-4o)
- Anthropic API key (for Claude)
- Google API key (for Gemini)

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/openclaw-telegram-learning-assistant.git
cd openclaw-telegram-learning-assistant
```

### 2. Create Environment Configuration
```bash
cp .env.example .env
# Edit .env and set your TELEGRAM_BOT_TOKEN
# Get your token from BotFather on Telegram
nano .env
```

### 3. Start with Docker Compose
```bash
# Start all services (Ollama + OpenClaw Gateway)
docker-compose up --build

# Or, if you prefer to use SearXNG for search:
docker-compose --profile with-searxng up --build
```

### 4. Test the Bot
1. Open Telegram and find your bot
2. Send a message like "Hello"
3. The bot should initiate onboarding
4. Complete the user profile setup
5. Check back at 9 PM your timezone for your first daily brief!

That's it! The system handles everything else automatically.

## Detailed Setup Instructions

### Option A: Docker Setup (Recommended)

This is the easiest and most reliable method.

#### Step 1: Create Telegram Bot

1. Open Telegram and search for **@BotFather**
2. Send `/newbot`
3. Follow the prompts to create a bot with a name and username
4. Copy the **HTTP API Token** provided (keep it secret!)

#### Step 2: Configure Environment

```bash
# Clone the repository
git clone https://github.com/yourusername/openclaw-telegram-learning-assistant.git
cd openclaw-telegram-learning-assistant

# Copy example env file
cp .env.example .env

# Edit with your token
# On Linux/macOS:
nano .env

# On Windows (PowerShell):
notepad .env

# Add your token:
# TELEGRAM_BOT_TOKEN=YOUR_TOKEN_HERE
```

#### Step 3: Build and Run

```bash
# Build and start all services
docker-compose up --build

# On first run, Ollama will download the llama3:8b model (~5-10 minutes)
# You'll see logs like:
# openclaw-ollama | pulling manifest
# openclaw-ollama | pulling 3beb2c09aed9
# openclaw-ollama | verifying sha256 digest
```

#### Step 4: Verify Setup

Once you see `openclaw-gateway | Gateway started successfully`, open Telegram and:

1. Find your bot
2. Send "Hello"
3. Bot should start onboarding immediately
4. Complete the questions
5. Verify profile is saved

### Option B: Local Development Setup

If you prefer to run without Docker:

#### Step 1: Install OpenClaw

```bash
npm install -g openclaw
```

#### Step 2: Install and Start Ollama

Download and install Ollama from https://ollama.ai

```bash
# In a separate terminal, start Ollama
ollama serve

# In another terminal, pull the model
ollama pull llama3:8b
```

#### Step 3: Configure OpenClaw

```bash
# Run interactive onboarding
openclaw onboard

# Follow the prompts:
# 1. Choose provider: Ollama
# 2. Select model: llama3:8b
# 3. Web search: DuckDuckGo (or SearXNG)
```

#### Step 4: Configure Telegram

Edit `~/.openclaw/openclaw.json`:

```json
{
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true,
        "package": "@openclaw/plugin-telegram",
        "config": {
          "botToken": "YOUR_TELEGRAM_BOT_TOKEN"
        }
      }
    }
  }
}
```

#### Step 5: Copy Skills

```bash
# Create skill directories
mkdir -p ~/.openclaw/skills/user-onboarding
mkdir -p ~/.openclaw/skills/daily-quiz

# Copy skill files
cp skills/user-onboarding/SKILL.md ~/.openclaw/skills/user-onboarding/
cp skills/daily-quiz/SKILL.md ~/.openclaw/skills/daily-quiz/
```

#### Step 6: Start the Gateway

```bash
openclaw gateway start
```

#### Step 7: Configure Automation

```bash
# Add standing order for onboarding
openclaw standing-orders add \
  --name "trigger-user-onboarding" \
  --if "memory.user_profile_{{user.id}} does not exist" \
  --run-skill "user-onboarding"

# Add cron job for daily quiz (replace timezone as needed)
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram
```

## Configuration

### OpenClaw Configuration (`config/openclaw.json`)

The main configuration file controls:

```json
{
  "model": {
    "provider": "ollama",          // or "openai", "anthropic", etc.
    "model": "llama3:8b",
    "temperature": 0.7,            // Higher = more creative, lower = more deterministic
    "maxTokens": 2048
  },
  "webSearch": {
    "provider": "duckduckgo",      // or "searxng"
    "enabled": true
  },
  "plugins": {
    "entries": {
      "telegram": {
        "botToken": "${env.TELEGRAM_BOT_TOKEN}"
      }
    }
  }
}
```

### Environment Variables (`.env`)

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | Token from BotFather |
| `OPENAI_API_KEY` | No | For using GPT-4o instead of Ollama |
| `ANTHROPIC_API_KEY` | No | For using Claude instead of Ollama |
| `SEARXNG_URL` | No | URL of self-hosted SearXNG instance |

### Model Selection

#### Local (Ollama) - Recommended
- **Pros:** Free, private, no API calls
- **Cons:** Requires local compute resources
- **Models:** `llama3:8b`, `llama2:7b`, `mistral:7b`, `neural-chat:7b`

#### Cloud Providers
- **OpenAI:** Superior quality, requires API key
- **Anthropic:** Claude 3.5, excellent instruction following
- **Google:** Gemini, good balance of quality and speed

### Web Search Providers

#### DuckDuckGo (Default)
- No configuration needed
- Reliable, privacy-friendly
- Rate-limited for heavy use

#### SearXNG (Self-Hosted)
```bash
# Run with SearXNG
docker-compose --profile with-searxng up
```

## Usage

### User Workflow

#### First Time User: Onboarding

```
User: "Hello"
Bot: 👋 Welcome! I'm your personal AI learning assistant...
     To get started, what technical domains are you interested in?

User: "Python and machine learning"
Bot: Great! What's your experience level?
     (Please choose: junior, mid-level, senior, or staff)

User: "Mid-level"
Bot: What are your main learning goals?

User: "Preparing for interviews and staying updated"
Bot: Perfect! What timezone are you in?

User: "America/Los_Angeles"
Bot: Excellent! I've saved your profile. 
     Every evening at 9 PM your time, I'll send your daily brief.
```

#### Daily Brief Reception

At 9 PM in the user's timezone:

```
🦞 *Your Daily Tech Brief* — Jan 15, 2024

━━━━━━━━━━━━━━━━━━━━
🧠 *Interview Questions*
━━━━━━━━━━━━━━━━━━━━

*Q1 Conceptual — Python*
Explain the difference between @property and @classmethod decorators in Python.

*Q2 Coding — Machine Learning*
Write a function to calculate the F1-score given predictions and true labels...

[And 3 more questions]

━━━━━━━━━━━━━━━━━━━━
💡 *Today's Tidbits*
━━━━━━━━━━━━━━━━━━━━

• PyTorch 2.0's new compile() function can improve training speed by 50% on CUDA devices.

• The "Attention is All You Need" paper (2017) introduced transformers, now fundamental to all modern LLMs.

[And more tidbits]

━━━━━━━━━━━━━━━━━━━━
Reply *answers* to share your answers for feedback, or *more* for extra questions.
```

### User Commands

- **`answers`**: Reply with your answers to the interview questions for AI feedback
- **`more`**: Request 5 additional interview questions
- **`help`**: Get assistance commands
- **Any new message**: If you're a new user, initiates onboarding

### Admin Commands

Manage jobs and memory from the terminal (when gateway is running):

```bash
# View all cron jobs
openclaw cron list

# Trigger a job immediately
openclaw cron trigger "nightly-tech-brief"

# View user memory
openclaw memory get "user_profile_123456789"

# Update user memory
openclaw memory set "user_profile_123456789" '{"domains":["Go"],"level":"senior","goals":["interviews"],"timezone":"UTC"}'

# List standing orders
openclaw standing-orders list

# View gateway logs
openclaw gateway logs
```

## Troubleshooting

### Issue: "Bot doesn't respond to messages"

**Diagnosis:**
1. Check gateway is running: `docker-compose logs openclaw-gateway`
2. Verify token is correct: `grep TELEGRAM_BOT_TOKEN .env`
3. Confirm Ollama is ready: `curl http://localhost:11434/api/tags`

**Solution:**
```bash
# Restart services
docker-compose restart

# Check logs
docker-compose logs --tail=50 openclaw-gateway

# Recreate if corrupted
docker-compose down -v
docker-compose up --build
```

### Issue: "Memory operations failing"

**Symptoms:** User profiles not saving, errors like "memory_store tool failed"

**Solution:**
```bash
# Check memory volume is mounted
docker-compose exec openclaw-gateway ls -la /root/.openclaw/memory

# Verify permissions
docker-compose exec openclaw-gateway chmod -R 755 /root/.openclaw/memory

# Reset memory (WARNING: clears all user data)
docker-compose down -v
docker-compose up
```

### Issue: "Cron job not triggering at correct time"

**Diagnosis:**
1. Verify timezone is correct: `openclaw memory get "user_profile_{{user.id}}"`
2. Check cron job exists: `openclaw cron list`
3. View gateway logs at scheduled time

**Solution:**
```bash
# Test job manually
openclaw cron trigger "nightly-tech-brief"

# Update timezone
openclaw memory set "user_profile_123456789" '{"domains":[...],"timezone":"America/New_York"}'

# Recreate cron job with correct timezone
openclaw cron remove "nightly-tech-brief"
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the daily-quiz skill..." \
  --announce \
  --channel telegram
```

### Issue: "Web search returning irrelevant results"

**Solutions:**
1. Adjust search queries in `skills/daily-quiz/SKILL.md`
2. Switch to SearXNG for better control: `docker-compose --profile with-searxng up`
3. Add more specific domains during onboarding

### Issue: "LLM responses are too generic or off-topic"

**Solutions:**

1. Use a more powerful model:
```bash
# In .env, set OPENAI_API_KEY and update openclaw.json:
"model": {
  "provider": "openai",
  "model": "gpt-4o"
}
```

2. Improve skill instructions (edit `SKILL.md` files) with more context and examples

3. Increase temperature in `openclaw.json` for more creativity or decrease for consistency

## Design Decisions

### 1. Standing Orders vs. Webhooks for Onboarding Trigger

**Chosen:** Standing Orders

**Rationale:**
- **Simplicity:** No additional HTTP endpoint to maintain
- **Reliability:** Integrated with OpenClaw core, tested and proven
- **Efficiency:** Event-driven, not polling
- **Statefulness:** Works seamlessly with memory system

Alternative (Webhooks) would require:
- Additional REST endpoint
- Manual HTTP request routing
- More complex error handling
- Less integrated with OpenClaw architecture

### 2. Local Ollama vs. Cloud API

**Chosen:** Ollama with Cloud Fallback

**Rationale:**
- **Privacy:** All data stays on user's hardware
- **Cost:** Free (no per-request API charges)
- **Latency:** Faster response times
- **Independence:** Works offline if needed
- **Flexibility:** Easy model switching

Cloud options available for users prioritizing quality over cost/privacy.

### 3. Persistent Memory Architecture

**Chosen:** JSON-based key-value store with user ID isolation

**Structure:**
```
user_profile_{{user.id}}: Core preferences
recent_topics_{{user.id}}: Spaced repetition tracking
user_engagement_{{user.id}}: Learning analytics
last_brief_date_{{user.id}}: Scheduling state
```

**Rationale:**
- **Simplicity:** Easy to understand and debug
- **Queryability:** Fast lookups by user ID
- **Extensibility:** Add new fields without migration
- **Persistence:** Survives restarts
- **Privacy:** No external database required

### 4. Cron-Based Scheduling

**Chosen:** Built-in OpenClaw cron with timezone awareness

**Rationale:**
- **Accuracy:** Respects user timezones precisely
- **Autonomy:** No external scheduler needed
- **Reliability:** Part of gateway process, monitored together
- **History:** Logs all executions for debugging

### 5. Skill-Based Architecture

**Chosen:** Markdown-defined SKILL.md files, not Python/JS code

**Rationale:**
- **LLM-Native:** Leverages agent reasoning directly
- **Maintainability:** Update behavior without redeployment
- **Flexibility:** Supports both local and cloud LLMs
- **Iteration:** Change instructions, instant results
- **Understanding:** Clear intent vs. black-box code

## Project Structure

```
openclaw-telegram-learning-assistant/
├── skills/
│   ├── user-onboarding/
│   │   └── SKILL.md              # Onboarding workflow instructions
│   └── daily-quiz/
│       └── SKILL.md              # Daily quiz generation instructions
├── config/
│   └── openclaw.json             # OpenClaw configuration (no secrets)
├── Dockerfile                     # Container image definition
├── docker-compose.yml             # Multi-service orchestration
├── entrypoint.sh                  # Container startup script
├── .env.example                   # Environment variables template
├── README.md                       # This file
├── .gitignore                      # Git ignore rules
└── .github/
    └── workflows/
        └── tests.yml              # CI/CD pipeline (optional)
```

### File Purposes

| File | Purpose |
|------|---------|
| `skills/user-onboarding/SKILL.md` | Defines conversational flow for collecting user preferences |
| `skills/daily-quiz/SKILL.md` | Defines algorithm for generating personalized daily content |
| `config/openclaw.json` | Central configuration: model, plugins, memory, automation |
| `Dockerfile` | Builds container image with OpenClaw and skills |
| `docker-compose.yml` | Orchestrates Ollama, OpenClaw Gateway, optionally SearXNG |
| `entrypoint.sh` | Startup script that ensures dependencies are ready |
| `.env.example` | Template showing all environment variables |
| `.gitignore` | Prevents committing .env, secrets, and dependencies |

## Security Considerations

### Secrets Management

✅ **Do:**
- Store tokens in `.env` file (not in git)
- Use `${env.VARIABLE_NAME}` syntax in `openclaw.json`
- Rotate Telegram token if compromised
- Use strong API keys from your cloud providers

❌ **Don't:**
- Commit `.env` to git
- Hardcode secrets in configuration files
- Share bot token in public repositories
- Log sensitive information

### Data Privacy

- All user profiles stored locally in container volume
- No data sent to external services (except configured LLM/search providers)
- Users can request their data deletion (purge memory)
- Optional: Use local Ollama to avoid any cloud calls

## Contributing

Contributions welcome! Areas for enhancement:

- [ ] Spaced repetition algorithm for questions
- [ ] User feedback integration for dynamic difficulty
- [ ] Multi-language support
- [ ] Analytics dashboard
- [ ] Question bank deduplication
- [ ] Advanced filtering for web search results
- [ ] Integration with code sandbox tools
- [ ] Batch user management

## Support & Resources

- **OpenClaw Documentation:** https://github.com/openclaw/openclaw
- **Telegram Bot API:** https://core.telegram.org/bots/api
- **Ollama Models:** https://ollama.ai/library
- **Issue Tracker:** GitHub Issues (link)
- **Community:** OpenClaw Discord/GitHub Discussions

## License

MIT License - see LICENSE file for details

## Acknowledgments

Built with:
- **OpenClaw** - Open-source personal AI framework
- **Ollama** - Local LLM execution
- **Telegram** - Communication platform
- **Node.js** - Runtime environment

---

**Ready to boost your learning?** Start with Quick Start section above! 🚀
