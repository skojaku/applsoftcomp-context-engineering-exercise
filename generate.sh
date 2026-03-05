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

PAPER_TEXT=$(pdftotext "$PAPER_FILE" -)

gemini -p "You are a bash script generator. Output ONLY a raw bash script — no explanation, no markdown, no code fences, no tool calls. The script will be saved directly to a file and executed.

CRITICAL RULES — violating any of these makes the script invalid:
1. Every stage that produces content MUST call \`gemini -p\` to generate it. Do NOT write any content inline. Do NOT use heredocs to hardcode text. Do NOT simulate or pre-compute any output.
2. The script must work on any PDF, not just this one. Do not hardcode reference titles, paper names, or any domain knowledge from the paper below.
3. Each \`gemini -p\` call must read its input from files written by the previous stage, and write its output to a new file. No single call should do more than one stage of work.
4. Use \`pdftotext paper.pdf -\` to extract text from a PDF for use in a gemini call.
5. Check whether output files already exist before processing — skip steps that have already been completed.

The paper text below is provided ONLY so you understand the structure of a typical input (number of references, format, etc.). Do NOT use its content in the script.

--- PAPER (for structure reference only) ---
$PAPER_TEXT
--- END PAPER ---

--- STUDENT SPECIFICATION ---
$(cat $PROMPT_FILE)
--- END SPECIFICATION ---

Output the bash script now. Start with #!/bin/bash." > "$OUTPUT_FILE"

echo "Done. Generated: $OUTPUT_FILE"
echo ""
echo "--- Preview (first 40 lines) ---"
head -40 "$OUTPUT_FILE"
echo ""
echo "Review the full script with:  cat $OUTPUT_FILE"
echo "Run it with:                  bash run.sh"
