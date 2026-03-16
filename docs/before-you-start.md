# Before You Start

## Ollama API Key (required)

You need an Ollama account to use the `qwen3.5:cloud` model, which is the default for this exercise.

1. Go to [ollama.com](https://ollama.com/) and sign in or create a free account
2. Click your profile icon and go to **Settings → Keys**
3. Click **Add API Key**, give it a name, and copy the key
4. In OpenCode, type `/connect`, select **Ollama Cloud**, and paste the key

Free accounts include access to `qwen3.5:cloud` with no credit card required.

---

## OpenRouter API Key (optional)

OpenRouter gives you access to 20+ free models from a single API key, including `qwen/qwen3.5-flash-02-23` which is pre-configured in this exercise.

**To get a key:**
1. Go to [openrouter.ai](https://openrouter.ai/) and sign in or create a free account
2. Go to **Settings → Keys** and click **Create Key**
3. Copy the key
4. In OpenCode, type `/connect`, select **OpenRouter**, and paste the key

**Notable free models on OpenRouter:**

| Model | ID |
|---|---|
| Qwen 3.5 35B | `qwen/qwen3.5-35b-a3b-20260224:free` |
| Qwen 3.5 Plus | `qwen/qwen3.5-plus-20260216:free` |
| DeepSeek V3 | `deepseek/deepseek-v3:free` |
| Gemini 2.5 Flash | `google/gemini-2.5-flash:free` |

Free models have rate limits (roughly 20 requests/min, 200 requests/day). For this exercise that is more than enough.

Switch models anytime inside OpenCode with `/model`.

---

## GitHub Codespaces (optional tips)

GitHub Codespaces is a cloud development environment that runs inside your browser. You get a full VS Code editor and terminal without installing anything on your computer.

**Free quota per month (personal accounts):**
- 120 core-hours (GitHub Free)
- 180 core-hours (verified students via GitHub Student Developer Pack)

A 2-core Codespace uses 2 core-hours per hour of active use, giving you 60-90 hours per month for free.

**Tips:**
- **Stop your Codespace when done.** Go to [github.com/codespaces](https://github.com/codespaces), find your Codespace, and click **Stop**. A running Codespace consumes your quota even if you are not using it.
- **Your files are saved automatically** inside the Codespace. You can reopen it later and continue where you left off.
- **Push your work to GitHub** with `git push` so it is saved even if the Codespace is deleted.
- Codespaces are deleted after 30 days of inactivity by default.
