" setting
" 文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" 編集中のファイルが変更されたら自動で保存
set autowrite
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" カラーテーマ
autocmd ColorScheme * highlight LineNr ctermbg=none
colorscheme hybrid
syntax enable

" 背景色
set background=dark

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4

" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch

" ショートカット
abbr _sh #!/bin/bash

" ESC連打でハイライト解除
" nmap <Esc><Esc> :nohlsearch<CR><Esc>
" <leader>をSpaceキーに設定
let mapleader = " "

" vim-jetpackが入ってなかったらインストール
let s:jetpackfile = expand('<sfile>:p:h') .. '/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

"" プラグイン一覧
packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
" denops系
Jetpack 'vim-denops/denops.vim'
" LSP
Jetpack 'prabirshrestha/vim-lsp' " vimにlspを適用するためのプラグイン
Jetpack 'mattn/vim-lsp-settings' " vim-lspのセッティング ローカルにlspServerをインストールするっぽい
" 補完系
Jetpack 'Shougo/ddc.vim'
Jetpack 'Shougo/ddc-ui-native'
Jetpack 'shun/ddc-vim-lsp' " ddcにsourceとしてvim-lspを登録するためのプラグイン
Jetpack 'tani/ddc-fuzzy'
" Goのフォーマッタ
Jetpack 'darrikonn/vim-gofmt'
" ファイル、エラー、Gitのコミットなどをあいまい検索
Jetpack 'nvim-lua/plenary.nvim'
Jetpack 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
" ファイルツリー
Jetpack 'lambdalisue/fern.vim'
" vim上でターミナル開く
Jetpack 'akinsho/toggleterm.nvim'

call jetpack#end()

" 入ってないプラグインがあればインストール
for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    break
  endif
endfor

" denopsプラグインの開発に使う
" set runtimepath^=~/MyPj/Denops/dps-helloworld
" let g:denops#debug = 1 " denopsプラグインのデバッグログをオン
" let g:markdown_fenced_languages = ['ts=typescript']

" カーソル上にあるコードのLSPメッセージを表示
" let g:lsp_diagnostics_echo_cursor = 1

" ddcにvim-lsp登録
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['vim-lsp'])
call ddc#custom#patch_global('sourceOptions', {
  \   'vim-lsp': {
  \     'matchers': ['matcher_fuzzy'],
  \     'sorters': ['sorter_fuzzy'],
  \     'converters': ['converter_fuzzy']
  \   }
  \ })
" Use ddc.
call ddc#enable()

" Use toggleterm
lua require("toggleterm").setup()

" キーマップ
nnoremap gd :LspDefinition<CR>
nnoremap f :LspHover<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Fernでファイルツリーオープン
nnoremap <leader>ft <cmd>Fern . -reveal=%<cr>

" ToggleTerminalでターミナルオープン
nnoremap <leader>t <cmd>ToggleTerm direction=float<cr>
nnoremap <leader>vt <cmd>ToggleTerm direction=vertical size=100<cr>

" ファイル保存時にフォーマットかける
autocmd BufWritePre <buffer> LspDocumentFormatSync

" Rustの関数を出力する関数
function! InsertRustFunctionTemplate()
  let cursor_line = line('.')
  let template = [
  \   'pub fn function_name() -> ReturnType {',
  \   '    // TODO: Implement the function',
  \   '}',
  \ ]

  for line in template
    call append(cursor_line, line)
    let cursor_line += 1
  endfor

  " カーソルを function_name の位置に移動
  let function_name_line = cursor_line - len(template) + 1
  let function_name_column = len(matchstr(template[0], 'pub fn ')) + 1
  call cursor(function_name_line, function_name_column)
endfunction

lua << EOF
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true})
function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
EOF


