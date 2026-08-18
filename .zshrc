### Zinit bootstrap
# Must run BEFORE the p10k instant-prompt block, since a first-run install
# prints output / clones a repo, and instant-prompt requires that any such
# console output happens earlier than this.
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### PATH — typeset -U keeps it deduped automatically
typeset -U path PATH
path=("$HOME/.local/bin" $path)

### Aliases
alias v=nvim

### Plugins — grouped onto the same turbo tick (wait'0') so they fire
# together in one event-loop pass instead of several staggered forks
zinit ice wait'0' lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# zsh-completions must load before compinit runs (blockf keeps fpath clean)
zinit ice wait'0' lucid blockf atpull"zinit creinstall -q ."
zinit light zsh-users/zsh-completions

# fast-syntax-highlighting triggers compinit itself via atinit, in the
# correct order relative to the turbo-deferred completions above.
# -C skips compinit's per-startup security audit; run `compinit` (no -C)
# manually once after adding new completions so it can re-verify.
zinit ice wait'0' lucid atinit"zicompinit -C; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Powerlevel10k — loaded synchronously (NOT turbo), since the prompt
# needs to be ready immediately, not deferred.
zinit ice depth=1
zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Zoxide — replaces `cd` natively instead of a manual alias,
# so it can't leave `cd` broken if zoxide fails to init.
eval "$(zoxide init zsh --cmd cd)"

### Compile config to bytecode for faster parsing on next launch.
# Regenerates automatically whenever this file is newer than the .zwc.
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi
if [[ -f ~/.p10k.zsh && ( ! -f ~/.p10k.zsh.zwc || ~/.p10k.zsh -nt ~/.p10k.zsh.zwc ) ]]; then
  zcompile ~/.p10k.zsh
fi
