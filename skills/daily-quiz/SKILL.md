# SKILL: Daily Tech Brief and Quiz Generation

## GOAL
Your goal is to generate a high-quality, personalized daily tech brief for a user and send it via Telegram. The brief must contain exactly 5 interview questions and 3-5 technical tidbits (insights, trends, or discoveries) tailored to the user's stored preferences. The content should be fresh, relevant, and genuinely useful.

## CONTEXT
This skill is triggered automatically by a cron job every evening at 9 PM in the user's local timezone. You will be provided with the user's ID, and you must fetch their profile from memory to understand their interests, experience level, and goals.

## GENERATION WORKFLOW

1. **Retrieve User Profile:** Use the `memory_store` tool to fetch the user's profile using their ID (e.g., key `user_profile_{{user.id}}`). The profile should contain:
   ```json
   {
     "domains": ["string"],
     "level": "string",
     "goals": ["string"],
     "timezone": "string"
   }
   ```
   All subsequent steps must be tailored to this profile. If the profile doesn't exist, inform the user that they need to complete onboarding first.

2. **Conduct Web Search:** Perform a `web_search` for each of the user's specified `domains`. The search strategy should be:
   - Use 2-3 search queries per domain, varying the focus (e.g., recent news, deep-dive tutorials, best practices).
   - Prioritize recent content by using time-based filters when available (e.g., "last 7 days", "latest 2024").
   - Example queries:
     - For Go domain: `"latest Go programming language performance tips 2024"`
     - For distributed systems: `"distributed systems design patterns trends 2024"`
     - For Python: `"Python async programming latest developments"`
   - Review the top 5-10 results and select the most interesting and relevant ones.

3. **Synthesize Technical Tidbits:** Based on the search results, synthesize 3 to 5 interesting technical tidbits. A tidbit is:
   - A short, insightful fact (1-2 sentences)
   - A recent trend or discovery
   - A useful pattern or best practice
   - Something the user likely hasn't heard before
   
   Tidbits must be accurate, specific, and actionable. Avoid generic statements. Example: "Go 1.21's new async features have reduced goroutine overhead by 15%, making it ideal for handling high-concurrency systems."

4. **Generate Interview Questions:** Generate exactly 5 interview questions that adhere to the following criteria:
   - **Relevance:** Questions must relate to the user's `domains`. Mix topics if they have multiple domains.
   - **Difficulty:** Match the user's `level`:
     - Junior: Focus on fundamentals, basic concepts, simple coding challenges.
     - Mid-level: Mix of conceptual understanding, medium-difficulty coding, and basic system design.
     - Senior: Deep system design, architectural decisions, trade-offs, and leadership-level questions.
     - Staff: Strategic thinking, complex architectural patterns, and mentoring-focused questions.
   - **Variety:** Include a mix of question types:
     - Conceptual (theory, patterns, principles)
     - Coding/Algorithmic (practical coding, problem-solving)
     - System Design (architecture, scalability, trade-offs)
     - Behavioral (soft skills, teamwork, conflict resolution)
   - **Novelty:** Track recently asked topics in memory to avoid repetition. Store asked topics under a key like `recent_topics_{{user.id}}`.
   - **Quality:** Each question should be well-formed, clear, and appropriate for a real interview setting.

   Example questions:
   - Conceptual (Go): "Explain how Go's goroutines differ from OS threads and why this matters for concurrent systems."
   - Coding (Python): "Write a function that detects cycles in a directed graph using DFS."
   - System Design (Distributed): "Design a fault-tolerant message queue that can handle 1M messages/sec."
   - Behavioral: "Tell us about a time you had to debug a critical production issue. What was your approach?"

5. **Format the Message:** Assemble the final message using Telegram's Markdown formatting. The message must follow this exact structure for proper rendering on mobile:

   ```
   🦞 *Your Daily Tech Brief* — [Date in format: Jan 15, 2024]

   ━━━━━━━━━━━━━━━━━━━━
   🧠 *Interview Questions*
   ━━━━━━━━━━━━━━━━━━━━

   *Q1 [Type — Domain]*
   [Question 1 Text - Clear and complete]

   *Q2 [Type — Domain]*
   [Question 2 Text - Clear and complete]

   *Q3 [Type — Domain]*
   [Question 3 Text - Clear and complete]

   *Q4 [Type — Domain]*
   [Question 4 Text - Clear and complete]

   *Q5 [Type — Domain]*
   [Question 5 Text - Clear and complete]

   ━━━━━━━━━━━━━━━━━━━━
   💡 *Today's Tidbits*
   ━━━━━━━━━━━━━━━━━━━━

   • [Tidbit 1 - Complete insight or discovery]

   • [Tidbit 2 - Complete insight or discovery]

   • [Tidbit 3 - Complete insight or discovery]

   [Additional tidbits if 4-5 total]

   ━━━━━━━━━━━━━━━━━━━━
   Reply *answers* to share your answers for feedback, or *more* for extra questions.
   ```

6. **Send via Telegram:** Use the Telegram channel integration to send the formatted message to the user.

## CONSTRAINTS
- **Quality First:** The quality of the questions and tidbits is paramount. They must be accurate, relevant, insightful, and appropriate for the user's level.
- **Formatting:** The message must render correctly on mobile devices. Test the Markdown syntax carefully.
- **Content Freshness:** Always use web_search to ensure content is current and recent. Do not use outdated information.
- **Autonomy:** The entire process must be autonomous. Do not ask for clarification from the user.
- **Error Handling:** If web search returns limited results for a domain, broaden the search query. If still insufficient, synthesize content from your training data, but note that it may be older.
- **Length:** Keep the message concise but complete. It should take 2-3 minutes to read on a phone.
- **Consistency:** Send the message at the exact scheduled time. If timezone is misconfigured, attempt to resend at the nearest future 9 PM in that timezone.

## ADVANCED FEATURES (OPTIONAL)
- **Spaced Repetition:** Track which questions have been asked and avoid repeating the same question within 30 days.
- **Difficulty Progression:** Gradually increase question difficulty based on user engagement (tracked in memory).
- **Domain Balance:** If the user has multiple domains, rotate between them to ensure all are covered throughout the week.
- **Feedback Loop:** Store user feedback (if they reply with answers) to refine future question generation.

## MEMORY MANAGEMENT
Track the following in memory for better personalization:
- `recent_topics_{{user.id}}`: List of topics asked in the last 30 days to avoid repetition.
- `user_engagement_{{user.id}}`: Engagement metrics (e.g., questions answered, feedback provided).
- `last_brief_date_{{user.id}}`: Date of the last brief sent to ensure no duplicates.

## NOTES FOR THE AGENT
- This skill runs autonomously every evening. Ensure all resources (web search, memory) are accessed reliably.
- If you encounter rate limits from web search, use cached results or your training data.
- Always prioritize accuracy over quantity. A single high-quality tidbit is better than three generic ones.
- Consider the user's timezone when generating the message—reference current events and dates in their local time.
