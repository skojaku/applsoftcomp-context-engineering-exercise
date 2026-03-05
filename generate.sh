#!/bin/bash
# generate.sh — Ask Gemini to build the pipeline from your prompt
#
# Usage: bash generate.sh
#
# Reads my_prompt.md and sample.pdf, asks Gemini to generate pipeline.sh,
# then prints the script so you can review it before running.

PROMPT_FILE="my_prompt.md"
PAPER_FILE="sample.pdf"
OUTPUT_FILE="pipeline.sh"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: my_prompt.md not found. Write your prompt first."
  exit 1
fi

if [ ! -f "$PAPER_FILE" ]; then
  echo "Error: sample.pdf not found. Are you running this from the exercise directory?"
  exit 1
fi

echo "Generating pipeline from your prompt..."
echo ""

gemini -f "$PAPER_FILE" "$(cat $PROMPT_FILE)" > "$OUTPUT_FILE"

echo "Done. Generated: $OUTPUT_FILE"
echo ""
echo "--- Preview (first 40 lines) ---"
head -40 "$OUTPUT_FILE"
echo ""
echo "Review the full script with:  cat $OUTPUT_FILE"
echo "Run it with:                  bash run.sh"
