let mapleader=" "

:set guioptions-=T
:set guioptions-=m

" Disable mouse
:set mouse=
if !has('nvim')
    :set ttymouse=
endif

:set ai ts=4 sts=4 et sw=4
" Always cd to the current file's directory
autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /

:set encoding=utf-8

:set scrolloff=4

:set ignorecase
:set smartcase

:set incsearch
:set hidden

" stay on the same column after buffer change
:set nostartofline

" backspace should behave as expected
set backspace=indent,eol,start

" from http://vi.stackexchange.com/a/2770
nnoremap <silent> n n:call HighlightNext(0.1)<cr>
nnoremap <silent> N N:call HighlightNext(0.1)<cr>
nnoremap <silent> * *:call HighlightNext(0.1)<cr>
nnoremap <silent> # #:call HighlightNext(0.1)<cr>

function! HighlightNext (blinktime)
    let target_pat = '\c\%#'.@/
    let ring = matchadd('IncSearch', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

:syntax on

:filetype plugin on

function SmartSplit()
    let l:w = winwidth(0)
    let l:h = winheight(0) * 3
    if (l:h > l:w)
        :split
    else
        :vsplit
    endif
endfunction

:nnoremap <leader>w :write<CR>
:nnoremap <leader>n :call SmartSplit()<cr>
:nnoremap <leader>e :edit<space>
:nnoremap <leader>d :bd<CR>
:nnoremap <leader>q :quit<CR>
:nnoremap <leader>a :CtrlSF<space>

:nnoremap <leader><tab> <C-w><C-w>
:nnoremap <leader>j <C-w>j
:nnoremap <leader>k <C-w>k
:nnoremap <leader>h <C-w>h
:nnoremap <leader>l <C-w>l

:nnoremap <leader>ss :SyntasticToggleMode<cr>
:nnoremap <leader>sn :lnext<cr>
:nnoremap <leader>sp :lprev<cr>

:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>j

set shortmess+=I

:imap jk <Esc>

" colorscheme options

function! TryColorScheme(colorschemes)
    " takes a list of names of color schemes
    " and sets the first existing one

    for c in a:colorschemes
        try
            execute "colorscheme " . c
            return
        catch
            " do nothin, try next in loop
        endtry
    endfor
endfunction

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
let g:solarized_termcolors=256

call TryColorScheme(['PaperColor', 'molokai', 'solarized', 'delek'])

" CtrlP config
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.git|\.hg|\.svn|htmlcov|build|_build|node_modules|bower_components)$',
    \ 'file': '\v\.(so|pyc)$',
    \ }

" CtrlSF config
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_default_root = 'project'

" Syntastic config
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_checkers = []
let g:syntastic_sh_shellcheck_args = "-x"

" respace function sets unix line endings, removes trailing whitespace,
" and converts TABs to spaces
function! ReSpace()
    :retab
    :set ff=unix
    :%s/\s\+$//
endfunction

" the code below is taken from
" https://github.com/scrooloose/vimfiles/blob/master/vimrc
" and modified slightly

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"statusline setup
set statusline=%F    " full path
set statusline+=%*
"
""display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*
"
set statusline+=%h      "help file flag
"set statusline+=%y      "filetype
"
""read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

" modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

" display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

" Syntastic Check
if exists("*SyntasticStatuslineFlag")
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
endif

set statusline+=%=          " left/right separator
set statusline+=%l:%c       " cursor position
set statusline+=\ \|\       " pipe delimeter
set statusline+=%P\/%L    " percent through file

set laststatus=2

" file types
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufNew,BufRead *.md setlocal textwidth=72

autocmd BufNewFile,BufNew,BufRead *.py setlocal softtabstop=4 shiftwidth=4
autocmd BufNewFile,BufNew,BufRead *.js setlocal softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufNew,BufRead *.ts setlocal softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufNew,BufRead *.html setlocal softtabstop=2 shiftwidth=2
