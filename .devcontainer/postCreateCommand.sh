#!/bin/bash
set -e

echo "=== Setting up Context Engineering Exercise ==="

# ── 1. Install uv ──────────────────────────────────────────────────────────
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
uv --version

# ── 2. Install Python dependencies ────────────────────────────────────────
echo "Installing Python dependencies..."
uv sync
echo "Verifying pymupdf..."
uv run python -c "import fitz; print('pymupdf ok')"

# ── 3. Install OpenCode ───────────────────────────────────────────────────
echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash
export PATH="$HOME/.local/bin:$PATH"
opencode --version 2>/dev/null || echo "OpenCode installed (restart terminal to use)"

# ── 4. Configure OpenCode ─────────────────────────────────────────────────
echo "Configuring OpenCode..."
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "autoshare": false,
  "model": "ollama/qwen3.5:35b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama",
      "options": {
        "baseURL": "https://ollama.com/v1"
      },
      "models": {
        "qwen3.5:35b": {
          "name": "qwen3.5:35b"
        }
      }
    }
  }
}
EOF

# ── 5. Update skill commands for this environment ─────────────────────────
echo "Updating skill commands..."
PYTHON_CMD="uv run python3"
for skill_file in .agents/skills/*/SKILL.md; do
  if [ -f "$skill_file" ]; then
    sed -i "s/python3 /$PYTHON_CMD /g" "$skill_file"
    sed -i "s/python /$PYTHON_CMD /g" "$skill_file"
  fi
done

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Open a terminal and run: opencode"
echo "  2. Enter your Ollama API key when prompted (get one at ollama.com/settings/keys)"
echo "  3. In OpenCode, type /setup to verify dependencies"
echo "  4. Follow the exercise in docs/task.md"
echo ""
