# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Git flow structure with `main` and `develop` branches
- Changelog for tracking version history

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

### Security

- HTTPS with self-signed SSL certificates
- Nginx reverse proxy with rate limiting
- Automatic firewall configuration
- SELinux configuration for Fedora
- Watchtower for automatic Docker updates

## [0.1.0-alpha] - 2024-12-01

### Initial Release

- Initial project structure
- Core setup script for VPS configuration
- Docker Compose configuration for code-server
- Nginx reverse proxy setup
- Basic documentation
- Setup and deployment scripts

[Unreleased]: https://github.com/oskrocha/ipad-dev-server/compare/v0.1.0-beta...HEAD
[0.1.0-beta]: https://github.com/oskrocha/ipad-dev-server/compare/v0.1.0-alpha...v0.1.0-beta
[0.1.0-alpha]: https://github.com/oskrocha/ipad-dev-server/releases/tag/v0.1.0-alpha
