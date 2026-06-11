# homebrew-tap

Homebrew tap for [mlx-coder](https://github.com/gerardogrisolini/mlx-coder) — a local coding agent and LLM server powered by MLX on Apple Silicon.

## Install

```bash
brew tap gerardogrisolini/tap
brew install mlx-coder
```

## Upgrade

```bash
brew upgrade mlx-coder
```

## Uninstall

```bash
brew uninstall mlx-coder
brew untap gerardogrisolini/tap
```

## Requirements

- macOS 26 (Tahoe) on Apple Silicon
- Homebrew

## Quick Start

```bash
# Setup and run the coding agent
mlx-coder --setup
mlx-coder --cwd /path/to/project

# The local inference server is also included
mlx-server --setup
mlx-server --setup-models
mlx-server
```
