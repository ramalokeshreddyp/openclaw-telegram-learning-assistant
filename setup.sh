#!/bin/bash
# Setup script for initial development environment
# Run this after cloning to initialize everything

set -e

echo "🚀 OpenClaw Telegram Learning Assistant - Setup Script"
echo "======================================================"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js >= 20.0.0"
    echo "   Visit: https://nodejs.org"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker"
    echo "   Visit: https://www.docker.com"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose"
    exit 1
fi

echo "✅ All prerequisites installed"
echo ""

# Create .env from example
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from example..."
    cp .env.example .env
    echo "⚠️  Please edit .env and add your TELEGRAM_BOT_TOKEN"
    echo "   Command: nano .env (or your preferred editor)"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Check if token is configured
if ! grep -q "TELEGRAM_BOT_TOKEN=YOUR_TELEGRAM_BOT_TOKEN" .env 2>/dev/null; then
    if grep -q "TELEGRAM_BOT_TOKEN=" .env 2>/dev/null; then
        echo "✅ Telegram bot token appears to be configured"
    else
        echo "⚠️  Please set your Telegram bot token in .env"
    fi
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📖 Next steps:"
echo "   1. Edit .env and add your TELEGRAM_BOT_TOKEN"
echo "   2. Run: docker-compose up --build"
echo "   3. Test your bot on Telegram"
echo ""
echo "For detailed instructions, see README.md"
