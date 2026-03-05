#!/bin/bash
# run.sh — Execute the generated pipeline against sample.pdf
#
# Usage: bash run.sh
#
# Runs pipeline.sh with sample.pdf as input.
# Output will be written to review.md by the pipeline.

PIPELINE_FILE="pipeline.sh"
PAPER_FILE="sample.pdf"

if [ ! -f "$PIPELINE_FILE" ]; then
  echo "Error: pipeline.sh not found."
  echo "Run 'bash generate.sh' first to create it."
  exit 1
fi

if [ ! -f "$PAPER_FILE" ]; then
  echo "Error: sample.pdf not found. Are you running this from the exercise directory?"
  exit 1
fi

echo "Running pipeline on sample.pdf..."
echo "This may take several minutes — the pipeline will call Gemini multiple times."
echo ""

bash "$PIPELINE_FILE" "$PAPER_FILE"

echo ""
if [ -f "review.md" ]; then
  echo "Done! review.md has been written."
  echo ""
  echo "--- Preview ---"
  head -30 review.md
else
  echo "Pipeline finished, but review.md was not created."
  echo "Check the pipeline output above for errors."
fi
