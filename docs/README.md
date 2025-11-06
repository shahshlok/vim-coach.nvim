# vim-coach.nvim Documentation

Welcome to the vim-coach.nvim documentation! This directory contains comprehensive guides for users and contributors.

> Testing locally
> Run `./test.sh` to choose between a full LazyVim environment or a minimal setup. You can also use flags: `./test.sh --lazyvim` or `./test.sh --minimal`. See `docs/TESTING.md` for details.

## Documentation Index

### For Users

**[Main README](../README.md)**
- Installation instructions
- Usage guide
- Configuration options
- Command reference

### For Contributors

#### Beginner-Friendly Documentation

**[CONTRIBUTING.md](CONTRIBUTING.md)** - Start here!
- How to contribute
- Setting up your environment
- Submitting pull requests
- Community guidelines

**[DEVELOPMENT.md](DEVELOPMENT.md)** - Development workflows
- Making your first change
- Adding commands step-by-step
- Testing your changes
- Common development tasks
- Tips for new contributors

**[TESTING.md](TESTING.md)** - Testing environment deep dive
- How the isolated test environment works
- Understanding test.sh and minimal_init.lua
- Troubleshooting guide
- Customizing the test environment

**[ARCHITECTURE.md](ARCHITECTURE.md)** - Plugin internals
- Plugin structure and design
- How the code works
- Data flow and execution
- Extension points
- Performance considerations

#### Advanced/Expert Documentation

**[QUICK_START.md](QUICK_START.md)** - TL;DR for experienced devs
- 30-second setup
- 1-minute architecture overview
- Essential code patterns
- Quick reference
- No hand-holding

**[TECHNICAL.md](TECHNICAL.md)** - Deep technical reference
- Core implementation details
- Performance analysis and profiling
- Advanced extension patterns
- Optimization strategies
- Integration patterns
- Testing infrastructure
- Security considerations

---

## Quick Links by Task

### I want to...

#### For Beginners

**Add a new Vim command**
→ [DEVELOPMENT.md - Adding Commands](DEVELOPMENT.md#adding-a-new-command)

**Fix a bug**
→ [CONTRIBUTING.md - Fix Bugs](CONTRIBUTING.md#3-fix-bugs)

**Understand how testing works**
→ [TESTING.md](TESTING.md)

**Understand the codebase**
→ [ARCHITECTURE.md](ARCHITECTURE.md)

**Set up my dev environment**
→ [CONTRIBUTING.md - Setting Up](CONTRIBUTING.md#setting-up-development-environment)

**Submit my first PR**
→ [CONTRIBUTING.md - Submitting Changes](CONTRIBUTING.md#submitting-your-contribution)

**Propose a new feature**
→ [CONTRIBUTING.md - Add New Features](CONTRIBUTING.md#5-add-new-features)

**Improve documentation**
→ [CONTRIBUTING.md - Improve Documentation](CONTRIBUTING.md#2-improve-documentation)

#### For Experienced Developers

**Quick setup (already know Neovim plugins)**
→ [QUICK_START.md](QUICK_START.md)

**Understand performance characteristics**
→ [TECHNICAL.md - Performance Analysis](TECHNICAL.md#performance-analysis)

**Build advanced integrations**
→ [TECHNICAL.md - Advanced Extension Patterns](TECHNICAL.md#advanced-extension-patterns)

**Optimize the codebase**
→ [TECHNICAL.md - Optimization Strategies](TECHNICAL.md#optimization-strategies)

**Set up automated testing**
→ [TECHNICAL.md - Testing Infrastructure](TECHNICAL.md#testing-infrastructure)

---

## Documentation Structure

```
docs/
├── README.md           # This file - documentation index
├── CONTRIBUTING.md     # How to contribute (start here!)
├── DEVELOPMENT.md      # Development workflows and tasks
├── TESTING.md          # Testing environment explained
└── ARCHITECTURE.md     # Plugin internals and design
```

---

## Getting Started (New Contributors)

### Step 1: Read the Contributing Guide
Start with **[CONTRIBUTING.md](CONTRIBUTING.md)** - it has everything you need to get started!

### Step 2: Set Up Testing
Follow the instructions to set up the isolated test environment:
```bash
./test.sh
```

### Step 3: Make Your First Change
Pick an easy task:
- Add a simple command
- Fix a typo
- Improve a command explanation

### Step 4: Learn as You Go
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - When you need workflow help
- **[TESTING.md](TESTING.md)** - When you have testing questions
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - When you want to understand the code

---

## Documentation Philosophy

### Beginner-Friendly
All documentation is written with beginners in mind:
- No assumed knowledge of Lua
- Step-by-step instructions
- Plenty of examples
- Clear explanations

### Comprehensive
We cover:
- **What** it does
- **Why** it's done this way
- **How** to use/modify it
- **Examples** of real usage

### Practical
Focus on:
- Solving real problems
- Common workflows
- Troubleshooting
- Quick reference

---

## Contributing to Documentation

Found a typo? Section unclear? Want to add examples?

**Small fixes** (typos, grammar):
- Just submit a PR with the fix!

**Larger changes** (new sections, restructuring):
1. Open an issue to discuss first
2. Get feedback
3. Submit PR

**See**: [CONTRIBUTING.md](CONTRIBUTING.md)

---

## Documentation Standards

### Markdown Format
- Use GitHub-flavored markdown
- Include code examples
- Use headers for navigation
- Add table of contents for long docs

### Code Examples
Always include:
- Clear context
- Expected output
- Comments explaining what happens

**Good example**:
```lua
-- Add a new command to motions.lua
{
  name = "Move Right",  -- Display name
  keybind = "l",        -- Actual Vim keys
  modes = {"n", "v"},   -- Normal and visual modes
  explanation = "Moves cursor one character to the right",
  -- ... more fields
}
```

### Diagrams
Use ASCII art for flow diagrams:
```
User Input → Plugin → Picker → Display
     ↓
  Clipboard
```

---

## External Resources

### Neovim Documentation
- [Neovim Documentation](https://neovim.io/doc/)
- [Neovim API](https://neovim.io/doc/user/api.html)
- [Lua in Neovim Guide](https://github.com/nanotee/nvim-lua-guide)

### Lua Resources
- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)
- [Programming in Lua](https://www.lua.org/pil/)

### Plugin Development
- [How to write Neovim plugins in Lua](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca)
- [LazyVim Documentation](https://lazyvim.org)
- [lazy.nvim Plugin Spec](https://github.com/folke/lazy.nvim#-plugin-spec)

---

## Feedback

Have suggestions for improving the documentation?

- Open an issue with "docs:" prefix
- Submit a PR with improvements
- Start a discussion

We appreciate all feedback!

---

## Document Versions

| Document | Last Updated | Version |
|----------|--------------|---------|
| CONTRIBUTING.md | 2025-11-06 | 1.0.0 |
| DEVELOPMENT.md | 2025-11-06 | 1.0.0 |
| TESTING.md | 2025-11-06 | 1.0.0 |
| ARCHITECTURE.md | 2025-11-06 | 1.0.0 |

---

## Questions?

- Check the relevant documentation file
- Search existing issues on GitHub
- Ask in GitHub Discussions
- Open a new issue

We're here to help! 🚀

---

*Building a great plugin requires great documentation. Thank you for reading!*
