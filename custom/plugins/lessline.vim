"Color Palette
let s:gray1 = '#212121'
let s:gray2  = '#292929'
let s:gray3 = '#474646'
let s:gray4 = '#6a6c6c'
let s:gray5 = '#b7bdc0'
let s:red = '#de3758'
let s:green = '#2f8c1c'
let s:yellow = '#d6a940'
let s:blue = '#3663c9'
let s:purple = '#6333cc'
let s:cyan = '#337a80'
let s:orange = '#bf6430'
let s:indigo = '#ff69b4'

let s:left_sep = ''
let s:right_sep = ''
let s:inactive_left_sep = ''
let s:inactive_right_sep = ''
let s:tab_sep = ''
let s:inactive_tab_sep = ''

"Settings to make sure the statusline works
set noshowmode
set laststatus=2
set termguicolors

"Set the highlight colors for easy reference
let s:mainfg = s:gray4
let s:mainbg = s:gray2
let s:secfg = s:gray5
let s:secbg = s:gray3
let s:prifg = s:gray2
let s:inactivepribg = s:gray4
let s:tabsecfg = s:gray1
let s:tabsecbg = s:gray3

"Build the highlight colors
exec 'highlight LineMain guifg=' . s:mainfg . ' guibg=' . s:mainbg

exec 'highlight LineSec guifg=' . s:secfg . ' guibg=' . s:secbg
exec 'highlight LineSecTransition guifg=' . s:secbg . ' guibg=' . s:mainbg

exec 'highlight LineWarn guifg=' . s:prifg . ' guibg=' . s:yellow

exec 'highlight LineErr guifg=' . s:prifg . ' guibg=' . s:red
exec 'highlight LineErrTransition guifg=' . s:red . ' guibg=' . s:yellow

exec 'highlight LinePriInactive guifg=' . s:prifg . ' guibg=' . s:inactivepribg
exec 'highlight LinePriInactiveTransition guifg=' . s:inactivepribg . ' guibg=' . s:mainbg

exec 'highlight TabLineSec guifg=' . s:tabsecfg . ' guibg=' . s:tabsecbg
exec 'highlight TabLineMainTransition guifg=' . s:tabsecbg . ' guibg=' . s:mainbg

"exec 'highlight LinePri guifg=' . s:gray2 . ' guibg=' .  blue

lua << EOF
function GetLSPMessage()
    vim.cmd("redraw")
    local client = vim.lsp.get_clients({bufnr = 0})[1]
    if client == nil then return '' end

    local progress = client.progress:pop()
    local message
    if progress ~= nil then
        local value = progress.value
        if value == nil then return '' end

        if value.kind == 'end' then
            message = '󰸞 '
        else
            message = value.title .. '(' .. value.percentage .. '%%) '
        end
        vim.b.lsp_message = message
    else
        message = vim.b.lsp_message
        if message == nil then
            return ''
        end
    end
    vim.b.lsp_status = '%#LineMainStatus#' .. message
    return vim.b.lsp_status
end
EOF

"function! GetLSPStatus()
"    return get(b:, 'lsp_status', '')
"endfun

function! GetLeftSep()
    return s:left_sep
endfun

function! GetRightSep()
    return s:right_sep
endfun

function! GetTabSep()
    return s:tab_sep
endfun

function! GetInactiveTabSep()
    return s:inactive_tab_sep
endfun

function! GetInactiveLeftSep()
    return s:inactive_left_sep
endfun

function! GetInactiveRightSep()
    return s:inactive_right_sep
endfun

function! GetWarningText(inactive)
    redrawstatus
    let b:warnings = luaeval('vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })')

    if len(b:warnings)
        let l:first_problem = b:warnings[0]
        let l:separator = (a:inactive ? GetInactiveRightSep() : GetRightSep())
        let l:transition_theme = (a:inactive ? '' : '%#LineWarnTransition#')
        let l:theme = (a:inactive ? '' : '%#LineWarn#')
        let l:text = ' ' . 'W' . len(b:warnings) . '[' . (l:first_problem.lnum + 1) . ']' . ' '
        return l:transition_theme . l:separator . l:theme . l:text
    else
        return ''
    endif
endfun

function! GetErrorText(inactive)
    redrawstatus
    let b:errors = luaeval('vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })')

    if len(b:errors)
        let l:first_problem = b:errors[0]
        let l:separator = (a:inactive ? GetInactiveRightSep() : GetRightSep())
        let l:transition_theme = (a:inactive ? '' : (len(get(b:, 'warnings', '')) ? '%#LineErrTransition#' : '%#LineErrPriTransition#'))
        let l:theme = (a:inactive ? '' : '%#LineErr#')
        let l:text = ' ' . 'W' . len(b:errors) . '[' . (l:first_problem.lnum + 1) . ']' . ' '
        return l:transition_theme . l:separator . l:theme . l:text
    else
        return ''
    endif
endfun

