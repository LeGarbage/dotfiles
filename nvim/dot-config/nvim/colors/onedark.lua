vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") then
    vim.cmd.syntax = "reset"
end

vim.g.colors_name = "onedark"

-- Color Palette
local gray1       = '#282c34'
local gray2       = '#31353f'
local gray3       = '#393f4a'
local gray4       = '#5c6370'
local gray5       = '#abb2bf'
local red         = '#e86671'
local green       = '#98c379'
local yellow      = '#e5c07b'
local blue        = '#61afef'
local blue2       = '#5873dd'
local purple      = '#c678dd'
local cyan        = '#56b6c2'
local orange      = '#d19a66'
local indigo      = '#7681de'
local pink        = '#ff69b4'
local warning     = '#d6a940'
local error       = '#de3758'
local info        = '#13b0bf'
local hint        = '#4ab235'
local diff_add    = "#31392b"
local diff_delete = "#382b2c"
local diff_change = "#1c3448"
local diff_text   = "#2c5372"

local function define_highlight(group, fg, bg, attr)
    if string.len(fg) ~= 0 then
        vim.cmd('highlight ' .. group .. ' guifg=' .. fg)
    end

    if string.len(bg) ~= 0 then
        vim.cmd('highlight ' .. group .. ' guibg=' .. bg)
    end

    if string.len(attr) ~= 0 then
        vim.cmd('highlight ' .. group .. ' gui=' .. attr .. ' cterm=' .. attr)
    end
end

-- Define the highlights
define_highlight('DiagnosticError', error, '', 'italic')
define_highlight('DiagnosticWarn', warning, '', 'italic')
define_highlight('DiagnosticInfo', info, '', 'italic')
define_highlight('DiagnosticHint', hint, '', 'italic')
define_highlight('DiagnosticSignError', error, '', 'none')
define_highlight('DiagnosticSignWarn', warning, '', 'none')
define_highlight('DiagnosticSignInfo', info, '', 'none')
define_highlight('DiagnosticSignHint', hint, '', 'none')
define_highlight('DiagnosticUnderlineError', '', '', 'undercurl guisp=' .. error)
define_highlight('DiagnosticUnderlineWarn', '', '', 'undercurl guisp=' .. warning)
define_highlight('DiagnosticUnderlineInfo', '', '', 'undercurl guisp=' .. info)
-- Vim Editor
define_highlight('ColorColumn', '', gray2, '')
define_highlight('Cursor', gray2, gray5, '')
define_highlight('CursorColumn', '', gray2, '')
define_highlight('CursorLine', '', gray2, 'none')
define_highlight('CursorLineNr', gray5, gray2, 'none')
define_highlight('CursorLineSign', '', gray2, 'none')
define_highlight('CursorLineFold', '', gray2, 'none')
define_highlight('Directory', blue, '', '')
define_highlight('DiffAdd', 'NONE', diff_add, 'none')
define_highlight('DiffChange', 'NONE', diff_change, 'none')
define_highlight('DiffDelete', 'NONE', diff_delete, 'none')
define_highlight('DiffText', 'NONE', diff_text, 'none')
define_highlight('ErrorMsg', red, gray1, 'bold')
define_highlight('NormalFloat', gray5, gray2, '')
define_highlight('FloatBorder', gray5, gray2, '')
define_highlight('FoldColumn', gray4, gray1, '')
-- define_highlight('Folded', '', gray1, '')
vim.cmd("hi clear Folded")
define_highlight('FoldedIcon', gray4, '', '')
define_highlight('FoldedText', gray1, gray4, '')
define_highlight('IncSearch', yellow, '', '')
define_highlight('LineNr', gray3, '', '')
define_highlight('LspInlayHint', gray4, '', 'italic')
vim.g.matchparen_disable_cursor_hl = true
define_highlight('MatchParen', red, gray3, 'bold')
define_highlight('ModeMsg', green, '', '')
define_highlight('MoreMsg', green, '', '')
define_highlight('NonText', gray4, '', 'none')
define_highlight('Normal', gray5, gray1, 'none')
define_highlight('Pmenu', gray5, gray3, '')
define_highlight('PmenuSbar', 'NONE', 'NONE', '')
define_highlight('PmenuSel', gray2, indigo, '')
define_highlight('PmenuThumb', 'NONE', 'NONE', '')
define_highlight('Question', blue, '', 'none')
define_highlight('Search', gray1, yellow, '')
define_highlight('SignColumn', gray5, gray1, '')
define_highlight('SnippetTabStop', '', gray3, '')
define_highlight('SpecialKey', gray4, '', '')
define_highlight('SpellCap', warning, '', 'undercurl guisp=' .. warning)
define_highlight('SpellBad', error, '', 'undercurl guisp=' .. error)
define_highlight('SpellRare', info, '', 'undercurl guisp=' .. info)
define_highlight('SpellLocal', hint, '', 'undercurl guisp=' .. hint)
define_highlight('StatusLine', gray5, gray3, 'none')
define_highlight('StatusLineNC', gray2, gray4, '')
define_highlight('TabLine', gray4, gray2, 'none')
define_highlight('TabLineFill', gray4, gray2, 'none')
define_highlight('TabLineSel', yellow, gray3, 'none')
define_highlight('Title', gray5, '', 'none')
define_highlight('VertSplit', gray4, gray1, 'none')
define_highlight('Visual', gray5, gray3, '')
define_highlight('WarningMsg', red, '', '')
define_highlight('WildMenu', gray2, indigo, '')
define_highlight("Winbar", gray5, gray2, '')
define_highlight("WinbarNC", gray4, gray2, '')
define_highlight('TermFloatBorder', gray5, gray2, '')
define_highlight('TermNormalFloat', gray5, gray2, '')

