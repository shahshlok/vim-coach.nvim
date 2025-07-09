-- Vim motion commands database
return {
  {
    name = "Move Right",
    keybind = "l",
    modes = {"n", "v"},
    explanation = "Moves cursor one character to the right",
    beginner_tip = "Basic movement. Use this instead of arrow keys for efficiency",
    when_to_use = "Moving short distances within a line",
    context_notes = {
      file = "Works in any file for navigation",
      explorer = "Navigate through file names in file explorers",
    },
    examples = {"l - move right one character", "5l - move right 5 characters"}
  },
  {
    name = "Move Left", 
    keybind = "h",
    modes = {"n", "v"},
    explanation = "Moves cursor one character to the left",
    beginner_tip = "Think 'h' is on the left side of jkl keys",
    when_to_use = "Moving short distances within a line",
    context_notes = {
      file = "Works in any file for navigation",
      explorer = "Navigate through file names in file explorers",
    },
    examples = {"h - move left one character", "3h - move left 3 characters"}
  },
  {
    name = "Move Down",
    keybind = "j", 
    modes = {"n", "v"},
    explanation = "Moves cursor one line down",
    beginner_tip = "Think 'j' looks like a down arrow",
    when_to_use = "Moving between lines vertically",
    context_notes = {
      file = "Navigate down through code lines",
      explorer = "Move down through file/folder list",
    },
    examples = {"j - move down one line", "10j - move down 10 lines"}
  },
  {
    name = "Move Up",
    keybind = "k",
    modes = {"n", "v"},
    explanation = "Moves cursor one line up", 
    beginner_tip = "Think 'k' points upward",
    when_to_use = "Moving between lines vertically",
    context_notes = {
      file = "Navigate up through code lines",
      explorer = "Move up through file/folder list",
    },
    examples = {"k - move up one line", "7k - move up 7 lines"}
  },
  {
    name = "Word Forward",
    keybind = "w",
    modes = {"n", "v"},
    explanation = "Moves cursor to the beginning of the next word",
    beginner_tip = "Much faster than using 'l' repeatedly. Words are separated by spaces or punctuation",
    when_to_use = "Jumping between words quickly",
    context_notes = {
      file = "Navigate between variable names, function names in code",
      explorer = "Less useful in file explorers",
    },
    examples = {"w - next word", "3w - jump 3 words forward"}
  },
  {
    name = "Word Backward",
    keybind = "b",
    modes = {"n", "v"},
    explanation = "Moves cursor to the beginning of the previous word",
    beginner_tip = "Think 'b' for 'back'. Goes to start of current word if in middle of word",
    when_to_use = "Going back to edit previous words",
    context_notes = {
      file = "Navigate back through code to fix typos or edit",
      explorer = "Less useful in file explorers",
    },
    examples = {"b - previous word", "2b - jump 2 words back"}
  },
  {
    name = "End of Word",
    keybind = "e",
    modes = {"n", "v"},
    explanation = "Moves cursor to the end of the current/next word",
    beginner_tip = "Think 'e' for 'end'. Useful for selecting words in visual mode",
    when_to_use = "Positioning at word endings, especially in visual mode",
    context_notes = {
      file = "Great for selecting entire words in visual mode",
      explorer = "Less commonly used in file explorers",
    },
    examples = {"e - end of word", "ve - select entire word"}
  },
  {
    name = "WORD Forward",
    keybind = "W",
    modes = {"n", "v"},
    explanation = "Moves to next WORD (space-separated, ignores punctuation)",
    beginner_tip = "Capital W treats punctuation as part of words. 'hello.world' is one WORD",
    when_to_use = "Jumping over punctuation-heavy code",
    context_notes = {
      file = "Useful in code with lots of dots, underscores, brackets",
      explorer = "Rarely used in file explorers",
    },
    examples = {"W - next WORD", "2W - jump 2 WORDS forward"}
  },
  {
    name = "Beginning of Line",
    keybind = "0",
    modes = {"n", "v"},
    explanation = "Moves cursor to the very beginning of the current line",
    beginner_tip = "Goes to column 0, even before indentation. Use ^ for first non-whitespace",
    when_to_use = "Going to the absolute start of a line",
    context_notes = {
      file = "Useful for seeing full line indentation or selecting from start",
      explorer = "Moves to beginning of file/folder names",
    },
    examples = {"0 - start of line", "v0 - select to start of line"}
  },
  {
    name = "First Non-Whitespace",
    keybind = "^",
    modes = {"n", "v"},
    explanation = "Moves cursor to the first non-whitespace character of the line",
    beginner_tip = "More useful than 0 in most cases. Skips indentation to actual content",
    when_to_use = "Going to where the actual content starts on a line",
    context_notes = {
      file = "Perfect for indented code - jumps past tabs/spaces to content",
      explorer = "Same as 0 in most file explorers",
    },
    examples = {"^ - first non-whitespace", "d^ - delete to start of content"}
  },
  {
    name = "End of Line",
    keybind = "$",
    modes = {"n", "v"},
    explanation = "Moves cursor to the end of the current line",
    beginner_tip = "Think of $ as 'end' like in regex. Very commonly used",
    when_to_use = "Going to line endings, adding content at end of lines",
    context_notes = {
      file = "Essential for adding semicolons, editing line endings",
      explorer = "Goes to end of file/folder names",
    },
    examples = {"$ - end of line", "d$ - delete to end of line", "A - append at end ($ + i)"}
  },
  {
    name = "Go to Line",
    keybind = "gg",
    modes = {"n", "v"},
    explanation = "Goes to the first line of the file (or specified line number)",
    beginner_tip = "Double tap 'g'. Add number before for specific line: 42gg goes to line 42",
    when_to_use = "Jumping to beginning of file or specific line numbers",
    context_notes = {
      file = "Essential for navigation in large files",
      explorer = "Goes to first item in file list",
    },
    examples = {"gg - first line", "42gg - line 42", "1G - also first line"}
  },
  {
    name = "Go to Last Line",
    keybind = "G",
    modes = {"n", "v"},
    explanation = "Goes to the last line of the file",
    beginner_tip = "Capital G for 'Go to end'. Pair with gg to quickly check file length",
    when_to_use = "Jumping to end of file, seeing total file length",
    context_notes = {
      file = "Quick way to see how long a file is or add content at end",
      explorer = "Goes to last item in file list",
    },
    examples = {"G - last line", "dG - delete to end of file", "vG - select to end"}
  },
  {
    name = "Find Character Forward",
    keybind = "f{char}",
    modes = {"n", "v"},
    explanation = "Finds and moves to the next occurrence of specified character on current line",
    beginner_tip = "Type 'f' then the character you want to find. Use ; to repeat, , to reverse",
    when_to_use = "Quick navigation to specific characters on the same line",
    context_notes = {
      file = "Perfect for jumping to parentheses, quotes, specific letters in code",
      explorer = "Less useful in file explorers",
    },
    examples = {"f( - find next (", "f; - find next ;", "3f, - find 3rd comma"}
  },
  {
    name = "Find Character Backward",
    keybind = "F{char}",
    modes = {"n", "v"},
    explanation = "Finds and moves to the previous occurrence of specified character on current line",
    beginner_tip = "Capital F searches backward. Use with ; and , for navigation",
    when_to_use = "Going back to a character you passed on the current line",
    context_notes = {
      file = "Useful for going back to opening brackets or quotes",
      explorer = "Rarely used in file explorers",
    },
    examples = {"F( - find previous (", "F\" - find previous quote"}
  },
  {
    name = "Move to Character",
    keybind = "t{char}",
    modes = {"n", "v"},
    explanation = "Moves cursor one position before the next occurrence of character",
    beginner_tip = "Think 't' for 'to' or 'till'. Stops just before the character",
    when_to_use = "Positioning just before a character for editing",
    context_notes = {
      file = "Great for inserting content before punctuation",
      explorer = "Rarely used in file explorers",
    },
    examples = {"t, - move till comma", "dt) - delete till closing paren"}
  },
  {
    name = "Repeat Find",
    keybind = ";",
    modes = {"n", "v"},
    explanation = "Repeats the last f, F, t, or T search in the same direction",
    beginner_tip = "After using f or t, tap ; to find the next occurrence",
    when_to_use = "Continuing search for same character after initial find",
    context_notes = {
      file = "Excellent for navigating through multiple instances of same character",
      explorer = "Not applicable in file explorers",
    },
    examples = {"f(;; - find ( then next two occurrences"}
  },
  {
    name = "Reverse Find",
    keybind = ",",
    modes = {"n", "v"},
    explanation = "Repeats the last f, F, t, or T search in the opposite direction",
    beginner_tip = "If you went too far with ;, use , to go back",
    when_to_use = "Reversing direction when you overshoot with ;",
    context_notes = {
      file = "Helps when you need to backtrack during character searches",
      explorer = "Not applicable in file explorers",
    },
    examples = {"f(;;, - find (, go forward twice, then back once"}
  },
  {
    name = "Page Down",
    keybind = "Ctrl+f",
    modes = {"n", "v"},
    explanation = "Scrolls down one full page (screenful) of content",
    beginner_tip = "Think 'f' for 'forward'. Much faster than j for large files",
    when_to_use = "Moving through large files quickly",
    context_notes = {
      file = "Essential for navigating large source files",
      explorer = "Scrolls through long directory listings",
    },
    examples = {"Ctrl+f - page down", "3Ctrl+f - three pages down"}
  },
  {
    name = "Page Up",
    keybind = "Ctrl+b",
    modes = {"n", "v"},
    explanation = "Scrolls up one full page (screenful) of content",
    beginner_tip = "Think 'b' for 'back'. Opposite of Ctrl+f",
    when_to_use = "Going back up through content you've scrolled past",
    context_notes = {
      file = "Navigate back up through large files",
      explorer = "Scroll back up through directory listings",
    },
    examples = {"Ctrl+b - page up", "2Ctrl+b - two pages up"}
  },
  {
    name = "Half Page Down",
    keybind = "Ctrl+d",
    modes = {"n", "v"},
    explanation = "Scrolls down half a page of content",
    beginner_tip = "Think 'd' for 'down'. Smoother scrolling than Ctrl+f",
    when_to_use = "More controlled scrolling with better context retention",
    context_notes = {
      file = "Preferred by many for maintaining context while reading code",
      explorer = "Gentler scrolling through file lists",
    },
    examples = {"Ctrl+d - half page down"}
  },
  {
    name = "Half Page Up",
    keybind = "Ctrl+u",
    modes = {"n", "v"},
    explanation = "Scrolls up half a page of content",
    beginner_tip = "Think 'u' for 'up'. Opposite of Ctrl+d",
    when_to_use = "Controlled upward scrolling while maintaining context",
    context_notes = {
      file = "Better than Ctrl+b for keeping track of where you are",
      explorer = "Smooth upward scrolling through directories",
    },
    examples = {"Ctrl+u - half page up"}
  }
}