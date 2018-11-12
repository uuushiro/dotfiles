set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis
set clipboard+=unnamed
set number
set wildmenu
set expandtab
set tabstop=2
set shiftwidth=2
set autoread
set hidden
set showcmd

" ----------------------------------------------------------------------------
"  " ALE
"  "
"  ----------------------------------------------------------------------------
let g:ale_fixers = {'ruby': ['rubocop']}

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200

" ----------------------------------------------------------------------------
"  " キーマッピング
"  "
"  ----------------------------------------------------------------------------
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir --buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

"Required:
set runtimepath+=/Users/uuushiro/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/uuushiro/.cache/dein')
  call dein#begin('/Users/uuushiro/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/uuushiro/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  call dein#add('tpope/vim-rails')
  call dein#add('basyura/unite-rails')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('Shougo/unite.vim')
  call dein#add('w0rp/ale')
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/neoyank.vim')
  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
