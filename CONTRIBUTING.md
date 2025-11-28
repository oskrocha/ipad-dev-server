# Contributing to iPad Dev Server

Thanks for your interest in contributing! This guide will help you get started.

## 🤝 How to Contribute

### Reporting Issues

- Check if the issue already exists
- Use the issue templates when available
- Include your OS version (Fedora/Debian) and system specs
- Provide clear reproduction steps
- Include relevant logs and error messages

### Suggesting Features

- Open an issue with the "enhancement" label
- Describe the use case and benefits
- Consider if it fits the project's iPad-focused scope

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Test on Fedora 42 (primary) or Debian 12/13
   - Update documentation if needed

4. **Test thoroughly**
   ```bash
   # Test the setup script
   ./setup.sh
   
   # Test deployment
   ./deploy.sh
   
   # Verify containers start properly
   docker ps
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "feat: add support for XYZ"
   ```
   
   Use conventional commits:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `refactor:` Code refactoring
   - `test:` Test updates
   - `chore:` Maintenance tasks

6. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   - Fill out the PR template
   - Link related issues
   - Wait for review

## 🧪 Testing Guidelines

- Test on a clean VPS installation when possible
- Verify both automated (deploy.sh) and manual installation work
- Check that all services start without errors
- Test browser access to code-server
- Verify firewall rules are correct

## 📝 Documentation

- Update README.md for user-facing changes
- Update technical docs (DISTRO_GUIDE.md, etc.) as needed
- Add comments for complex logic
- Keep FIXES.md updated with solutions to common issues

## 🎯 Code Standards

- Use bash best practices (shellcheck compliance)
- Handle errors gracefully (don't use `set -e` that exits on non-critical errors)
- Add informative print statements for user feedback
- Support both Fedora and Debian where possible

## 🔒 Security

- Never commit passwords, keys, or sensitive data
- Review .gitignore before committing
- Report security issues privately to maintainers

## 📦 Release Process

Maintainers will:
1. Review and merge PRs
2. Update version numbers
3. Create release notes
4. Tag releases

## ❓ Questions?

- Open a discussion on GitHub
- Check existing issues and docs first
- Be respectful and patient

## 🙏 Recognition

All contributors will be recognized in the project. Thank you for making iPad Dev Server better!
