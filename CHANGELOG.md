# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1-beta] - 2024-12-01

### Added

- Comprehensive CI/CD pipeline with GitHub Actions
- Integration tests for Debian 12 and Fedora 42
- Code coverage tracking using bash tracing (61.7% coverage on Debian)
- Automated syntax validation with ShellCheck
- Nginx configuration testing
- Security scanning with Trivy
- Markdown linting configuration
- Weekly scheduled CI runs

### Changed

- Updated README logo with cleaner ASCII art design
- Improved documentation formatting and alignment
- Enhanced shell script error handling with proper exit codes
- Fixed ShellCheck warnings in setup.sh

### Fixed

- Quoted command substitutions in setup.sh (lines 313, 325, 415, 481)
- Added error handling for cd commands
- Resolved markdown linting violations
- Fixed nginx configuration validation in CI

## [0.1.0-beta] - 2024-12-01

### Features

- Complete VPS setup script for Fedora 42 and Debian 12/13
- Code-server (VS Code in browser) via Docker with HTTPS
- Automated deployment script (`deploy.sh`)
- Beautiful terminal experience with Zsh, Oh My Zsh, and Powerlevel10k
- Modern CLI tools: LazyGit, LazyVim, bat, exa, fzf, btop
- Development stack: Docker, Python 3, Node.js, Go, Rust
- Security features: UFW/firewalld, SSL certificates, password protection
- 4GB swap file configuration
- Comprehensive documentation for iPad workflows
- Verification script for troubleshooting
- Initial project structure and core setup scripts
- Docker Compose configuration for code-server
- Nginx reverse proxy setup

### Security

- HTTPS with self-signed SSL certificates
- Nginx reverse proxy with rate limiting
- Automatic firewall configuration
- SELinux configuration for Fedora
- Watchtower for automatic Docker updates

[Unreleased]: https://github.com/oskrocha/ipad-dev-server/compare/v0.1.1-beta...HEAD
[0.1.1-beta]: https://github.com/oskrocha/ipad-dev-server/compare/v0.1.0-beta...v0.1.1-beta
[0.1.0-beta]: https://github.com/oskrocha/ipad-dev-server/releases/tag/v0.1.0-beta
