#!/bin/bash

# Two line prompt showing the following information:
# (time) SCM [username@hostname] pwd (SCM branch SCM status) 
# → 
#
# Example:
# (14:00:26) ± [foo@bar] ~/.bash_it (master ✓) 
# → 
#
# The arrow on the second line is showing the exit status of the last command:
# * Green: 0 exit status
# * Red: non-zero exit status
#
# The exit code functionality currently doesn't work if you are using the 'fasd' plugin,
# since 'fasd' is messing with the $PROMPT_COMMAND


PROMPT_END_CLEAN="${green}>${reset_color}"
PROMPT_END_DIRTY="${red}!${reset_color}"

function prompt_end() {
  echo -e "$PROMPT_END"
}

function get_virtual_env() {
  echo ${VIRTUAL_ENV:-${CONDA_DEFAULT_ENV:-'default'}}
}

git_prompt_status() {
  local git_status_output
  git_status_output=$(git status 2> /dev/null )
  if [ -n "$(echo $git_status_output | grep 'Changes not staged')" ]; then
    git_status="${bold_red}$(scm_prompt_info) ✗"
  elif [ -n "$(echo $git_status_output | grep 'Changes to be committed')" ]; then
     git_status="${bold_yellow}$(scm_prompt_info) ^"
  elif [ -n "$(echo $git_status_output | grep 'Untracked files')" ]; then
     git_status="${bold_cyan}$(scm_prompt_info) +"
  elif [ -n "$(echo $git_status_output | grep 'nothing to commit')" ]; then
     git_status="${bold_green}$(scm_prompt_info) ${green}✓"
  else
    git_status="$(scm_prompt_info)"
  fi
  echo "[$git_status${normal}]"

}

prompt_setter() {
  local exit_status=$?
  if [[ $exit_status == 0 ]]; then PROMPT_END=$PROMPT_END_CLEAN
    else PROMPT_END=$PROMPT_END_DIRTY
  fi
  # Save history
  history -a
  history -c
  history -r
  PS1="\n(\t) $(scm_char) ${yellow}($(get_virtual_env))${reset_color} [\u@\H] ${yellow}\w${reset_color}\n\# $(scm_prompt_info) ${reset_color} $(prompt_end) "
  PS2='> '
  PS4='+ '
}

PROMPT_COMMAND=prompt_setter

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_THEME_PROMPT_PREFIX=" ["
SCM_THEME_PROMPT_SUFFIX="]"
RVM_THEME_PROMPT_PREFIX=" ["
RVM_THEME_PROMPT_SUFFIX="]"
