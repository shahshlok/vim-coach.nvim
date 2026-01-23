# Contributing to vim-coach.nvim

Thank you for your interest in contributing to vim-coach.nvim! This guide will help you get started.

Whether you're fixing a typo, adding a new command, or improving documentation, your contribution is valuable and appreciated.

## Table of Contents
- [Quick Start](#quick-start)
- [Ways to Contribute](#ways-to-contribute)
- [Setting Up Development Environment](#setting-up-development-environment)
- [Making Changes](#making-changes)
- [Submitting Your Contribution](#submitting-your-contribution)
- [Code Review Process](#code-review-process)
- [Community Guidelines](#community-guidelines)

---

## Quick Start

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/vim-coach.nvim.git
cd vim-coach.nvim

# 2. Create branch (issueNumber_branch_title)
git checkout -b 10_add_testing_env

# 3. Make changes
# Edit files...

# 4. Test
./test.sh

# 5. Commit and push
git add .
git commit -m "feat: add cool feature"
git push origin 10_add_testing_env

# 6. Create pull request on GitHub
```

> **Branch naming is mandatory**: use the issue number + short title (e.g. `10_add_testing_env`). See the branch naming section below for details.

That's the basics! Read on for details.

---

## Branch Naming Convention

All new work must live on branches named `issueNumber_branch_title`. This keeps every change traceable to a GitHub issue.

- Start with the numeric issue ID, then an underscore, then a short lowercase description that uses underscores instead of spaces.
- Example: Issue **#10** “Add testing environment” → branch `10_add_testing_env`
- Open an issue before you branch so you have a number ready; use one branch per issue.

> Pull requests opened from branches that don't follow this pattern will be asked to rename before review.

---

## Ways to Contribute

### 1. Add Commands

**Skill level**: Beginner-friendly

**What**: Add missing Vim commands to the database

**Example**: Add macro commands, marks, or advanced motions

**How**:
1. Choose a category (motions, editing, visual, plugins)
2. Edit `lua/vim-coach/commands/{category}.lua`
3. Add command following existing format
4. Test with `./test.sh`

**See**: [DEVELOPMENT.md - Adding Commands](DEVELOPMENT.md#adding-a-new-command)

### 2. Improve Documentation

**Skill level**: Beginner-friendly

**What**: Fix typos, improve explanations, add examples

**Where**:
- Command explanations in `lua/vim-coach/commands/*.lua`
- User docs in `README.md`
- Developer docs in `docs/*.md`

**Example**: Add better beginner tips, clarify when to use commands

### 3. Fix Bugs

**Skill level**: Intermediate

**What**: Fix reported issues

**How**:
1. Check [GitHub Issues](https://github.com/shahshlok/vim-coach.nvim/issues)
2. Comment on issue you want to fix
3. Create branch, fix bug, submit PR

**Example**: Fix search crash, clipboard not working, UI glitches

### 4. Enhance Features

**Skill level**: Intermediate to Advanced

**What**: Improve existing functionality

**Examples**:
- Better fuzzy search
- Improved UI/UX
- Performance optimizations
- Additional picker actions

**See**: [ARCHITECTURE.md - Extension Points](ARCHITECTURE.md#extension-points)

### 5. Add New Features

**Skill level**: Advanced

**What**: Add major new functionality

**Examples**:
- Interactive tutorial mode
- Command history tracking
- Custom command sources
- Localization support

**Important**: Open an issue first to discuss the feature!

### 6. Write Tests

**Skill level**: Intermediate

**What**: Add automated tests

**Status**: Currently manual testing only

**Opportunity**: Set up unit tests with plenary.nvim

### 7. Review Pull Requests

**Skill level**: Any

**What**: Review other contributors' PRs

**How**: Check code, test locally, provide feedback

**Example**: Test PR works in your setup, check for typos

---

## Setting Up Development Environment

### Prerequisites

- Git
- Neovim >= 0.7
- Text editor (any!)

### Step 1: Fork Repository

1. Go to https://github.com/shahshlok/vim-coach.nvim
2. Click "Fork" button (top right)
3. This creates your own copy

### Step 2: Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/vim-coach.nvim.git
cd vim-coach.nvim
```

### Step 3: Add Upstream Remote

```bash
# Add original repo as "upstream"
git remote add upstream https://github.com/shahshlok/vim-coach.nvim.git

# Verify remotes
git remote -v
# Should show:
# origin    https://github.com/YOUR_USERNAME/vim-coach.nvim.git (fetch)
# origin    https://github.com/YOUR_USERNAME/vim-coach.nvim.git (push)
# upstream  https://github.com/shahshlok/vim-coach.nvim.git (fetch)
# upstream  https://github.com/shahshlok/vim-coach.nvim.git (push)
```

### Step 4: Set Up Testing Environment

```bash
chmod +x test.sh
./test.sh
```

First run takes ~1-2 minutes to install dependencies.

### Step 5: Verify Everything Works

Inside test environment:
```
:VimCoach
# Should open picker
# Press Esc to close
:qa!
```

You're ready! 🎉

---

## Making Changes

### 1. Create a Feature Branch

```bash
# Make sure you're on main
git checkout main

# Pull latest changes
git pull upstream main

# Create feature branch (issueNumber_branch_title)
git checkout -b 42_add_macro_commands
```

**Branch naming refresher**:
- Always use `issueNumber_branch_title`
- Keep the title short, lowercase, and underscore-separated
- Example: Issue #42 “Add macro commands” → `42_add_macro_commands`

### 2. Make Your Changes

**Guidelines**:
- Follow existing code style
- Add comments for complex logic
- Update documentation if needed
- Test thoroughly

**Example**: Adding a command

```lua
-- lua/vim-coach/commands/editing.lua
{
  name = "Start Recording Macro",
  keybind = "qa",
  modes = {"n"},
  explanation = "Records all keystrokes into register 'a' until you press q again",
  beginner_tip = "Macros are like video recordings of your keystrokes - incredibly powerful for repetitive edits!",
  when_to_use = "When you need to repeat the same series of edits multiple times across different locations",
  context_notes = {
    file = "Records all commands until you press q again to stop",
    explorer = "Works but rarely useful in file explorers",
  },
  examples = {
    "qa - start recording to register a",
    "q - stop recording",
    "@a - replay macro from register a",
    "5@a - replay macro 5 times",
    "qA - append to existing macro in register a",
  }
}
```

### 3. Test Your Changes

```bash
./test.sh
```

Inside test environment:
- Try your changes
- Test edge cases
- Verify no regressions

**Checklist**:
- [ ] `:VimCoach` opens without errors
- [ ] Your changes appear correctly
- [ ] Search works
- [ ] Preview displays nicely
- [ ] Keybind copying works
- [ ] No Lua errors (check `:messages`)

### 4. Commit Your Changes

**Good commit messages**:
```bash
# Format: <type>: <description>
#
# Types:
# feat: New feature
# fix: Bug fix
# docs: Documentation
# style: Formatting
# refactor: Code restructuring
# test: Adding tests
# chore: Maintenance

# Examples:
git commit -m "feat: add macro recording commands"

git commit -m "fix: prevent crash when searching empty string"

git commit -m "docs: improve testing environment setup guide"

# For detailed commits:
git commit -m "feat: add window management commands

- Added 10 new window split commands
- Created new 'windows' category
- Added <leader>hw keymap
- Updated documentation with examples"
```

**Bad commit messages** (avoid these):
```bash
git commit -m "update"
git commit -m "fix stuff"
git commit -m "changes"
git commit -m "asdfasdf"
```

### 5. Keep Your Branch Updated

```bash
# Get latest changes from upstream
git fetch upstream

# Rebase your branch on latest main
git rebase upstream/main

# If conflicts, resolve them:
# 1. Edit conflicted files
# 2. git add <file>
# 3. git rebase --continue
```

---

## Submitting Your Contribution

### 1. Push to Your Fork

```bash
git push origin add-macro-commands
```

If you rebased:
```bash
git push origin add-macro-commands --force-with-lease
```

### 2. Create Pull Request

1. Go to your fork on GitHub: `https://github.com/YOUR_USERNAME/vim-coach.nvim`
2. Click "Compare & pull request" button
3. Fill out the PR template:

```markdown
## Description
Brief summary of what you changed and why.

## Changes Made
- Added X commands to Y category
- Fixed Z bug in picker
- Updated documentation for A

## Testing
- [x] Tested with ./test.sh
- [x] Verified all commands display correctly
- [x] Checked keybind copying works
- [x] No Lua errors in :messages

## Screenshots (if UI changed)
[Attach screenshots if you changed the UI]

## Related Issues
Closes #123
Fixes #456
```

4. Click "Create pull request"

### 3. PR Best Practices

**Do**:
- Keep PRs focused (one feature/fix per PR)
- Write clear description
- Respond to feedback promptly
- Be respectful

**Don't**:
- Mix multiple unrelated changes
- Submit huge PRs (hard to review)
- Force push after review started (unless asked)
- Take feedback personally

---

## Code Review Process

### What Happens After You Submit

1. **Automated checks** (if configured)
   - Lua syntax check
   - Code style check

2. **Maintainer review**
   - Code quality check
   - Test functionality
   - Provide feedback

3. **Iteration**
   - Address feedback
   - Make requested changes
   - Push updates

4. **Approval**
   - PR approved
   - Merged into main

5. **Celebration** 🎉
   - Your contribution is live!
   - You're in the contributors list

### Review Timeline

- **First response**: Usually within 2-3 days
- **Full review**: Within 1 week
- **Merge**: After approval and passing checks

**Note**: Maintainers are volunteers, please be patient!

### Addressing Review Feedback

**Reviewer says**: "Can you add more examples?"

**Good response**:
```bash
# Make changes
git add .
git commit -m "docs: add more examples per review feedback"
git push origin add-macro-commands
```

**Reviewer says**: "Please fix the typo in line 45"

**Good response**:
```bash
# Fix typo
git add .
git commit -m "fix: typo in explanation"
git push origin add-macro-commands
```

**Reviewer says**: "This approach might have issues with X"

**Good response**:
Comment in PR: "Good point! How about we do Y instead? I can update the PR if that works."

---

## Community Guidelines

### Code of Conduct

**Be respectful**:
- Treat everyone with respect
- Welcome newcomers
- Give constructive feedback
- Assume good intentions

**Be helpful**:
- Answer questions
- Share knowledge
- Review PRs
- Improve documentation

**Be collaborative**:
- Discuss before big changes
- Accept feedback gracefully
- Credit others' work
- Work together

### Getting Help

**Stuck?**
- Check documentation in `docs/`
- Search existing issues
- Ask in GitHub Discussions
- Tag maintainers (but be patient!)

**Found a bug?**
- Search existing issues first
- Create new issue with details
- Include reproduction steps
- Add screenshots if UI bug

**Have an idea?**
- Open a discussion (not issue)
- Explain the use case
- Discuss implementation
- Get feedback before coding

### Recognition

Contributors are recognized in:
- GitHub contributors list
- CHANGELOG.md
- README.md acknowledgments

Big contributors may get:
- Collaborator access
- Decision-making input
- Maintainer role (if interested)

---

## Development Resources

### Essential Reading

1. **[TESTING.md](TESTING.md)** - How the test environment works
2. **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development workflows
3. **[ARCHITECTURE.md](ARCHITECTURE.md)** - Plugin structure

### External Resources

- [Lua in Neovim Guide](https://github.com/nanotee/nvim-lua-guide)
- [Neovim API Documentation](https://neovim.io/doc/user/api.html)
- [LazyVim Documentation](https://lazyvim.org)
- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)

### Common Files You'll Edit

```
vim-coach.nvim/
├── lua/vim-coach/
│   ├── init.lua                 # Core logic (advanced)
│   └── commands/
│       ├── motions.lua          # Add motion commands here
│       ├── editing.lua          # Add editing commands here
│       ├── visual.lua           # Add visual commands here
│       └── plugins.lua          # Add plugin commands here
├── plugin/
│   └── vim-coach.lua            # Entry point (for keymaps)
├── README.md                    # User documentation
└── docs/
    ├── TESTING.md               # Test environment docs
    ├── DEVELOPMENT.md           # Development workflows
    ├── ARCHITECTURE.md          # Plugin architecture
    └── CONTRIBUTING.md          # You are here!
```

---

## FAQ

### Do I need to know Lua?

**For adding commands**: No! Just copy existing commands and modify.

**For core changes**: Yes, basic Lua knowledge helps.

### Do I need to use Neovim?

**Yes**, to test your changes. But you can edit code in any editor!

### How long until my PR is reviewed?

Usually **2-3 days** for first response, **1 week** for full review.

### Can I work on multiple features at once?

Yes, but use **separate branches** for each feature:
```bash
git checkout main
git checkout -b 21_add_visual_mode_examples

# Work on issue 21...

git checkout main
git checkout -b 34_fix_picker_crash

# Work on issue 34...
```

### My PR has merge conflicts, what do I do?

```bash
# Update your branch
git fetch upstream
git rebase upstream/main

# Fix conflicts in your editor
# Then:
git add .
git rebase --continue

# Force push (needed after rebase)
git push origin your-branch --force-with-lease
```

### Can I contribute if I'm a beginner?

**Absolutely!** We welcome beginners. Start with:
- Adding simple commands
- Fixing typos
- Improving documentation

### What if my PR is rejected?

- Don't take it personally!
- Understand the reasoning
- Learn from feedback
- Try again with improvements

---

## Questions?

- **General questions**: GitHub Discussions
- **Bug reports**: GitHub Issues
- **Feature proposals**: GitHub Discussions
- **Security issues**: Email maintainers

---

## Thank You!

Every contribution makes vim-coach.nvim better for the entire Neovim community. Whether you add one command or build a major feature, your help is appreciated!

Happy contributing! 🚀

---

*For detailed technical information, see:*
- *[TESTING.md](TESTING.md) - Testing environment*
- *[DEVELOPMENT.md](DEVELOPMENT.md) - Development workflows*
- *[ARCHITECTURE.md](ARCHITECTURE.md) - Plugin architecture*
