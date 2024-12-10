# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#

CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters
() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'  # Powerline separator
}

# Begin a segment
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"   # Background color
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"    # Foreground color
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Context: user@hostname
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  PL_BRANCH_CHAR=$'\ue0a0'  # 
  local ref dirty mode repo_path

   if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green $CURRENT_FG
    fi
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${mode}"
  fi
}

# Directory: current working directory
prompt_dir() {
  prompt_segment cyan $CURRENT_FG '%~'
}

# Virtualenv: current virtualenv
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment blue black "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}

# Status (error, root, jobs)
prompt_status() {
  local -a symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"        # Red for errors
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"        # Yellow for root user
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"  # Cyan for background jobs
  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"  # Black background for status
}

# AWS Profile
prompt_aws() {
  [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow "AWS: ${AWS_PROFILE:gs/%/%%}" ;;  # Red on yellow for production
    *) prompt_segment green black "AWS: ${AWS_PROFILE:gs/%/%%}" ;;  # Green on black for others
  esac
}

# Kubernetes context
# Kubernetes: display a large Kubernetes symbol (☸) in blue color with cluster and namespace
prompt_k8s() {
  local k8s_cluster
  local k8s_namespace

  # Get the current Kubernetes cluster
  k8s_cluster=$(kubectl config current-context 2>/dev/null)

  # Get the current Kubernetes namespace, if available
  k8s_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

  # If both the cluster and namespace are available, display them
  if [[ -n "$k8s_cluster" ]]; then
    local k8s_display="☸ $k8s_cluster"

    # Append the namespace to the display if available
    if [[ -n "$k8s_namespace" ]]; then
      k8s_display="$k8s_display:$k8s_namespace"
    fi

    # Display the Kubernetes cluster with the namespace
    prompt_segment green orange "${k8s_display:gs/%/%%}"
  fi
}

# Time: current hour and minute
prompt_time() {
  local current_time
  current_time=$(date +"%H:%M")  # Get current time in 24-hour format (HH:MM)

  # Style: white on green for time
  prompt_segment magenta green "$current_time"
}

# Main prompt builder
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_time   # Current time
  prompt_context
  prompt_dir
  prompt_git
  prompt_k8s    # Kubernetes context with cluster and namespace
  prompt_bzr
  prompt_hg
  prompt_end
}

# Final prompt definition
PROMPT='%{%f%b%k%}$(build_prompt) '
# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#

CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters
() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'  # Powerline separator
}

# Begin a segment
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"   # Background color
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"    # Foreground color
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Context: user@hostname
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  PL_BRANCH_CHAR=$'\ue0a0'  # 
  local ref dirty mode repo_path

   if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green $CURRENT_FG
    fi
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${mode}"
  fi
}

# Directory: current working directory
prompt_dir() {
  prompt_segment cyan $CURRENT_FG '%~'
}

# Virtualenv: current virtualenv
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment blue black "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}

# Status (error, root, jobs)
prompt_status() {
  local -a symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"        # Red for errors
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"        # Yellow for root user
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"  # Cyan for background jobs
  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"  # Black background for status
}

# AWS Profile
prompt_aws() {
  [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow "AWS: ${AWS_PROFILE:gs/%/%%}" ;;  # Red on yellow for production
    *) prompt_segment green black "AWS: ${AWS_PROFILE:gs/%/%%}" ;;  # Green on black for others
  esac
}

# Kubernetes context
# Kubernetes: display a large Kubernetes symbol (☸) in blue color with cluster and namespace
prompt_k8s() {
  local k8s_cluster
  local k8s_namespace

  # Get the current Kubernetes cluster
  k8s_cluster=$(kubectl config current-context 2>/dev/null)

  # Get the current Kubernetes namespace, if available
  k8s_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

  # If both the cluster and namespace are available, display them
  if [[ -n "$k8s_cluster" ]]; then
    local k8s_display="⛅️ $k8s_cluster"

    # Append the namespace to the display if available
    if [[ -n "$k8s_namespace" ]]; then
      k8s_display="$k8s_display:$k8s_namespace"
    fi

    # Display the Kubernetes cluster with the namespace
    prompt_segment green orange "${k8s_display:gs/%/%%}"
  fi
}

# Time: current hour and minute
prompt_time() {
  local current_time
  current_time=$(date +"%H:%M")  # Get current time in 24-hour format (HH:MM)

  # Style: white on green for time
  prompt_segment magenta green "$current_time"
}

# Main prompt builder
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_time   # Current time
  prompt_context
  prompt_dir
  prompt_git
  prompt_k8s    # Kubernetes context with cluster and namespace
  prompt_bzr
  prompt_hg
  prompt_end
}

# Final prompt definition
PROMPT='%{%f%b%k%}$(build_prompt) '