function! GetGitInfo()
    redrawstatus
    let l:branch_name = FugitiveHead()
    if len(l:branch_name) > 0
        let l:branch_name ..= ' '
        if len(FugitiveExecute(['diff', '--name-only', '--staged', expand('%:p')]).stdout) > 1
            let l:icon = '  S '
        elseif len(FugitiveExecute(['status', '--porcelain', expand('%:p')]).stdout) > 1
            let l:icon = '  M '
        elseif !(len(FugitiveExecute(['ls-files', expand('%:p')]).stdout) > 1)
            let l:icon = '  U '
        else
            let l:icon = '  󰘬 '
        endif
    else
        let l:icon = ''
    endif
    let b:git_text = l:icon .. l:branch_name
endfun

function! GetGitText()
    return get(b:, 'git_text', '')
endfun

function! ActivateLine()
    setlocal statusline=
    setlocal statusline+=%#LinePri#\ %{GetLineMode()}\ %#LinePriTransition#%{GetLeftSep()}
    setlocal statusline+=%#LineSec#%{GetGitText()}%#LineSecTransition#%{GetLeftSep()}
    setlocal statusline+=%#LineMain#\ %f%{&modified?'\ ●':''}
    setlocal statusline+=%=%{&filetype}\ %{%v:lua.GetLSPMessage()%}%#LineSecTransition#%{GetRightSep()}
    setlocal statusline+=%#LineSec#\ %{fnamemodify(getcwd(),':~:t')}\ %#LinePriTransition#%{GetRightSep()}
    setlocal statusline+=%#LinePri#\ %p%%[%l/%L](%v)\ "Preserve whitespace
    setlocal statusline+=%{%GetWarningText(0)%}%{%GetErrorText(0)%}
endfun

function! DeactivateLine()
    setlocal statusline=
    setlocal statusline+=%#LinePriInactive#\ INACTIVE\ %{GetInactiveLeftSep()}
    setlocal statusline+=%{GetGitText()}%#LinePriInactiveTransition#%{GetLeftSep()}
    setlocal statusline+=%#LineMain#\ %f%{&modified?'\ ●':''}
    setlocal statusline+=%=%{&filetype}\ %#LinePriInactiveTransition#%{GetRightSep()}
    setlocal statusline+=%#LinePriInactive#\ %{fnamemodify(getcwd(),':~:t')}\ %{GetInactiveRightSep()}
    setlocal statusline+=\ %p%%[%l/%L](%v)\ "Preserve whitespace
    setlocal statusline+=%{%GetWarningText(1)%}%{%GetErrorText(1)%}
endfun

function! GetLineMode()
    let l:curmode = mode()

    if l:curmode ==# 'n'
        let b:curmode = 'NORMAL'
        let l:primarybgcolor = s:blue
    elseif l:curmode ==# 'i'
        let b:curmode = 'INSERT'
        let l:primarybgcolor = s:green
    elseif l:curmode ==# 'v'
        let b:curmode = 'VISUAL'
        let l:primarybgcolor = s:purple
    elseif l:curmode ==# 'V'
        let b:curmode = 'V-LINE'
        let l:primarybgcolor = s:purple
    elseif l:curmode ==# "\<C-V>"
        let b:curmode = 'V-BLOCK'
        let l:primarybgcolor = s:purple
    elseif l:curmode ==# 'c'
        let b:curmode = 'COMMAND'
        let l:primarybgcolor = s:orange
    elseif l:curmode ==# 't'
        let b:curmode = 'TERMINAL'
        let l:primarybgcolor = s:indigo
    else
        let l:primarybgcolor = s:cyan
    endif

    exec 'highlight LinePri guifg=' . s:prifg . ' guibg=' . l:primarybgcolor ' cterm=bold'
    exec 'highlight LinePriTransition guifg=' . l:primarybgcolor . ' guibg=' . s:secbg

    exec 'highlight LineMainStatus guifg=' . l:primarybgcolor . ' guibg=' . s:mainbg

    exec 'highlight LineWarnTransition guifg=' . s:yellow . ' guibg=' . l:primarybgcolor

    exec 'highlight LineErrPriTransition guifg=' . s:red . ' guibg=' . l:primarybgcolor

    exec 'highlight TabLineSecTransition guifg=' . s:tabsecbg . ' guibg=' . l:primarybgcolor

    exec 'highlight TabLinePriSecTransition guifg=' . l:primarybgcolor . ' guibg=' . s:tabsecbg
    exec 'highlight TabLinePriMainTransition guifg=' . l:primarybgcolor . ' guibg=' . s:mainbg

    return b:curmode
endfun

augroup SetLineStatus
    autocmd!
    autocmd BufEnter,WinEnter * call ActivateLine()
    autocmd BufLeave,WinLeave * call DeactivateLine()
    autocmd LspProgress * call v:lua.GetLSPMessage()
augroup END

augroup GetGitStatus
    autocmd!
    autocmd BufReadPost,BufWritePost * call GetGitInfo()
    autocmd User FugitiveChanged call GetGitInfo()
augroup END
