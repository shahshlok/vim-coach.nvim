-- Vim visual mode commands database
return {
  {
    name = "Visual Mode",
    keybind = "v",
    modes = {"n"},
    explanation = "Enters character-wise visual selection mode",
    beginner_tip = "Start selecting text character by character. Use movement commands to extend selection",
    when_to_use = "Selecting text for copying, deleting, or editing operations",
    context_notes = {
      file = "Perfect for selecting parts of lines, words, or small text blocks",
      explorer = "May select files/folders in some file explorers",
    },
    examples = {"v - start visual", "vw - select word", "v$ - select to line end"}
  },
  {
    name = "Visual Line Mode",
    keybind = "V",
    modes = {"n"},
    explanation = "Enters line-wise visual selection mode",
    beginner_tip = "Capital V selects entire lines. Great for selecting multiple code lines",
    when_to_use = "Selecting complete lines for moving, copying, or deleting",
    context_notes = {
      file = "Essential for selecting code blocks, functions, or multiple statements",
      explorer = "Select multiple files/folders in file explorers",
    },
    examples = {"V - select line", "Vjj - select 3 lines", "VG - select to end of file"}
  },
  {
    name = "Visual Block Mode",
    keybind = "Ctrl+v",
    modes = {"n"},
    explanation = "Enters column-wise (block) visual selection mode",
    beginner_tip = "Selects rectangular blocks of text. Advanced but very powerful",
    when_to_use = "Editing columns, aligning text, or bulk editing multiple lines",
    context_notes = {
      file = "Perfect for editing column data, adding comments to multiple lines",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"Ctrl+v - visual block", "Ctrl+vjjj - select column block", "block edit multiple lines"}
  },
  {
    name = "Select All",
    keybind = "ggVG",
    modes = {"n"},
    explanation = "Selects entire file content",
    beginner_tip = "Combination command: go to top (gg) + visual line (V) + go to end (G)",
    when_to_use = "Selecting entire file for copying, formatting, or global operations",
    context_notes = {
      file = "Quick way to select entire file for copy/paste or formatting",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"ggVG - select all", "ggVGd - delete entire file", "ggVGy - copy entire file"}
  },
  {
    name = "Extend Selection",
    keybind = "o",
    modes = {"v"},
    explanation = "Switches between start and end of visual selection",
    beginner_tip = "While in visual mode, 'o' jumps cursor to other end of selection",
    when_to_use = "Adjusting selection when you need to extend from the other end",
    context_notes = {
      file = "Useful when you need to extend selection in opposite direction",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"v3w o b - select 3 words, jump to start, extend back"}
  },
  {
    name = "Exit Visual Mode",
    keybind = "Esc",
    modes = {"v"},
    explanation = "Exits visual mode and returns to normal mode",
    beginner_tip = "Same Esc that exits insert mode. Always available to cancel selection",
    when_to_use = "Canceling a selection without performing any operation",
    context_notes = {
      file = "Use when you accidentally start visual mode or change your mind",
      explorer = "Deselect files/folders in file explorers",
    },
    examples = {"Esc - exit visual mode", "v[movement]Esc - select then cancel"}
  },
  {
    name = "Delete Selection",
    keybind = "d",
    modes = {"v"},
    explanation = "Deletes the currently selected text",
    beginner_tip = "After selecting text in visual mode, 'd' removes it",
    when_to_use = "Removing selected text blocks, lines, or characters",
    context_notes = {
      file = "Delete selected code blocks, functions, or unwanted text",
      explorer = "May delete selected files/folders in file explorers",
    },
    examples = {"vjjd - select 3 lines and delete", "vwd - select word and delete"}
  },
  {
    name = "Change Selection",
    keybind = "c",
    modes = {"v"},
    explanation = "Deletes selected text and enters insert mode",
    beginner_tip = "Combines deletion with immediate editing. Very efficient for replacements",
    when_to_use = "Replacing selected text with new content",
    context_notes = {
      file = "Perfect for replacing code blocks, variable names, or text sections",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"viwcnewName - select word and replace", "VjccnewLine - replace 2 lines"}
  },
  {
    name = "Yank Selection",
    keybind = "y",
    modes = {"v"},
    explanation = "Copies (yanks) the selected text to clipboard",
    beginner_tip = "After selecting text, 'y' copies it. Visual mode automatically exits",
    when_to_use = "Copying selected text for pasting elsewhere",
    context_notes = {
      file = "Copy code blocks, functions, or text for duplication",
      explorer = "May copy file paths in some file explorers",
    },
    examples = {"vjjy - select 3 lines and copy", "viwy - select word and copy"}
  },
  {
    name = "Indent Selection",
    keybind = ">",
    modes = {"v"},
    explanation = "Indents the selected lines to the right",
    beginner_tip = "Adds one level of indentation. Use multiple times or with count",
    when_to_use = "Adding indentation to code blocks or fixing formatting",
    context_notes = {
      file = "Essential for fixing code indentation and formatting",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"Vjj> - indent 3 lines", "V3j>> - select and indent twice"}
  },
  {
    name = "Unindent Selection",
    keybind = "<",
    modes = {"v"},
    explanation = "Removes one level of indentation from selected lines",
    beginner_tip = "Opposite of >. Removes indentation from selected lines",
    when_to_use = "Reducing indentation or fixing over-indented code",
    context_notes = {
      file = "Fix indentation when code is indented too far",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"Vjj< - unindent 3 lines", "V3j<< - select and unindent twice"}
  },
  {
    name = "Comment Selection",
    keybind = "gc",
    modes = {"v"},
    explanation = "Toggles comments on selected lines (requires comment plugin)",
    beginner_tip = "Plugin-specific command. Adds/removes comments based on file type",
    when_to_use = "Commenting out code blocks or uncommenting sections",
    context_notes = {
      file = "Works with most programming languages - adds appropriate comment syntax",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"Vjjgc - select 3 lines and toggle comments", "requires comment plugin"}
  },
  {
    name = "Select Inner Word",
    keybind = "iw",
    modes = {"v"},
    explanation = "Selects the word under cursor (inner word, no spaces)",
    beginner_tip = "Works from anywhere in the word. 'i' for inner, 'w' for word",
    when_to_use = "Quickly selecting complete words for editing",
    context_notes = {
      file = "Perfect for selecting variable names, function names",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"viw - select inner word", "viwc - select word and change"}
  },
  {
    name = "Select Around Word",
    keybind = "aw",
    modes = {"v"},
    explanation = "Selects word plus surrounding whitespace",
    beginner_tip = "'a' for 'around' - includes spaces. Useful for deleting words cleanly",
    when_to_use = "Selecting words including their surrounding spaces",
    context_notes = {
      file = "Better for deleting words as it removes extra spaces",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"vaw - select around word", "vawd - delete word and spaces"}
  },
  {
    name = "Select Inner Parentheses",
    keybind = "i(",
    modes = {"v"},
    explanation = "Selects content inside parentheses (without the parentheses)",
    beginner_tip = "Works with (), [], {}, quotes. Very powerful for code editing",
    when_to_use = "Selecting function parameters, array contents, etc.",
    context_notes = {
      file = "Essential for editing function calls, array/object contents",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"vi( - select inside parens", "vi{ - select inside braces", "vi\" - select inside quotes"}
  },
  {
    name = "Select Around Parentheses",
    keybind = "a(",
    modes = {"v"},
    explanation = "Selects content including the parentheses",
    beginner_tip = "Includes the surrounding characters. Use for deleting entire constructs",
    when_to_use = "Selecting and deleting entire function calls, arrays, etc.",
    context_notes = {
      file = "Perfect for removing entire function calls or data structures",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"va( - select around parens", "va{ - select around braces", "va\" - select around quotes"}
  },
  {
    name = "Uppercase Selection",
    keybind = "U",
    modes = {"v"},
    explanation = "Converts selected text to uppercase",
    beginner_tip = "Capital U makes selected text ALL CAPS",
    when_to_use = "Converting text to uppercase for constants, emphasis",
    context_notes = {
      file = "Useful for converting variable names to constants",
      explorer = "May rename files to uppercase in some explorers",
    },
    examples = {"viwU - select word and make uppercase", "VU - make line uppercase"}
  },
  {
    name = "Lowercase Selection",
    keybind = "u",
    modes = {"v"},
    explanation = "Converts selected text to lowercase",
    beginner_tip = "Lowercase u makes selected text all lowercase",
    when_to_use = "Converting text to lowercase for consistency",
    context_notes = {
      file = "Fix capitalization issues in code or text",
      explorer = "May rename files to lowercase in some explorers",
    },
    examples = {"viwu - select word and make lowercase", "Vu - make line lowercase"}
  },
  {
    name = "Join Lines",
    keybind = "J",
    modes = {"v"},
    explanation = "Joins all selected lines into one line",
    beginner_tip = "Removes line breaks between selected lines, adds spaces",
    when_to_use = "Combining multiple lines into a single line",
    context_notes = {
      file = "Useful for combining split statements or fixing line breaks",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"VjjJ - select 3 lines and join them", "combine multiple lines"}
  },
  {
    name = "Substitute in Selection",
    keybind = ":s/old/new/g",
    modes = {"v"},
    explanation = "Find and replace within selected text only",
    beginner_tip = "After visual selection, use :s command for replacements in selection",
    when_to_use = "Replacing text only within selected area",
    context_notes = {
      file = "Perfect for refactoring variable names in specific code blocks",
      explorer = "Usually not applicable in file explorers",
    },
    examples = {"V}:s/oldName/newName/g - select paragraph and replace text"}
  }
}