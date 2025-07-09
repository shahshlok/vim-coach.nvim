-- Vim editing commands database
return {
  {
    name = "Insert Mode",
    keybind = "i",
    modes = {"n"},
    explanation = "Enters insert mode at the current cursor position",
    beginner_tip = "Most common way to start typing. Cursor stays where it is",
    when_to_use = "When you want to insert text at the exact cursor position",
    context_notes = {
      file = "Start typing code or text at cursor position",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"i - enter insert mode", "iHello - type 'Hello' at cursor"}
  },
  {
    name = "Insert at Line Start",
    keybind = "I",
    modes = {"n"},
    explanation = "Moves to first non-whitespace character and enters insert mode",
    beginner_tip = "Capital I for 'Insert at beginning'. Combines ^ and i commands",
    when_to_use = "Adding content at the beginning of a line (after indentation)",
    context_notes = {
      file = "Perfect for adding comments or prefixes to code lines",
      explorer = "Not applicable in file explorers",
    },
    examples = {"I// - add comment at line start", "I# - add Python comment"}
  },
  {
    name = "Append",
    keybind = "a",
    modes = {"n"},
    explanation = "Enters insert mode one position after the cursor",
    beginner_tip = "Use when cursor is on a character but you want to type after it",
    when_to_use = "Adding text immediately after the current character",
    context_notes = {
      file = "Common for adding to existing words or after punctuation",
      explorer = "Not applicable in file explorers",
    },
    examples = {"a - insert after cursor", "aScript - add 'Script' after cursor"}
  },
  {
    name = "Append at Line End",
    keybind = "A",
    modes = {"n"},
    explanation = "Moves to end of line and enters insert mode",
    beginner_tip = "Capital A for 'Append at end'. Combines $ and a commands",
    when_to_use = "Adding content at the end of lines (semicolons, commas, etc.)",
    context_notes = {
      file = "Essential for adding semicolons, comments, or continuing lines",
      explorer = "Not applicable in file explorers",
    },
    examples = {"A; - add semicolon at line end", "A // comment - add end-line comment"}
  },
  {
    name = "Open Line Below",
    keybind = "o",
    modes = {"n"},
    explanation = "Creates a new line below current line and enters insert mode",
    beginner_tip = "Automatically handles indentation. Most common way to add new lines",
    when_to_use = "Adding new lines of code below current line",
    context_notes = {
      file = "Maintains proper indentation based on file type",
      explorer = "Sometimes creates new files/folders in some explorers",
    },
    examples = {"o - new line below", "o// TODO: - add TODO comment below"}
  },
  {
    name = "Open Line Above",
    keybind = "O",
    modes = {"n"},
    explanation = "Creates a new line above current line and enters insert mode",
    beginner_tip = "Capital O opens above. Also handles indentation automatically",
    when_to_use = "Adding new lines of code above current line",
    context_notes = {
      file = "Great for adding imports, comments, or new functions above",
      explorer = "May create items above current selection in some explorers",
    },
    examples = {"O - new line above", "O/* Comment */ - add comment above"}
  },
  {
    name = "Delete Character",
    keybind = "x",
    modes = {"n"},
    explanation = "Deletes the character under the cursor",
    beginner_tip = "Think of x as 'cross out'. Quick way to delete single characters",
    when_to_use = "Removing single characters, typos, or unwanted punctuation",
    context_notes = {
      file = "Fast way to remove typos or unwanted characters in code",
      explorer = "May delete/remove selected files in some explorers",
    },
    examples = {"x - delete character", "5x - delete 5 characters", "dw vs x - delete word vs character"}
  },
  {
    name = "Delete Character Before",
    keybind = "X",
    modes = {"n"},
    explanation = "Deletes the character before the cursor (like backspace)",
    beginner_tip = "Capital X deletes backwards. Less common than x",
    when_to_use = "Deleting character to the left without moving cursor first",
    context_notes = {
      file = "Useful when cursor is at end of word and you want to remove last character",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"X - delete previous character", "3X - delete 3 characters backwards"}
  },
  {
    name = "Delete Line",
    keybind = "dd",
    modes = {"n"},
    explanation = "Deletes the entire current line",
    beginner_tip = "Most common deletion command. Cursor can be anywhere on the line",
    when_to_use = "Removing entire lines of code, empty lines, or unwanted content",
    context_notes = {
      file = "Essential for code cleanup and removing unwanted lines",
      explorer = "May delete selected files/folders in file explorers",
    },
    examples = {"dd - delete line", "3dd - delete 3 lines", "dj - delete current and next line"}
  },
  {
    name = "Delete Word",
    keybind = "dw",
    modes = {"n"},
    explanation = "Deletes from cursor to the beginning of the next word",
    beginner_tip = "Combines 'd' (delete) with 'w' (word). Cursor must be at word start",
    when_to_use = "Removing words from cursor position forward",
    context_notes = {
      file = "Great for removing variable names, function names in code",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"dw - delete word", "d3w - delete 3 words", "diw - delete inner word"}
  },
  {
    name = "Delete Inner Word",
    keybind = "diw",
    modes = {"n"},
    explanation = "Deletes the entire word the cursor is on (regardless of cursor position in word)",
    beginner_tip = "Works from anywhere in the word. 'i' means 'inner'",
    when_to_use = "Deleting complete words when cursor is in the middle",
    context_notes = {
      file = "Perfect for replacing variable names or function names",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"diw - delete inner word", "ciw - change inner word (delete + insert)"}
  },
  {
    name = "Delete to End of Line",
    keybind = "D",
    modes = {"n"},
    explanation = "Deletes from cursor to the end of the line",
    beginner_tip = "Capital D for 'Delete to end'. Same as d$ but shorter",
    when_to_use = "Removing everything from cursor to line end",
    context_notes = {
      file = "Useful for removing comments, semicolons, or trailing content",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"D - delete to end", "cD - change to end (delete + insert)"}
  },
  {
    name = "Change Word",
    keybind = "cw",
    modes = {"n"},
    explanation = "Deletes from cursor to next word and enters insert mode",
    beginner_tip = "Combines delete and insert. Great for replacing parts of words",
    when_to_use = "Replacing text from cursor to end of word",
    context_notes = {
      file = "Excellent for renaming variables, changing function names",
      explorer = "May rename files in some file explorers",
    },
    examples = {"cw - change word", "c3w - change 3 words", "ciw - change inner word"}
  },
  {
    name = "Change Inner Word",
    keybind = "ciw",
    modes = {"n"},
    explanation = "Deletes the entire word cursor is on and enters insert mode",
    beginner_tip = "Works from anywhere in word. Most common way to replace words",
    when_to_use = "Completely replacing a word with new text",
    context_notes = {
      file = "Essential for refactoring - replacing variable/function names",
      explorer = "May rename selected items in file explorers",
    },
    examples = {"ciw - change inner word", "ciwNewName - replace word with 'NewName'"}
  },
  {
    name = "Change Line",
    keybind = "cc",
    modes = {"n"},
    explanation = "Deletes entire line and enters insert mode with proper indentation",
    beginner_tip = "Keeps indentation level. Better than dd + o for replacing lines",
    when_to_use = "Completely rewriting a line while maintaining indentation",
    context_notes = {
      file = "Perfect for rewriting code lines while keeping proper formatting",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"cc - change line", "3cc - change 3 lines"}
  },
  {
    name = "Substitute Character",
    keybind = "s",
    modes = {"n"},
    explanation = "Deletes character under cursor and enters insert mode",
    beginner_tip = "Same as xi but shorter. Think 's' for 'substitute'",
    when_to_use = "Replacing single characters",
    context_notes = {
      file = "Quick way to fix single character typos",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"s - substitute character", "3s - substitute 3 characters"}
  },
  {
    name = "Substitute Line",
    keybind = "S",
    modes = {"n"},
    explanation = "Deletes entire line and enters insert mode (same as cc)",
    beginner_tip = "Capital S substitutes whole line. Identical to cc command",
    when_to_use = "Completely rewriting lines (alternative to cc)",
    context_notes = {
      file = "Maintains indentation while replacing entire line",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"S - substitute line", "same as cc"}
  },
  {
    name = "Replace Character",
    keybind = "r{char}",
    modes = {"n"},
    explanation = "Replaces single character under cursor with specified character",
    beginner_tip = "Quick single character replacement. Type 'r' then the new character",
    when_to_use = "Fixing single character typos or changing punctuation",
    context_notes = {
      file = "Fast way to fix typos or change operators/punctuation",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"r; - replace with semicolon", "r( - replace with opening paren"}
  },
  {
    name = "Undo",
    keybind = "u",
    modes = {"n"},
    explanation = "Undoes the last change",
    beginner_tip = "Essential safety net. Vim has unlimited undo levels",
    when_to_use = "Reverting mistakes or unwanted changes",
    context_notes = {
      file = "Works across all editing operations in any file",
      explorer = "May undo file operations in some explorers",
    },
    examples = {"u - undo last change", "3u - undo last 3 changes"}
  },
  {
    name = "Redo",
    keybind = "Ctrl+r",
    modes = {"n"},
    explanation = "Redoes the last undone change",
    beginner_tip = "Opposite of u. Use when you undo too much",
    when_to_use = "Bringing back changes you accidentally undid",
    context_notes = {
      file = "Restores any editing operation that was undone",
      explorer = "May redo file operations in some explorers",
    },
    examples = {"Ctrl+r - redo", "3Ctrl+r - redo 3 changes"}
  },
  {
    name = "Repeat Last Change",
    keybind = ".",
    modes = {"n"},
    explanation = "Repeats the last editing command",
    beginner_tip = "Incredibly powerful. Works with deletions, changes, insertions",
    when_to_use = "Applying the same edit multiple times",
    context_notes = {
      file = "Essential for repetitive editing tasks in code",
      explorer = "May repeat last action in file explorers",
    },
    examples = {"dd. - delete line, then repeat", "ciwnewName<Esc>. - rename word, repeat"}
  },
  {
    name = "Join Lines",
    keybind = "J",
    modes = {"n"},
    explanation = "Joins current line with the line below, removing the line break",
    beginner_tip = "Removes line break and adds space. Capital J for 'Join'",
    when_to_use = "Combining lines, fixing unwanted line breaks",
    context_notes = {
      file = "Useful for fixing code split across lines or combining statements",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"J - join with next line", "3J - join next 3 lines"}
  },
  {
    name = "Yank Line",
    keybind = "yy",
    modes = {"n"},
    explanation = "Copies (yanks) the entire current line to clipboard",
    beginner_tip = "Think 'y' for 'yank' (copy). Essential for duplicating lines",
    when_to_use = "Copying lines to paste elsewhere",
    context_notes = {
      file = "Copy code lines for duplication or moving to other files",
      explorer = "May copy file paths in some file explorers",
    },
    examples = {"yy - yank line", "3yy - yank 3 lines", "yyp - duplicate line"}
  },
  {
    name = "Yank Word",
    keybind = "yw",
    modes = {"n"},
    explanation = "Copies from cursor to beginning of next word",
    beginner_tip = "Yanks partial or complete words depending on cursor position",
    when_to_use = "Copying words or parts of words",
    context_notes = {
      file = "Copy variable names, function names, or code snippets",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"yw - yank word", "yiw - yank inner word", "y3w - yank 3 words"}
  },
  {
    name = "Paste After",
    keybind = "p",
    modes = {"n"},
    explanation = "Pastes clipboard content after cursor position",
    beginner_tip = "Most common paste command. Works with any yanked or deleted content",
    when_to_use = "Inserting copied or cut content after cursor",
    context_notes = {
      file = "Paste code lines, words, or characters after cursor",
      explorer = "May paste files in some file explorers",
    },
    examples = {"p - paste after", "3p - paste 3 times", "yyp - duplicate line"}
  },
  {
    name = "Paste Before",
    keybind = "P",
    modes = {"n"},
    explanation = "Pastes clipboard content before cursor position",
    beginner_tip = "Capital P pastes before. Use when you want content before cursor",
    when_to_use = "Inserting content before current cursor position",
    context_notes = {
      file = "Paste code before cursor or above current line",
      explorer = "May paste files before current selection",
    },
    examples = {"P - paste before", "yyP - duplicate line above"}
  }
}