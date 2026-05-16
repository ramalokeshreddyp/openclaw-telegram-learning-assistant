FROM node:20-alpine

# Install required system dependencies
RUN apk add --no-cache curl bash

# Set working directory
WORKDIR /app

# Install OpenClaw globally
RUN npm install -g openclaw

# Create necessary directories
RUN mkdir -p /root/.openclaw/skills/user-onboarding \
    && mkdir -p /root/.openclaw/skills/daily-quiz \
    && mkdir -p /root/.openclaw/config \
    && mkdir -p /root/.openclaw/memory

# Copy skill files into the container
COPY skills/user-onboarding/SKILL.md /root/.openclaw/skills/user-onboarding/SKILL.md
COPY skills/daily-quiz/SKILL.md /root/.openclaw/skills/daily-quiz/SKILL.md

# Copy configuration file
COPY config/openclaw.json /root/.openclaw/openclaw.json

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Expose gateway port
EXPOSE 8080

# Default entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
