# Contributing to OpenClaw Telegram Learning Assistant

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive criticism
- Help others learn and grow

## How to Contribute

### 1. Report Bugs

If you find a bug, please create an issue with:
- **Title:** Clear, concise description
- **Description:** What happened, what you expected
- **Steps to Reproduce:** How to trigger the bug
- **Environment:** OS, Docker version, Node version
- **Logs:** Relevant error messages from `docker-compose logs`

### 2. Suggest Enhancements

Have an idea for improvement? Create an issue with:
- **Clear title:** Feature or enhancement name
- **Motivation:** Why this would be useful
- **Proposed Solution:** How it might work
- **Alternatives:** Other approaches considered

### 3. Submit Code Changes

#### Fork and Clone
```bash
git clone https://github.com/yourusername/openclaw-telegram-learning-assistant.git
cd openclaw-telegram-learning-assistant
```

#### Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

#### Make Your Changes

- Keep changes focused and atomic
- Update documentation as needed
- Test thoroughly before submitting

#### Commit with Clear Messages
```bash
git commit -m "feat: add spaced repetition to daily quiz skill"
git commit -m "fix: handle timezone edge cases in cron scheduler"
git commit -m "docs: clarify memory schema in README"
```

#### Push and Create Pull Request
```bash
git push origin feature/your-feature-name
```

Then open a PR with:
- Description of changes
- Related issues (use `Fixes #123`)
- Testing notes

## Development Guidelines

### Skill Development

When creating or modifying SKILL.md files:

1. **Clear Structure:** Use headers, lists, and code blocks
2. **Examples:** Provide concrete examples of expected input/output
3. **Constraints:** Explicitly list limitations and edge cases
4. **Testing:** Verify the skill works with different LLM models
5. **Documentation:** Comment complex logic

Example skill structure:
```markdown
# SKILL: Name

## GOAL
Clear, actionable goal statement

## CONTEXT
When and why this skill is used

## WORKFLOW
Step-by-step instructions

## CONSTRAINTS
Limitations and boundaries

## NOTES
Additional guidance for the agent
```

### Configuration Management

- Never commit real secrets to `.env`
- Use `.env.example` for templates
- Document all environment variables
- Test with placeholder values

### Docker/Compose

- Test build: `docker-compose up --build`
- Test volume mounts: `docker-compose exec openclaw-gateway ls -la /root/.openclaw`
- Clean between tests: `docker-compose down -v`

## Testing Checklist

Before submitting a PR:

- [ ] Code follows existing style patterns
- [ ] All files have proper headers/comments
- [ ] README updated if needed
- [ ] `.env.example` updated with new variables
- [ ] Tested locally with Docker
- [ ] Tested with different LLM models
- [ ] No hardcoded secrets in any files
- [ ] Git history is clean and meaningful

## Documentation Standards

- Use clear, concise language
- Include code examples where applicable
- Link to external resources
- Keep README updated
- Document breaking changes

## Style Guide

### Markdown
- Use headers for structure (`#`, `##`, `###`)
- Lists for multiple items
- Code blocks for examples
- Emphasis for important terms (*bold* or `code`)

### JSON (openclaw.json)
- 2-space indentation
- Meaningful comments
- Placeholder values for secrets
- Proper nesting

### Shell Scripts
- Check prerequisites first
- Clear output messages
- Exit codes for errors
- Comments for complex logic

## Areas for Contribution

High-priority improvements:

1. **Spaced Repetition Algorithm**
   - Track question difficulty vs. user performance
   - Adjust future questions based on feedback
   - File: `skills/daily-quiz/SKILL.md`

2. **Feedback Integration**
   - Parse user answers
   - Provide intelligent feedback
   - Adjust difficulty dynamically
   - Requires skill enhancement

3. **Multi-Language Support**
   - Telegram message translation
   - Skill content in multiple languages
   - User preference for language
   - Likely: new skill files

4. **Analytics Dashboard**
   - Track user engagement
   - Question success rates
   - Learning progress visualization
   - May require new service

5. **Code Sandbox Integration**
   - Execute user-submitted code
   - Provide real-time feedback
   - Security considerations
   - New tool integration

6. **Advanced Search**
   - Custom search operators
   - Source filtering
   - Relevance scoring
   - Skill enhancement

## Questions?

- Check existing issues/discussions
- Ask in a new issue (label: `question`)
- Review README for common issues
- Test with `docker-compose logs` for debugging

---

**Thank you for contributing to making this learning assistant better! 🦞**
