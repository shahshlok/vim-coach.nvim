-- Plugin-specific commands database
return {
  {
    name = "File Explorer Toggle",
    keybind = "<leader>e",
    modes = {"n"},
    explanation = "Toggles the file explorer sidebar (Neo-tree)",
    beginner_tip = "Essential for navigating project files. Most common way to open file browser",
    when_to_use = "Opening file explorer to navigate project structure",
    context_notes = {
      file = "Opens file tree showing current project structure",
      explorer = "Closes the file explorer if already open",
    },
    examples = {"<leader>e - toggle Neo-tree", "navigate project files"}
  },
  {
    name = "Find Files",
    keybind = "<leader>ff",
    modes = {"n"},
    explanation = "Opens fuzzy file finder (Telescope) to search for files",
    beginner_tip = "Fastest way to open files. Start typing filename and fuzzy search finds it",
    when_to_use = "Quickly opening files when you know part of the filename",
    context_notes = {
      file = "Searches all files in current project/directory",
      explorer = "More efficient than browsing through file tree",
    },
    examples = {"<leader>ff - find files", "type partial name to search"}
  },
  {
    name = "Live Grep",
    keybind = "<leader>fg",
    modes = {"n"},
    explanation = "Search for text content across all files in project",
    beginner_tip = "Find text inside files, not filenames. Great for finding function calls",
    when_to_use = "Searching for specific code, function names, or text across project",
    context_notes = {
      file = "Searches file contents, shows preview and context",
      explorer = "Much more powerful than simple file search",
    },
    examples = {"<leader>fg - live grep", "search for function names, variables"}
  },
  {
    name = "Recent Files",
    keybind = "<leader>fr",
    modes = {"n"},
    explanation = "Shows list of recently opened files for quick access",
    beginner_tip = "Quick way to return to files you were working on recently",
    when_to_use = "Switching back to files you've worked on in current session",
    context_notes = {
      file = "Shows files from current and previous sessions",
      explorer = "Faster than navigating file tree for recent files",
    },
    examples = {"<leader>fr - recent files", "quick access to recent work"}
  },
  {
    name = "Find Buffers",
    keybind = "<leader>fb",
    modes = {"n"},
    explanation = "Shows list of currently open buffers (files) for switching",
    beginner_tip = "See all files currently open in editor. Better than buffer line clicking",
    when_to_use = "Switching between multiple open files",
    context_notes = {
      file = "Shows only currently loaded files in memory",
      explorer = "Different from recent files - only currently open ones",
    },
    examples = {"<leader>fb - find buffers", "switch between open files"}
  },
  {
    name = "LazyGit",
    keybind = "<leader>gg",
    modes = {"n"},
    explanation = "Opens LazyGit terminal UI for git operations",
    beginner_tip = "Visual git interface. Much easier than command line git for beginners",
    when_to_use = "All git operations: staging, committing, pushing, viewing history",
    context_notes = {
      file = "Shows git status of current repository",
      explorer = "Works on entire git repository, not just current file",
    },
    examples = {"<leader>gg - open LazyGit", "visual git operations"}
  },
  {
    name = "Terminal Toggle",
    keybind = "<leader>tt",
    modes = {"n"},
    explanation = "Opens/closes floating terminal window",
    beginner_tip = "Quick access to command line without leaving editor",
    when_to_use = "Running commands, scripts, or accessing shell",
    context_notes = {
      file = "Terminal opens in current working directory",
      explorer = "Provides full shell access within editor",
    },
    examples = {"<leader>tt - toggle terminal", "run commands without leaving vim"}
  },
  {
    name = "Buffer Close",
    keybind = "<leader>bd",
    modes = {"n"},
    explanation = "Closes current buffer (file) without closing window",
    beginner_tip = "Proper way to close files. Keeps window layout intact",
    when_to_use = "Closing files you're done editing",
    context_notes = {
      file = "Closes current file but keeps editor open",
      explorer = "Different from quitting - just closes one file",
    },
    examples = {"<leader>bd - close buffer", "clean up open files"}
  },
  {
    name = "Next Buffer",
    keybind = "]b",
    modes = {"n"},
    explanation = "Switches to next open buffer in the buffer list",
    beginner_tip = "Cycle through open files. Works with bufferline tabs",
    when_to_use = "Moving forward through open files",
    context_notes = {
      file = "Navigates to next file in buffer order",
      explorer = "Works well with visible buffer tabs",
    },
    examples = {"]b - next buffer", "cycle through open files"}
  },
  {
    name = "Previous Buffer",
    keybind = "[b",
    modes = {"n"},
    explanation = "Switches to previous open buffer in the buffer list",
    beginner_tip = "Cycle backward through open files. Pair with ]b",
    when_to_use = "Moving backward through open files",
    context_notes = {
      file = "Navigates to previous file in buffer order",
      explorer = "Reverse direction of ]b command",
    },
    examples = {"[b - previous buffer", "cycle backward through files"}
  },
  {
    name = "LSP Go to Definition",
    keybind = "gd",
    modes = {"n"},
    explanation = "Jump to definition of symbol under cursor",
    beginner_tip = "Put cursor on function/variable name and press gd to see where it's defined",
    when_to_use = "Understanding code by jumping to where functions/variables are defined",
    context_notes = {
      file = "Works with any programming language that has LSP support",
      explorer = "Only works in code files, not file explorers",
    },
    examples = {"gd - go to definition", "understand code by following definitions"}
  },
  {
    name = "LSP Find References",
    keybind = "gr",
    modes = {"n"},
    explanation = "Find all references to symbol under cursor",
    beginner_tip = "See everywhere a function/variable is used in your project",
    when_to_use = "Understanding code usage or finding all places to update",
    context_notes = {
      file = "Shows list of all files where symbol is referenced",
      explorer = "Only works in code files with LSP support",
    },
    examples = {"gr - find references", "see all usages of function/variable"}
  },
  {
    name = "Diagnostics Trouble",
    keybind = "<leader>xx",
    modes = {"n"},
    explanation = "Opens diagnostics panel showing all errors and warnings",
    beginner_tip = "See all problems in your code in one organized view",
    when_to_use = "Reviewing and fixing errors, warnings, and linting issues",
    context_notes = {
      file = "Shows issues from all files in workspace",
      explorer = "Provides organized view of code problems",
    },
    examples = {"<leader>xx - open trouble diagnostics", "review all code issues"}
  },
  {
    name = "Buffer Diagnostics",
    keybind = "<leader>xX",
    modes = {"n"},
    explanation = "Shows diagnostics only for current buffer/file",
    beginner_tip = "Focus on problems in just the current file you're editing",
    when_to_use = "Fixing issues in current file without distraction",
    context_notes = {
      file = "Filtered view showing only current file's problems",
      explorer = "More focused than workspace-wide diagnostics",
    },
    examples = {"<leader>xX - current buffer diagnostics", "fix current file issues"}
  },
  {
    name = "Format Document",
    keybind = "<leader>mp",
    modes = {"n"},
    explanation = "Formats current file using configured formatter",
    beginner_tip = "Automatically fixes code formatting, indentation, and style",
    when_to_use = "Cleaning up code formatting before saving or committing",
    context_notes = {
      file = "Uses language-specific formatters (prettier, black, etc.)",
      explorer = "Only works on code files, not in file explorers",
    },
    examples = {"<leader>mp - format file", "clean up code formatting"}
  },
  {
    name = "Session Save",
    keybind = "<leader>ws",
    modes = {"n"},
    explanation = "Saves current session (open files, window layout)",
    beginner_tip = "Remember your current workspace setup for later restoration",
    when_to_use = "Preserving work state when switching projects or taking breaks",
    context_notes = {
      file = "Saves all open files and their positions",
      explorer = "Includes file explorer state and window layout",
    },
    examples = {"<leader>ws - save session", "preserve workspace state"}
  },
  {
    name = "Session Restore",
    keybind = "<leader>wr",
    modes = {"n"},
    explanation = "Restores previously saved session",
    beginner_tip = "Get back to exactly where you left off in your project",
    when_to_use = "Returning to previous work state or switching between projects",
    context_notes = {
      file = "Reopens all files that were open when session was saved",
      explorer = "Restores complete workspace including layouts",
    },
    examples = {"<leader>wr - restore session", "return to previous workspace"}
  },
  {
    name = "Flash Jump",
    keybind = "s",
    modes = {"n", "v"},
    explanation = "Enhanced character jumping with labels",
    beginner_tip = "Type 's' then characters to see labeled jump points. Much faster than w/e/f",
    when_to_use = "Quick navigation to visible locations on screen",
    context_notes = {
      file = "Works in any text file for fast cursor movement",
      explorer = "Enhanced navigation compared to basic vim motions",
    },
    examples = {"s - flash jump", "sth - jump to 'th' with labels"}
  },
  {
    name = "Flash Treesitter",
    keybind = "S",
    modes = {"n", "v"},
    explanation = "Jump to code structures using treesitter (functions, classes, etc.)",
    beginner_tip = "Capital S shows labels for code structures like functions and classes",
    when_to_use = "Jumping to specific code structures quickly",
    context_notes = {
      file = "Works in programming files with treesitter support",
      explorer = "Only useful in code files, not plain text",
    },
    examples = {"S - treesitter jump", "jump to functions, classes, blocks"}
  },
  {
    name = "Snippet Expand",
    keybind = "<Tab>",
    modes = {"i"},
    explanation = "Expands snippet or jumps to next snippet placeholder",
    beginner_tip = "Type snippet trigger and press Tab. Use Tab to move between placeholders",
    when_to_use = "Quickly inserting code templates and boilerplate",
    context_notes = {
      file = "Works in any file type with appropriate snippets",
      explorer = "Only works when typing in files, not explorers",
    },
    examples = {"func<Tab> - expand function snippet", "Tab through placeholders"}
  },
  {
    name = "Which Key Help",
    keybind = "<leader>hk",
    modes = {"n"},
    explanation = "Shows available keybindings for current buffer context",
    beginner_tip = "See what key combinations are available in current context",
    when_to_use = "Discovering available commands without opening full help",
    context_notes = {
      file = "Shows context-specific keybindings",
      explorer = "May show different bindings based on file type",
    },
    examples = {"<leader>hk - show context keys", "discover available commands"}
  }
}