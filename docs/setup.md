# Setup

![opencode](https://opencode.ai/social-share.png)

## 1. Get an Ollama API key

1. Go to [ollama.com](https://ollama.com/) and sign in (or create a free account)
2. Navigate to **Settings → Keys**
3. Click **Add API Key**, give it a name, and copy the key

## 2. Connect OpenCode to Ollama Cloud

In the opencode terminal, type:

```
/connect
```

Select **Ollama Cloud** and paste your API key. The model is pre-set to `qwen3.5:cloud`.

## 3. Install dependencies

Run the setup skill:

```
/setup
```

See [.agents/skills/setup/SKILL.md](../.agents/skills/setup/SKILL.md) for what this does.