-- Standard Syntax
define_highlight('Comment', gray4, '', 'italic')
define_highlight('Constant', orange, '', '')
define_highlight('String', green, '', '')
define_highlight('Character', green, '', '')
define_highlight('Identifier', red, '', 'none')
define_highlight('Function', blue, '', '')
define_highlight('Statement', purple, '', 'none')
define_highlight('Operator', cyan, '', '')
define_highlight('PreProc', cyan, '', '')
define_highlight('Include', blue, '', '')
define_highlight('Define', purple, '', 'none')
define_highlight('Macro', purple, '', '')
define_highlight('Type', yellow, '', 'none')
define_highlight('Structure', cyan, '', '')
define_highlight('Special', indigo, '', '')
define_highlight('Delimiter', gray5, '', '')
define_highlight('Underlined', blue, '', 'none')
define_highlight('Error', red, gray1, 'bold')
define_highlight('Todo', orange, gray1, 'bold')
define_highlight('@variable.parameter', red, '', 'italic')
define_highlight('@variable', red, '', '')
define_highlight('@property', blue2, '', '')
define_highlight('@tag', yellow, '', '')
define_highlight('@tag.html', red, '', '')
define_highlight('@tag.delimiter', gray5, '', '')
define_highlight('@tag.attribute', blue2, '', '')

-- Terminal
vim.g.terminal_color_0  = gray1
vim.g.terminal_color_1  = red
vim.g.terminal_color_2  = green
vim.g.terminal_color_3  = yellow
vim.g.terminal_color_4  = blue
vim.g.terminal_color_5  = purple
vim.g.terminal_color_6  = cyan
vim.g.terminal_color_7  = gray5
vim.g.terminal_color_8  = gray4
vim.g.terminal_color_9  = red
vim.g.terminal_color_10 = green
vim.g.terminal_color_11 = yellow
vim.g.terminal_color_12 = blue
vim.g.terminal_color_13 = purple
vim.g.terminal_color_14 = cyan
vim.g.terminal_color_15 = gray5

-- Telescope
define_highlight("TelescopeSelection", '', gray3, '')
define_highlight("TelescopePreviewLine", '', gray3, '')

-- Org
define_highlight('@org.agenda.time_grid', gray5, '', '')
define_highlight('@org.agenda.weekend', '', '', 'italic')
define_highlight('@org.agenda.scheduled_past', yellow, '', '')
define_highlight('@org.agenda.deadline', orange, '', '')
define_highlight('@org.agenda.scheduled', blue, '', '')

-- Treesitter context
vim.cmd("hi link TreesitterContextLineNumber NormalFloat")
define_highlight("TreesitterContextBottom", "", "", "underdotted guisp=" .. gray4)
define_highlight("TreesitterContextLineNumberBottom", "", "", "underdotted guisp=" .. gray4)

-- Snacks
define_highlight("SnacksIndentScope", gray3, '', '')
define_highlight("SnacksIndent", gray2, '', '')

-- Debugger
vim.cmd("hi link NvimDapVirtualText DiagnosticInfo")

-- Illuminate
define_highlight("IlluminatedWordText", "", gray3, "")
define_highlight("IlluminatedWordRead", "", gray3, "")
define_highlight("IlluminatedWordWrite", "", gray3, "")

