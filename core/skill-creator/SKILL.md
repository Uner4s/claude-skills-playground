---
name: skill-creator
description: Use when creating a new Claude Code skill or asked "how should I write a skill", "create a skill for X", "build a new skill", "define skill rules", "skill template".
---

# Skill Creator

**Rule:** A skill that doesn't change behavior is not a skill — it's a comment.

## Structure

Every skill lives at `skill-name/SKILL.md`:
1. Frontmatter: `name`, `description`, optional `allowed-tools`
2. One bold central rule at the top
3. Numbered steps or short sections — concrete, not vague
4. Nothing else

## Writing Rules

- **description** — Include the exact phrases that will make you think "I need this skill". This is what Claude reads to decide relevance.
- **Length** — Hard cap at 60 lines. If you need more, split into two skills.
- **Steps** — Must be executable. "Run `git status`" not "check the repo state".
- **No fluff** — No Overview, Background, or Introduction sections. Start with the rule.
- **One law per skill** — If two rules fight for priority, you have two skills.
- **Language** — Always English.

## Before Finishing

Ask: *"Would Claude behave differently without this skill?"*
If not — rewrite it.
