# http://news.mynavi.jp/column/zsh/002/
#
# set prompt
#

case ${UID} in
0)
    PROMPT="%B%{[31m%}#%{[m%}%b "
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    RPROMPT="[%~]"
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%{[31m%}%%%{[m%} "
    PROMPT2="%{[31m%}%_%%%{[m%} "
    RPROMPT="[%~]"
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# 日本語の設定
export LANG=ja_JP.UTF-8

# ヒストリの設定
# http://qiita.com/syui/items/c1a1567b2b76051f50c4

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=10000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# http://news.mynavi.jp/column/zsh/005/
# 間違ったコマンドを補完
setopt correct

# lsの候補を詰めて表示
setopt list_packed

# Beep音を無効化
setopt nolistbeep

# http://news.mynavi.jp/column/zsh/006/
# 先方予測機能
# autoload predict-on; predict-on

# エイリアス
alias ls="ls -F --color=auto"
alias vim="env TERM=xterm-256color vim"

# リダイレクトのマルチ化
# http://news.mynavi.jp/column/zsh/007/
setopt multios

# 設定はここを参考にした
# http://qiita.com/uasi/items/c4288dd835a65eb9d70

# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -v

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# ↑を設定すると、 .. とだけ入力したら1つ上のディレクトリに移動できるので……
# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# "~hoge" が特定のパス名に展開されるようにする（ブックマークのようなもの）
# 例： cd ~hoge と入力すると /long/path/to/hogehoge ディレクトリに移動
# hash -d hoge=/long/path/to/hogehoge

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
# glob とはパス名にマッチするワイルドカードパターンのこと
# （たとえば `mv hoge.* ~/dir` における "*"）
# 拡張 glob を有効にすると # ~ ^ もパターンとして扱われる
# どういう意味を持つかは `man zshexpn` の FILENAME GENERATION を参照
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


## このサイトを参考にした
# http://qiita.com/KENJU/items/828f5319ca29b9928f70

# 色を使う
setopt prompt_subst

# mintty+percol用設定
export TERM=xterm

# 外部ファイルの読み込み設定
# http://news.mynavi.jp/column/zsh/006/
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

# https://gist.github.com/mollifier/4979906
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# シェルの履歴検索
# https://gist.github.com/mitukiii/4234173
function percol-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | \
    eval $tac | \
    percol --match-method migemo --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N percol-select-history
bindkey '^r' percol-select-history

# ドキュメントファイルをインクリメンタルサーチ
# http://d.hatena.ne.jp/kbkbkbkb1/20120429
function search-document-by-percol(){
  if [ $# -ge 1 ]; then
    DOCUMENT_DIR=$*
  else
    DOCUMENT_DIR="\
$HOME/Dropbox/
$HOME/Documents/"
  fi
  SELECTED_FILE=$(echo $DOCUMENT_DIR | xargs find | \
    grep -E "\.*(pdf|txt|md|markdown|odp|odt|ods|pptx?|docx?|xlsx?|log)$" | percol --match-method migemo)
  if [ $? -eq 0 ]; then
    start $SELECTED_FILE
  fi
}
alias sd='search-document-by-percol'

# カレントディレクトリ配下をインクリメンタルサーチしてプロンプトに追加
function insert-file-by-percol(){
  LBUFFER=$LBUFFER$( find . | percol --match-method migemo | tr '\n' ' ' | \
    sed 's/[[:space:]]*$//') # delete trailing space
  zle -R -c
}
zle -N insert-file-by-percol
bindkey 'c' insert-file-by-percol

# カレントディレクトリのファイルを複数選択して渡す
function multiple-select-by-percol(){
  LBUFFER=$LBUFFER$( ls . | percol | tr '\n' ' ' | \
    sed 's/[[:space:]]*$//') # delete trailing space
  zle -R -c
}
zle -N multiple-select-by-percol
bindkey 'm' multiple-select-by-percol

# zmvの設定
# http://mollifier.hatenablog.com/entry/20101227/
autoload -Uz zmv
alias zmv='noglob zmv -W'

# enhancdの設定
# http://github.com/b4b4r07/enhancd.git
if [ -f ~/enhancd/enhancd.sh ]; then
  source ~/enhancd/enhancd.sh
fi

# rmで削除するときにワンクッション置く
# http://keisanbutsuriya.hateblo.jp/entry/2015/03/21/171333
function trash-it(){
  TRASHDIR="${HOME}/.Trash"
  if [ ! -d $TRASHDIR ]; then
    mkdir $TRASHDIR
  fi
  mv --backup=numbered --target-directory=$TRASHDIR $@
  du -h $TRASHDIR
}
alias rm='trash-it'

function trash-clear(){
  TRASHDIR="${HOME}/.Trash"
  if [ -d $TRASHDIR ]; then
    \rm -rf ${TRASHDIR}
  else
    echo 'No trash.'
  fi
}
