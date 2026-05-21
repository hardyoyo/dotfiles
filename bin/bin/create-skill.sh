#!/usr/bin/env bash

set -euo pipefail

SKILL_NAME="${1:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo "Usage: $0 <skill-name>"
  exit 1
fi

BASE_DIR="skills/$SKILL_NAME"

echo "Creating skill scaffold: $SKILL_NAME"

# Create directories
mkdir -p "$BASE_DIR/prompts"
mkdir -p "$BASE_DIR/examples"
mkdir -p "$BASE_DIR/bin"

# SKILL.md
cat > "$BASE_DIR/SKILL.md" <<EOF
# Skill: $SKILL_NAME

## Purpose
Describe what this skill does and when it should be used.

## Inputs
- input_1:
- input_2:

## Outputs
- Describe expected output format
- Include any constraints

## Procedure
1. Step one
2. Step two
3. Step three

## Rules
- Follow the procedure strictly
- Do not introduce unrelated steps

## Failure Modes
- Missing input → ask for clarification
- Ambiguity → choose safest reasonable interpretation

## Execution (Optional)
If needed, run:
\`skills/$SKILL_NAME/bin/run.sh\`
EOF

# system prompt
cat > "$BASE_DIR/prompts/system.md" <<EOF
You are executing the "$SKILL_NAME" skill.

Follow the defined procedure exactly.
Do not improvise outside the skill definition.
EOF

# templates
cat > "$BASE_DIR/prompts/templates.md" <<EOF
## Output Template

Result:
- Field A:
- Field B:

## Checklist

- [ ] Requirement 1 met
- [ ] Requirement 2 met
EOF

# example
cat > "$BASE_DIR/examples/example-1.md" <<EOF
# Example: Basic usage

## Input
Describe a sample input here.

## Output
Show expected output here.
EOF

# optional script
cat > "$BASE_DIR/bin/run.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "Running skill logic..."
EOF

chmod +x "$BASE_DIR/bin/run.sh"

# CLAUDE.md update (append if exists, create if not)
CLAUDE_FILE="CLAUDE.md"

if [[ ! -f "$CLAUDE_FILE" ]]; then
  echo "# Available Skills" > "$CLAUDE_FILE"
fi

cat >> "$CLAUDE_FILE" <<EOF

## $SKILL_NAME

Use this skill when:
- Define conditions here

How to use:
- Read skills/$SKILL_NAME/SKILL.md
- Follow its instructions exactly

Notes:
- Prefer this skill when applicable
EOF

echo "✅ Skill '$SKILL_NAME' created at $BASE_DIR"
