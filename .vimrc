set t_Co=256
" Disable vi compatibility
"set nocompatible

filetype on
filetype plugin indent on

" Preferences
" -----------------------------------------------------------------------------
set modelines=0
set encoding=utf-8
set smartindent
set shortmess=a
set cmdheight=2
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set noerrorbells
set novisualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set number
set title
set laststatus=2
set splitbelow splitright
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
set nowrap
set list
set listchars=tab:▸\ ,eol:¬,trail:·
"set foldlevelstart=0
"set foldmethod=indent
"Switch off folding
set nofoldenable
set formatoptions=tcq
set autowrite

if has("mouse")
 set mouse=a
endif

" Backups
set history=1000
set undolevels=1000
set nobackup
set directory=~/tmp/

" Searching
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
set grepprg=ack
runtime macros/matchit.vim

command! -nargs=* Wrap set wrap linebreak nolist


" Tell snipmate to pull it's snippets from a custom directory
let g:snippets_dir = $HOME.'/.vim/snippets/'

" File handling and settings
" -----------------------------------------------------------------------------

if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  " Reload .vimrc after it or vimrc.local been saved
  au! BufWritePost .vimrc source %
  au! BufWritePost .vimrc.local source ~/.vimrc

  " File type settings on load
  au GUIEnter * simalt ~x "x on an English Windows version. n on a French one
  au BufRead,BufNewFile *.scss set filetype=scss
  au BufRead,BufNewFile *.m*down set filetype=markdown
  au BufRead,BufNewFile *.as set filetype=actionscript
  au BufRead,BufNewFile *.json set filetype=json
  au BufRead,BufNewFile *.styl set filetype=stylus
  au BufRead,BufNewFile *.stylus set filetype=stylus

  " Call the file type utility methods
  au BufRead,BufNewFile *.txt
  au BufRead,BufNewFile *.md,*.markdown,*.mkd
  au BufRead,BufNewFile *.css,*.scss 
  au BufRead,BufNewFile *.html,*.js,*.haml,*.erb 
  au User Rails 

  " Reload all snippets when creating new ones.
  au! BufWritePost *.snippets

  " Enable autosave
  au FocusLost * :wa

  " Enable omnicomplete for supported filetypes
  autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif

endif

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>

function! SetCurrentDirectoryToPath()
  exec "set path=".escape(escape(expand("%:p:h"), ' '), '\ ')."/**"
endfunction

map <F4> call SetCurrentDirectoryToPath()
autocmd VimEnter * call SetCurrentDirectoryToPath()

" Themes and GUI settings
" -----------------------------------------------------------------------------
syntax on

" Set the title bar to something meaningful
if has('title') && (has('gui_running') || &title)
  set titlestring=
  set titlestring+=%f\                                             " file name
  set titlestring+=%h%m%r%w                                        " flags
  set titlestring+=\ -\ %{v:progname}                              " program name
  set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')} " working directory
endif

" Load up the user's local .vimrc config
" -----------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
