# Installation & Setup

## Getting Started

### Installation

```bash
# clone git repo
git clone git@github.com:marioBytes/git-hook-checklist.git
# navigate to repo
cd git-hook-checklist
# copy hook to your projects hooks dir as a step in the git workflow
cp git-hook-checklist/custom_hook.sh your-project/.git/hooks/pre-push
# navigate to your project
cd your-project/.git/hooks
# make hook executable
chmod +x pre-push
```

### Customization

1. Add project-specific checklist items in `checklist` array
2. Customize messages to encourage yourself and other devs
3. Adjust color scheme for visibility
