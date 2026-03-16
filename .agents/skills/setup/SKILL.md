---
name: setup
description: Check and install required dependencies for this repository.
---

Verify Python is available and install required packages.

## Steps

### 1. Check Python

Run the following to find a working Python executable:

```
python --version   # try this first
python3 --version  # fallback on Linux/macOS
```

Use whichever succeeds (`python` or `python3`). If neither works, tell the user to install Python (https://www.python.org/downloads/) and stop.

### 2. Install `uv` (preferred package manager)

Check if `uv` is already installed:

```
uv --version
```

If not found, install it:

- **Linux/macOS:**
  ```
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```
- **Windows (PowerShell):**
  ```
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

If `uv` installation fails, skip it and use `pip` instead.

### 3. Check and install `pymupdf`

Try importing `fitz` (pymupdf):

```
python -c "import fitz; print('pymupdf ok')"
```

If it fails, install it:

**With uv (preferred):**
```
uv pip install pymupdf
```

**With pip (fallback):**
```
python -m pip install pymupdf
```

On Windows, use `python` instead of `python3` in all commands above.

### 4. Verify

After installation, confirm the import works:

```
python -c "import fitz; print('pymupdf installed successfully')"
```

Report success or any errors to the user.
