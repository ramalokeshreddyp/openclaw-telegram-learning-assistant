# SETUP_COMMANDS.md

# Complete OpenClaw Setup Commands Reference

This document provides all the commands needed to set up and run the Personalized AI Learning Assistant.

## Prerequisites Verification

```bash
# Check Node.js
node --version  # Should be >= 20.0.0

# Check Docker
docker --version

# Check Docker Compose
docker-compose --version
```

## Quick Start (Recommended: Docker)

```bash
# 1. Clone and navigate
git clone https://github.com/ramalokeshreddyp/openclaw-telegram-learning-assistant.git
cd openclaw-telegram-learning-assistant

# 2. Create .env file
cp .env.example .env

# 3. Edit .env with your Telegram bot token
# nano .env  (or use your editor)

# 4. Build and start services
docker-compose up --build

# 5. In Telegram, message your bot to test
# Bot should start onboarding flow
```

## Local Development Setup (Without Docker)

### Step 1: Install OpenClaw Globally
```bash
npm install -g openclaw

# Verify installation
openclaw --version
```

### Step 2: Install and Start Ollama
```bash
# Download from https://ollama.ai
# Or on Linux/macOS:
curl -fsSL https://ollama.ai/install.sh | sh

# In a separate terminal window, start Ollama server:
ollama serve

# In another terminal, pull the model:
ollama pull llama3:8b

# Verify Ollama is working:
curl http://localhost:11434/api/tags
```

### Step 3: Run OpenClaw Onboarding
```bash
# This creates ~/.openclaw/openclaw.json
openclaw onboard

# When prompted:
# - Choose provider: "Ollama"
# - Select model: "llama3:8b"
# - Web search: "DuckDuckGo" (no setup needed)
```

### Step 4: Configure Telegram Token

Create or edit `~/.openclaw/openclaw.json` and add:

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

Or use environment variable:
```json
{
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true,
        "package": "@openclaw/plugin-telegram",
        "config": {
          "botToken": "${env.TELEGRAM_BOT_TOKEN}"
        }
      }
    }
  }
}
```

### Step 5: Copy Skills to OpenClaw Directory

```bash
# Create skill directories
mkdir -p ~/.openclaw/skills/user-onboarding
mkdir -p ~/.openclaw/skills/daily-quiz

# Copy SKILL.md files from this repository
cp skills/user-onboarding/SKILL.md ~/.openclaw/skills/user-onboarding/SKILL.md
cp skills/daily-quiz/SKILL.md ~/.openclaw/skills/daily-quiz/SKILL.md
```

### Step 6: Start the Gateway

```bash
# Terminal 1: Start Ollama (if not already running)
ollama serve

# Terminal 2: Start OpenClaw Gateway
openclaw gateway start

# You should see logs like:
# [INFO] Gateway started successfully
# [INFO] Telegram plugin initialized
```

### Step 7: Configure Automation Triggers

#### A. Create Standing Order for Onboarding
```bash
openclaw standing-orders add \
  --name "trigger-user-onboarding" \
  --if "memory.user_profile_{{user.id}} does not exist" \
  --run-skill "user-onboarding"
```

#### B. Create Cron Job for Daily Quiz

For different timezones, adjust `--tz` parameter:

```bash
# Eastern Time (America/New_York)
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram

# Pacific Time (America/Los_Angeles)
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "America/Los_Angeles" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram

# UTC
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "UTC" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram

# Europe/London
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "Europe/London" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram

# Asia/Tokyo
openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "Asia/Tokyo" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief to them on Telegram." \
  --announce \
  --channel telegram
```

## Testing Commands

### Test Onboarding Flow
```bash
# In Telegram, simply message your bot:
# User: "Hello"
# Expected: Bot initiates onboarding

# Complete the questions:
# - Technical domains
# - Experience level  
# - Learning goals
# - Timezone
```

### Test Daily Quiz Manually
```bash
# While gateway is running, trigger the cron job:
openclaw cron trigger "nightly-tech-brief"

# Check the output in logs:
openclaw gateway logs | grep "daily-quiz"

# In Telegram, you should receive the formatted brief
```

### Verify User Profile Saved
```bash
# Get a user ID from a completed onboarding
# Then check their profile:
openclaw memory get "user_profile_123456789"

# Expected output:
# {
#   "domains": ["Go", "Python"],
#   "level": "mid-level",
#   "goals": ["interviews", "learning"],
#   "timezone": "America/New_York"
# }
```

## Monitoring and Debugging

