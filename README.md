# homebrew-tap

Homebrew tap for [mlx-server](https://github.com/gerardogrisolini/mlx-server) — a local LLM server and coding agent powered by MLX on Apple Silicon.

## Install

```bash
brew tap gerardogrisolini/tap
brew install mlx-server
```

## Upgrade

```bash
brew upgrade mlx-server
```

## Uninstall

```bash
brew uninstall mlx-server
brew untap gerardogrisolini/tap
```

## Requirements

- macOS 26 (Tahoe) on Apple Silicon
- Homebrew

## Quick Start

```bash
# Setup configuration and models
mlx-server --setup
mlx-server --setup-models

# Start the local inference server
mlx-server

# Or run the coding agent directly
mlx-server --coder --cwd /path/to/project

# Or use the standalone agent
mlx-coder --setup
mlx-coder --cwd /path/to/project
```
