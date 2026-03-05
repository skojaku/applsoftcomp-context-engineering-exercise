#!/bin/bash
# evaluate.sh — Score your prompt before running it
#
# Usage: bash evaluate.sh
#
# Reads my_prompt.md from the current directory and asks Gemini to
# score it on the four context engineering techniques.

PROMPT_FILE="my_prompt.md"
EVAL_FILE="evaluation.md"

# Check for required files
if [ ! -f "$EVAL_FILE" ]; then
  echo "Error: evaluation.md not found. Are you running this from the exercise directory?"
  exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: my_prompt.md not found."
  echo ""
  echo "Create a file called my_prompt.md with your prompt, then run this script again."
  exit 1
fi

echo "Evaluating your prompt..."
echo ""

gemini -p "$(cat $EVAL_FILE)

---
STUDENT PROMPT TO EVALUATE:
$(cat $PROMPT_FILE)

Output only the evaluation report as plain text. Do not use any tools."