### View Gateway Logs
```bash
# Real-time logs
openclaw gateway logs -f

# Last 50 lines
openclaw gateway logs --tail 50

# Filter by level
openclaw gateway logs --level error
```

### Check Automation Status

```bash
# List all standing orders
openclaw standing-orders list

# List all cron jobs
openclaw cron list

# View specific cron job details
openclaw cron list --name "nightly-tech-brief"
```

### View User Memory

```bash
# Get specific user profile
openclaw memory get "user_profile_USER_ID"

# Get all user-related keys
openclaw memory list --pattern "user_*"

# Get engagement metrics
openclaw memory get "user_engagement_USER_ID"

# Get recent topics
openclaw memory get "recent_topics_USER_ID"
```

### Update User Preferences

```bash
# If user timezone needs correction:
openclaw memory set "user_profile_USER_ID" '{
  "domains": ["Python", "Go"],
  "level": "mid-level",
  "goals": ["interviews"],
  "timezone": "America/Los_Angeles"
}'
```

## Docker Commands

### Build and Start

```bash
# Build and start all services
docker-compose up --build

# Start in background
docker-compose up -d --build

# Start with SearXNG for advanced search
docker-compose --profile with-searxng up --build
```

### Check Status

```bash
# View running services
docker-compose ps

# View logs
docker-compose logs -f openclaw-gateway

# View specific service
docker-compose logs -f ollama
```

### Troubleshooting

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart openclaw-gateway

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v

# Check service health
docker-compose exec openclaw-gateway curl http://localhost:8080/health

# Access container shell
docker-compose exec openclaw-gateway sh
```

## Environment Configuration

### Using .env File

Create `.env` file in project root:

```bash
# Telegram
TELEGRAM_BOT_TOKEN=YOUR_TOKEN_HERE

# Optional: Cloud LLM Provider (one of these)
OPENAI_API_KEY=sk-proj-your-key
ANTHROPIC_API_KEY=sk-ant-your-key

# Optional: Self-hosted Search
SEARXNG_URL=http://searxng:8888
```

### Environment Variable Names

Supported variables:
- `TELEGRAM_BOT_TOKEN` - Required
- `OPENAI_API_KEY` - Optional (GPT-4o)
- `ANTHROPIC_API_KEY` - Optional (Claude)
- `GOOGLE_API_KEY` - Optional (Gemini)
- `SEARXNG_URL` - Optional (self-hosted search)
- `OLLAMA_HOST` - Default: http://ollama:11434

## Advanced Operations

### Switch LLM Provider

```bash
# Edit openclaw.json to use OpenAI:
{
  "model": {
    "provider": "openai",
    "model": "gpt-4o",
    "apiKey": "${env.OPENAI_API_KEY}"
  }
}

# Or use Anthropic:
{
  "model": {
    "provider": "anthropic",
    "model": "claude-3-sonnet",
    "apiKey": "${env.ANTHROPIC_API_KEY}"
  }
}
```

### Update Skill Instructions

```bash
# Edit the SKILL.md files
nano ~/.openclaw/skills/daily-quiz/SKILL.md

# Changes take effect immediately when the skill runs next
# No restart needed
```

### Backup User Data

```bash
# Backup memory directory
cp -r ~/.openclaw/memory ~/openclaw-backup-$(date +%Y%m%d)

# Backup config
cp ~/.openclaw/openclaw.json ~/openclaw-config-$(date +%Y%m%d).json

# For Docker deployments:
docker-compose exec openclaw-gateway tar czf - /root/.openclaw/memory | \
  gzip > openclaw-memory-$(date +%Y%m%d).tar.gz
```

## Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| "Bot not responding" | Check `openclaw gateway logs`, verify token, restart gateway |
| "Ollama not ready" | Ensure Ollama server is running: `ollama serve` |
| "Memory operations fail" | Check directory permissions: `chmod -R 755 ~/.openclaw/memory` |
| "Cron job not running" | Verify timezone: `openclaw memory get "user_profile_{{user.id}}"` |
| "Web search limited" | Switch to SearXNG or increase rate limits |
| "LLM responses poor" | Use better model (GPT-4o) or improve SKILL.md instructions |

## Next Steps

1. **Setup:** Choose Docker or local, follow appropriate commands above
2. **Test:** Follow "Testing Commands" section
3. **Deploy:** See DEPLOYMENT.md for production setup
4. **Contribute:** See CONTRIBUTING.md for improvement ideas

---

**All commands assume you're in the project directory unless otherwise noted.**
