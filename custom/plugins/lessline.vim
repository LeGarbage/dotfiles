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
    local messages = {}
    local clients = vim.lsp.get_clients({bufnr = 0})
    local pending = false
    for _, client in pairs(clients) do
        local progress = client and client.progress and client.progress or nil

        if progress then
            for item in progress do
                local value = item.value

                if value and value.kind ~= "end" then
                    pending = true
                    local message = value.title or ""
                    if value.percentage then
                        message = message .. "(" .. value.percentage .. "%%)"
                    end

                    table.insert(messages, message)
                end
            end
        end
    end

    local result = table.concat(messages, " | ")
    if result == "" then
        if #clients > 0 and not pending then
            result = "󰸞"
        else
            result = vim.b.lsp_message or ""
        end
    else
        vim.b.lsp_message = result
    end

    vim.b.lsp_status = "%#LineMainStatus#" .. result
    return vim.b.lsp_status
end

function GetLSPProgress()
    if vim.b.lsp_status then return vim.b.lsp_status end
    return ""
end

function ReloadGitStatus()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_call(buf, function() vim.cmd("call GetGitInfo()") end)
    end
end
EOF

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
        let l:text = ' ' . 'E' . len(b:errors) . '[' . (l:first_problem.lnum + 1) . ']' . ' '
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
    setlocal statusline+=%#LineMain#\ %<%f%{&modified?'\ ●':''}
    setlocal statusline+=%=\ %{%v:lua.GetLSPProgress()%}\ %#LineMain#%{&filetype}\ %#LineSecTransition#%{GetRightSep()}
    setlocal statusline+=%#LineSec#\ %{fnamemodify(getcwd(),':~:t')}\ %#LinePriTransition#%{GetRightSep()}
    setlocal statusline+=%#LinePri#\ %p%%[%l/%L](%v)\ "Preserve whitespace
    setlocal statusline+=%{%GetWarningText(0)%}%{%GetErrorText(0)%}
endfun

function! DeactivateLine()
    setlocal statusline=
    setlocal statusline+=%#LinePriInactive#\ INACTIVE\ %{GetInactiveLeftSep()}
    setlocal statusline+=%{GetGitText()}%#LinePriInactiveTransition#%{GetLeftSep()}
    setlocal statusline+=%#LineMain#\ %<%f%{&modified?'\ ●':''}
    setlocal statusline+=%=\ %{&filetype}\ %#LinePriInactiveTransition#%{GetRightSep()}
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
    autocmd User FugitiveChanged call v:lua.ReloadGitStatus()
augroup END
