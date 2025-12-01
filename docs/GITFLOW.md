# Git Flow Workflow Guide

This project follows the **Git Flow** branching model for organized development and releases.

## Branch Structure

### Main Branches

- **`main`** - Production-ready code. Every commit here is a release.
- **`develop`** - Integration branch for features. The latest development changes.

### Supporting Branches

- **`feature/*`** - New features and non-emergency bug fixes
- **`release/*`** - Preparation for a new production release
- **`hotfix/*`** - Quick fixes for production issues

## Workflow

### Starting a New Feature

```bash
# Make sure you're on develop and up to date
git checkout develop
git pull origin develop

# Create a feature branch
git checkout -b feature/my-new-feature

# Work on your feature, commit changes
git add .
git commit -m "feat: add my new feature"

# Push to remote
git push -u origin feature/my-new-feature

# Create a Pull Request to merge into develop
```

### Creating a Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v0.2.0

# Update version numbers, CHANGELOG.md, etc.
# Make final adjustments and bug fixes

# Commit release preparation
git add .
git commit -m "chore: prepare release v0.2.0"

# Merge to main
git checkout main
git merge --no-ff release/v0.2.0

# Tag the release
git tag -a v0.2.0 -m "Release version 0.2.0"

# Merge back to develop
git checkout develop
git merge --no-ff release/v0.2.0

# Push everything
git push origin main develop --tags

# Delete release branch
git branch -d release/v0.2.0
git push origin --delete release/v0.2.0
```

### Creating a Hotfix

```bash
# Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/v0.1.1

# Fix the critical issue
git add .
git commit -m "fix: critical bug in setup script"

# Merge to main
git checkout main
git merge --no-ff hotfix/v0.1.1
git tag -a v0.1.1 -m "Hotfix version 0.1.1"

# Merge to develop
git checkout develop
git merge --no-ff hotfix/v0.1.1

# Push everything
git push origin main develop --tags

# Delete hotfix branch
git branch -d hotfix/v0.1.1
git push origin --delete hotfix/v0.1.1
```

## Release Types

### Alpha Releases (v0.x.0-alpha)

- Early testing versions
- May have incomplete features
- For internal testing or early adopters
- Tagged with `-alpha` suffix

```bash
git tag -a v0.1.0-alpha -m "Alpha release for early testing"
git push origin v0.1.0-alpha
```

### Beta Releases (v0.x.0-beta)

- Feature-complete but needs testing
- For wider testing audience
- Tagged with `-beta` suffix

```bash
git tag -a v0.1.0-beta -m "Beta release for testing"
git push origin v0.1.0-beta
```

### Stable Releases (v0.x.0)

- Production-ready
- Fully tested
- No suffix

```bash
git tag -a v0.1.0 -m "Stable release v0.1.0"
git push origin v0.1.0
```

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks
- `ci:` - CI/CD changes

### Examples

```bash
git commit -m "feat: add support for Ubuntu 24.04"
git commit -m "fix: resolve firewall configuration issue on Debian"
git commit -m "docs: update iPad workflow instructions"
git commit -m "chore: update dependencies"
```

## Version Numbers

Following [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., 1.0.0)
  - **MAJOR**: Breaking changes
  - **MINOR**: New features (backward compatible)
  - **PATCH**: Bug fixes (backward compatible)

### Pre-release Versions

- `v0.1.0-alpha.1`, `v0.1.0-alpha.2` - Alpha releases
- `v0.1.0-beta.1`, `v0.1.0-beta.2` - Beta releases
- `v0.1.0-rc.1` - Release candidates

## Automated Release Process

When you push a tag, GitHub Actions automatically:

1. Extracts release notes from `CHANGELOG.md`
2. Creates a GitHub Release
3. Attaches important files (scripts, configs)
4. Marks alpha/beta as pre-releases

```bash
# This triggers the automated release
git tag -a v0.2.0-beta -m "Beta release v0.2.0"
git push origin v0.2.0-beta
```

## Pull Request Guidelines

1. Always create PRs from feature branches to `develop`
2. Never commit directly to `main`
3. Fill out the PR template completely
4. Ensure all checks pass
5. Request review from maintainers
6. Update `CHANGELOG.md` in your PR

## Best Practices

1. **Keep commits atomic** - One logical change per commit
2. **Write clear commit messages** - Follow the convention
3. **Update CHANGELOG.md** - Document your changes
4. **Test thoroughly** - Especially on both Fedora and Debian
5. **Keep develop stable** - Don't merge broken code
6. **Delete merged branches** - Keep repository clean
7. **Sync regularly** - Pull latest changes often

## Quick Reference

```bash
# Clone and setup
git clone https://github.com/oskrocha/ipad-dev-server.git
cd ipad-dev-server
git checkout develop

# Create feature
git checkout -b feature/my-feature
git push -u origin feature/my-feature

# Update from develop
git checkout develop
git pull origin develop
git checkout feature/my-feature
git merge develop

# Create release
git tag -a v0.2.0 -m "Release v0.2.0"
git push origin v0.2.0

# Check current branch and status
git status
git branch -a

# View commit history
git log --oneline --graph --all
```

## Resources

- [Git Flow Cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
