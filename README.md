# Dotfiles

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Modern development environment configuration for macOS and Ubuntu. Automated setup for a clean, efficient workflow.

## Requirements

### macOS
- [Homebrew](https://brew.sh)
- [iTerm2](https://iterm2.com) (recommended)
- Command Line Tools (`xcode-select --install`)

### Ubuntu
- `build-essential`

## Installation

```bash
make all
```

## Features

- Modern shell environment (Zsh)
- Optimized Neovim configuration
- Curated system packages
- Platform-specific enhancements

## Usage

```bash
make help         # Show available commands
make all         # Install everything
make pkg         # Install packages
make zsh         # Configure Zsh
make nvim        # Setup Neovim
```

## Components

### Shell (Zsh)
```bash
make zsh-install    # Install Zsh
make zsh-configure  # Configure settings
```

### Neovim
```bash
make nvim-install    # Install Neovim
make nvim-configure  # Configure editor
```

### Packages
```bash
make pkg-install    # Install system packages
```

## Structure

```
.
├── Makefile           # Build system
├── scripts/
│   ├── pkg.sh        # Package management
│   ├── zsh.sh        # Shell configuration
│   └── nvim.sh       # Editor setup
```

## Troubleshooting

Enable verbose output:
```bash
make all VERBOSE=1
```

## Contributing

Pull requests welcome. For major changes, please open an issue first.

## License

[MIT](LICENSE)
