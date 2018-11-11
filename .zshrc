# Enable compsys completion.
autoload -U compinit
autoload -Uz vcs_info
autoload -U colors && colors

export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "sorin-ionescu/prezto"
# Supports oh-my-zsh plugins and the like
zplug "plugins/git",   from:oh-my-zsh

case ${UID} in
0)
    PROMPT="%B%{[31m%}%/#%{[m%}%b "
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%{[31m%}%/%%%{[m%} "
    PROMPT2="%{[31m%}%_%%%{[m%} "
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
esac 

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
# setopt share_history        # share command history data 

# コマンド履歴検索
# Ctrl-P/Ctrl-Nで、入力中の文字から始まるコマンドの履歴が表示される。
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

bindkey -e
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt auto_cd     # ディレクトリ名を入力するだけで移動
setopt auto_pushd  # 移動したディレクトリを記録。"cd -[Tab]"で移動履歴を一覧
setopt correct 
setopt nolistbeep 

#export LSCOLORS=exfxcxdxbxegedabagacad
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=$PATH:/Users/uuushiro/Library/Android/sdk/platform-tools

export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'


alias l="ls -aGl"
alias ls="ls -G"
alias ll="ls -aGl"
alias sl='ls -G -'
alias gls="gls --color"
alias his="history"
alias g='git'
alias ad='git add'
alias rb='git rebase'
alias gg='git grep'
alias st='git status -sb'
alias co='git checkout'
alias com='git checkout master'
alias ci='git commit'
alias gpr='git pull --rebase'
alias push='git push origin HEAD'
alias b='bundle'
alias be='bundle exec'
alias st1='cd ~/git/stmn-study-1th'
alias st2='cd ~/git/stmn-study-2th'
alias st3='cd ~/git/stmn-study-3th'
alias t='cd ~/git/tunag'
alias s='cd ~/git/stats'
alias f='cd ~/git/facelist'
alias ta='cd ~/git/tunag-android'
alias d='cd ~/git/devops'
alias tmux='tmux -2'
alias ctag='brew --prefix ctags'
alias vim_euc="vim -c ':e ++enc=euc-jp'"
alias viM_sjis="vim -c ':e ++enc=cp932'"

# git rebase -i
function grbi() {
  if [ "$1" -gt 0 ]; then
    git rebase -i "HEAD~${1}"
  else
    echo "Using: grbi n\n  (n is number greater then 0)"
  fi
}


export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH

# MYSQL_PS1=$'[\e[36m\\R:\\m:\\s\e[0m] \e[32m\\u@\\h:\\p\e[0m \\d\\nmysql> '; export MYSQL_PS1

# http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/
setopt prompt_subst
setopt transient_rprompt
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# http://d.hatena.ne.jp/sugyan/20100121/1264000100
# http://www.slideshare.net/tetutaro/zsh-20923001
# RPROMPT='%{${fg[green]}%}%/%{$reset_color%}'
common_precmd() {
    LANG=en_US.UTF-8 vcs_info
    local prompt_pwd='%{${fg[green]}%}[%/]%{$reset_color%}'$'\n'
    local prompt_base='%{${fg[red]}%}[%m]${vcs_info_msg_0_} %(!.#.$) %{${reset_color}%}'
    PROMPT="$prompt_pwd$prompt_base"
}
case $TERM in
    screen | xterm-256color)
        preexec() {
            cmd=`echo -ne "$1" | cut -d" " -f 1`
            echo -ne "\ek!$cmd\e\\" 
        }
        precmd() {
            pwd=`pwd`
            if [ $HOME = $pwd ]; then
              echo -ne "\ek~/\e\\"
            else
              echo -ne "\ek$(basename `pwd`)\e\\"
            fi
            #echo -ne "\ek$(basename $SHELL)\e\\"
            common_precmd
        }
        ;;
    *)
        precmd() {
            common_precmd
        }
        ;;
esac

# For Mac OS X Marveric
MYSQL=/usr/local/mysql/bin
export PATH=$PATH:$MYSQL
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# For parallel_tests
export TEST_ENV_NUMBER="4"
#RVM
#export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export EDITOR="vim"
#rbenv
eval "$(rbenv init -)"

NAVEPATH=$HOME/.nave/installed/0.11.7/bin/
export PATH=$NAVEPATH:$PATH
export PATH=$PATH:$HOME/shellscript/

[ -f ~/.naverc ] && . ~/.naverc || true