-- Completion
define_highlight('BlinkCmpKindFunction', blue, '', '')
define_highlight('BlinkCmpKindMethod', blue, '', '')
define_highlight('BlinkCmpKindField', red, '', '')
define_highlight('BlinkCmpKindVariable', red, '', '')
define_highlight('BlinkCmpKindProperty', blue2, '', '')
define_highlight('BlinkCmpKindClass', yellow, '', '')
define_highlight('BlinkCmpKindConstructor', yellow, '', '')
define_highlight('BlinkCmpKindModule', yellow, '', '')
define_highlight('BlinkCmpKindStruct', yellow, '', '')
define_highlight('BlinkCmpKindEnum', yellow, '', '')
define_highlight('BlinkCmpKindEnumMember', red, '', '')
define_highlight('BlinkCmpKindKeyword', purple, '', '')
define_highlight('BlinkCmpKindConstant', orange, '', '')
define_highlight('BlinkCmpKindSnippet', pink, '', '')
define_highlight('BlinkCmpKindFile', cyan, '', '')

-- Pairs
define_highlight('BlinkPairsUnmatched', error, '', '')

-- CSS
define_highlight('cssAttrComma', gray5, '', '')
define_highlight('cssPseudoClassId', yellow, '', '')
define_highlight('cssBraces', gray5, '', '')
define_highlight('cssClassName', yellow, '', '')
define_highlight('cssClassNameDot', yellow, '', '')
define_highlight('cssFunctionName', blue, '', '')
define_highlight('cssImportant', cyan, '', '')
define_highlight('cssIncludeKeyword', purple, '', '')
define_highlight('cssTagName', red, '', '')
define_highlight('cssMediaType', orange, '', '')
define_highlight('cssProp', gray5, '', '')
define_highlight('cssSelectorOp', cyan, '', '')
define_highlight('cssSelectorOp2', cyan, '', '')

-- Commit Messages (Git)
define_highlight('gitcommitHeader', purple, '', '')
define_highlight('gitcommitUnmerged', green, '', '')
define_highlight('gitcommitSelectedFile', green, '', '')
define_highlight('gitcommitDiscardedFile', red, '', '')
define_highlight('gitcommitUnmergedFile', yellow, '', '')
define_highlight('gitcommitSelectedType', green, '', '')
define_highlight('gitcommitSummary', blue, '', '')
define_highlight('gitcommitDiscardedType', red, '', '')
vim.cmd("hi link gitcommitNoBranch       gitcommitBranch")
vim.cmd("hi link gitcommitUntracked      gitcommitComment")
vim.cmd("hi link gitcommitDiscarded      gitcommitComment")
vim.cmd("hi link gitcommitSelected       gitcommitComment")
vim.cmd("hi link gitcommitDiscardedArrow gitcommitDiscardedFile")
vim.cmd("hi link gitcommitSelectedArrow  gitcommitSelectedFile")
vim.cmd("hi link gitcommitUnmergedArrow  gitcommitUnmergedFile")

-- HTML
define_highlight('htmlEndTag', blue, '', '')
define_highlight('htmlLink', red, '', '')
define_highlight('htmlTag', blue, '', '')
define_highlight('htmlTitle', gray5, '', '')
define_highlight('htmlSpecialTagName', purple, '', '')

-- Javascript
define_highlight('javaScriptBraces', gray5, '', '')
define_highlight('javaScriptNull', orange, '', '')
define_highlight('javaScriptIdentifier', purple, '', '')
define_highlight('javaScriptNumber', orange, '', '')
define_highlight('javaScriptRequire', cyan, '', '')
define_highlight('javaScriptReserved', purple, '', '')

-- JSON
define_highlight('jsonBraces', gray5, '', '')

-- Markdown
define_highlight('markdownBold', yellow, '', 'bold')
define_highlight('markdownCode', cyan, '', '')
define_highlight('markdownCodeBlock', cyan, '', '')
define_highlight('markdownCodeDelimiter', cyan, '', '')
define_highlight('markdownHeadingDelimiter', green, '', '')
define_highlight('markdownHeadingRule', gray4, '', '')
define_highlight('markdownId', purple, '', '')
define_highlight('markdownItalic', blue, '', 'italic')
define_highlight('markdownListMarker', orange, '', '')
define_highlight('markdownOrderedListMarker', orange, '', '')
define_highlight('markdownRule', gray4, '', '')
define_highlight('markdownUrl', purple, '', '')
define_highlight('markdownUrlTitleDelimiter', green, '', '')


-- Vim-Fugitive
define_highlight('diffAdded', green, '', '')
define_highlight('diffRemoved', red, '', '')

-- Vim-Gittgutter
define_highlight('GitGutterAdd', green, '', '')
define_highlight('GitGutterChange', yellow, '', '')
define_highlight('GitGutterChangeDelete', orange, '', '')
define_highlight('GitGutterDelete', red, '', '')
