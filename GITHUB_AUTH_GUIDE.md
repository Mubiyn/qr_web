# GitHub Authentication Guide

A comprehensive guide for managing multiple GitHub accounts and authentication methods on macOS.

## 🔑 Method 1: GitHub CLI (Recommended - Easiest)

### Install GitHub CLI
```bash
# Install via Homebrew
brew install gh

# Or download from: https://cli.github.com/
```

### Basic Authentication
```bash
# Login to GitHub
gh auth login

# Follow prompts:
# 1. Choose "GitHub.com"
# 2. Choose "HTTPS" (recommended) or "SSH"
# 3. Choose "Login with a web browser"
# 4. Copy the one-time code
# 5. Open browser and paste code
# 6. Authorize GitHub CLI
```

### Multiple Account Management
```bash
# Check current authentication status
gh auth status

# Login with additional account
gh auth login --hostname github.com

# Switch between accounts
gh auth switch --hostname github.com --user USERNAME

# List all authenticated accounts
gh auth status --show-token

# Logout from specific account
gh auth logout --hostname github.com

# Logout from all accounts
gh auth logout
```

### Quick Account Switching
```bash
# Create aliases for easy switching
echo 'alias gh-personal="gh auth switch --hostname github.com --user your-personal-username"' >> ~/.zshrc
echo 'alias gh-work="gh auth switch --hostname github.com --user your-work-username"' >> ~/.zshrc
source ~/.zshrc

# Now you can quickly switch:
gh-personal
gh-work
```

---

## 🔑 Method 2: Git Credential Management

### Reset All Git Credentials
```bash
# Clear global Git configuration
git config --global --unset user.name
git config --global --unset user.email
git config --global --unset credential.helper

# Clear macOS Keychain (manual step):
# 1. Open "Keychain Access" app
# 2. Search for "github"
# 3. Delete all GitHub entries
# 4. Search for "git:" and delete related entries
```

### Set Up New Account
```bash
# Configure global Git settings
git config --global user.name "Your Full Name"
git config --global user.email "your-email@example.com"

# Set up credential helper for macOS
git config --global credential.helper osxkeychain

# Verify configuration
git config --global --list
```

### Per-Repository Configuration
```bash
# Navigate to specific repository
cd /path/to/your/repo

# Set repository-specific credentials
git config user.name "Different Name"
git config user.email "different-email@example.com"

# Check repository configuration
git config --list --local
```

---

## 🔑 Method 3: SSH Keys (Advanced)

### Generate SSH Keys for Different Accounts
```bash
# Generate SSH key for personal account
ssh-keygen -t ed25519 -C "personal@example.com" -f ~/.ssh/id_ed25519_personal

# Generate SSH key for work account  
ssh-keygen -t ed25519 -C "work@example.com" -f ~/.ssh/id_ed25519_work

# Add keys to SSH agent
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work

# List loaded SSH keys
ssh-add -l
```

### Copy SSH Keys to GitHub
```bash
# Copy personal key to clipboard
pbcopy < ~/.ssh/id_ed25519_personal.pub

# Copy work key to clipboard
pbcopy < ~/.ssh/id_ed25519_work.pub

# Then go to GitHub Settings → SSH and GPG keys → New SSH key
# Paste the key and give it a descriptive name
```

### Configure SSH for Multiple Accounts
```bash
# Create/edit SSH config file
nano ~/.ssh/config

# Add this configuration:
# Personal GitHub account
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal

# Work GitHub account
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work

# Default GitHub (use personal)
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
```

### Using SSH with Different Accounts
```bash
# Clone with specific account
git clone git@github-personal:username/repo.git
git clone git@github-work:company/repo.git

# Change existing repository to use specific account
git remote set-url origin git@github-work:company/repo.git

# Test SSH connection
ssh -T git@github-personal
ssh -T git@github-work
```

---

## 🔑 Method 4: Personal Access Tokens

### Create Personal Access Token
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Click "Generate new token (classic)"
3. Give it a descriptive name (e.g., "MacBook Pro - Project X")
4. Set expiration (90 days recommended for security)
5. Select scopes:
   - `repo` (full repository access)
   - `workflow` (update GitHub Actions)
   - `write:packages` (if using GitHub Packages)
6. Generate and copy the token immediately (you won't see it again)

### Use Token for Authentication
```bash
# Method 1: Use token as password when prompted
git push origin main
# Username: your-github-username
# Password: ghp_xxxxxxxxxxxxxxxxxxxx (paste your token)

# Method 2: Store token in Git credentials
git config --global credential.helper store
echo "https://username:ghp_your_token@github.com" >> ~/.git-credentials

# Method 3: Use token in remote URL
git remote set-url origin https://username:ghp_your_token@github.com/username/repo.git
```

---

## 🔧 Troubleshooting & Verification

### Check Current Authentication
```bash
# Git configuration
git config --global --list
git config --local --list

# GitHub CLI status
gh auth status

# SSH key verification
ssh -T git@github.com

# Test repository access
gh repo view
```

### Common Issues & Solutions

#### Issue: "Permission denied (publickey)"
```bash
# Check SSH agent
ssh-add -l

# Add SSH key if missing
ssh-add ~/.ssh/id_ed25519_personal

# Test SSH connection
ssh -vT git@github.com
```

#### Issue: "Authentication failed"
```bash
# Clear stored credentials
git config --global --unset credential.helper

# Remove from macOS Keychain
# Open Keychain Access → delete github entries

# Re-authenticate
gh auth login
```

#### Issue: Wrong account being used
```bash
# Check current user
gh api user

# Switch account
gh auth switch --hostname github.com --user correct-username

# Or set repository-specific credentials
cd your-repo
git config user.email "correct-email@example.com"
```

---

## 📋 Quick Reference Commands

### Essential Commands
```bash
# GitHub CLI
gh auth login                    # Login to GitHub
gh auth status                   # Check authentication status
gh auth switch --user USERNAME   # Switch account

# Git Configuration
git config --global user.name "Name"     # Set global name
git config --global user.email "email"   # Set global email
git config --list --global              # View global config

# SSH
ssh-keygen -t ed25519 -C "email"        # Generate SSH key
ssh-add ~/.ssh/id_ed25519               # Add key to agent
ssh -T git@github.com                   # Test SSH connection
```

### Account Switching Workflow
```bash
# 1. Switch GitHub CLI account
gh auth switch --user work-username

# 2. Verify correct account
gh api user

# 3. Set Git credentials for this session
git config --global user.email "work@company.com"

# 4. Work with repositories...

# 5. Switch back when done
gh auth switch --user personal-username
git config --global user.email "personal@email.com"
```

---

## 💡 Best Practices

1. **Use GitHub CLI** for the easiest account switching experience
2. **Use SSH keys** for repositories you frequently work with
3. **Use Personal Access Tokens** for CI/CD or automated scripts
4. **Set repository-specific configs** for mixed work/personal projects
5. **Create shell aliases** for quick account switching
6. **Regularly rotate tokens** for security (every 90 days)
7. **Use descriptive names** for SSH keys and tokens
8. **Keep backup** of your SSH keys in a secure location

---

## 🚀 Quick Setup for New Project

```bash
# 1. Switch to appropriate GitHub account
gh auth switch --user project-account

# 2. Set Git credentials
git config --global user.email "project@email.com"

# 3. Create and clone repository
gh repo create new-project --private
gh repo clone new-project

# 4. Start working!
cd new-project
```

Save this file for future reference! 📝
