set -gx HOMEBREW_PREFIX "/opt/homebrew";
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
set -q PATH; or set PATH ""; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
set -q MANPATH; or set MANPATH ""; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ""; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;

set PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)


# k8sのpluginマネージャー k8s版のbrewみたいなもん
# set -gx PATH $PATH $HOME/.krew/bin

# lsの色見辛すぎるので、シアンに変更
set -gx EZA_COLORS "di=1;36";

alias gs='git status'
alias gp='git push'
alias gco='git commit'
alias gch='git checkout'
alias ga='git add'
alias gr='git reset'
alias gl='git log'
alias gd='git diff .'
alias gb='git branch'
alias c='clear'
alias d='docker'

alias ls='eza'
alias cat='bat'
alias ps='procs'
alias grep='rg -n'
alias find='fd'
alias lg='lazygit'

function peco_select_history_order
  if test (count $argv) = 0
    set peco_flags --layout=top-down
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history|peco $peco_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end

function peco_select_ghq_repository
  set -l query (commandline)

  if test -n $query
    set peco_flags --query "$query"
  end

  find $(ghq root)/github.com/*/* -type d -prune |sed -e 's#'$(ghq root)'/##'|peco $peco_flags|read line

  if [ $line ]
    cd $(ghq root)/$line
    commandline -f repaint
  end
end



function fish_user_key_bindings
  bind /cr 'peco_select_history_order' # Ctrl + R
  bind /cg 'peco_select_ghq_repository' # Ctrl + G
end

set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

# rbenv
set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# direnvの設定
set -x EDITOR vim
eval (direnv hook fish)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/s_taro/google-cloud-sdk/path.fish.inc' ]; . '/Users/s_taro/google-cloud-sdk/path.fish.inc'; end

