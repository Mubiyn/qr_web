#!/bin/bash

echo "🚀 PowerBank Rental - GitHub Pages Deployment Setup"
echo "=================================================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
    echo "✅ Git initialized"
fi

# Check for GitHub remote
if ! git remote get-url origin > /dev/null 2>&1; then
    echo ""
    echo "🔗 Please set up your GitHub repository:"
    echo "   1. Create a new repository on GitHub.com"
    echo "   2. Copy the repository URL"
    echo "   3. Run: git remote add origin <your-repo-url>"
    echo ""
    echo "📝 Example:"
    echo "   git remote add origin https://github.com/yourusername/powerbank-rental.git"
    echo ""
fi

# Add all files
echo "📦 Adding files to Git..."
git add .

# Check if there are changes to commit
if ! git diff --staged --quiet; then
    echo "💾 Committing changes..."
    git commit -m "Initial commit: PowerBank Rental Flutter Web App

- Complete payment flow with Apple Pay and Card options
- Real-time card validation and formatting
- Responsive mobile-first design
- API integration with fallback mock data
- GitHub Actions deployment setup"
    echo "✅ Changes committed"
else
    echo "ℹ️ No changes to commit"
fi

echo ""
echo "🌐 Next Steps:"
echo "1. Push to GitHub: git push origin main"
echo "2. Go to GitHub repository → Settings → Pages"
echo "3. Enable Pages: Source = GitHub Actions"
echo "4. Your app will be live at: https://yourusername.github.io/repository-name"
echo ""
echo "🎉 Deployment will be automatic on every push!"
