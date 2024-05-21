function zle_redraw_prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
  zle execute-named-cmd accept-line
}

function zsh_fs_navigation_up() {
  cd .. || return 1
}

function zsh_fs_navigation_down() {
  while true; do
    local lsd=$(ls -pA | grep '/$' | sed 's;/$;;')
    local dir="$(printf '%s\n' "${lsd[@]}" |
    sk --bind 'left:execute(echo ..)+abort,right:accept,enter:accept,tab:abort' --height 90 --reverse -0 --preview '
      __cd_nxt="$(echo {})";
      __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
      echo $__cd_path;
      echo;
      ls -p --color=always "${__cd_path}";
    ')"
    [[ ${#dir} != 0 ]] || return 0
    cd "$dir" &> /dev/null
  done
}

function zsh_fs_navigation_right() {
  dirs=("${(@f)$(ls -pA .. | grep '/$' | sed 's;/$;;' | sort)}")
  for ((i = 1; i <= $#dirs; i++)) do
    if [[ "${dirs[$i]}" = "${PWD##*/}" ]]; then
      if [ $#dirs = $i ] ; then
          cd ../${dirs[1]} || return 1
        else
          cd ../${dirs[$i+1]} || return 1
      fi
      return 0
    fi
  done
}

function zsh_fs_navigation_left() {
  dirs=("${(@f)$(ls -pA .. | grep '/$' | sed 's;/$;;' | sort)}")
  for ((i = 1; i <= $#dirs; i++)) do
    if [[ "${dirs[$i]}" = "${PWD##*/}" ]]; then
      if [[ ( 1 = $i ) ]] ; then
        cd ../${dirs[$#dirs]} || return 1
      else
        cd ../${dirs[$i-1]} || return 1
      fi
      return 0
    fi
  done
}

# Bind keys to hierarchy navigation
function zle_fs_navigation_up() {
  zle .kill-buffer   # Erase current line in buffer
  zsh_fs_navigation_up
  zle_redraw_prompt
}

function zle_fs_navigation_down() {
  zle .kill-buffer
  zsh_fs_navigation_down
  zle_redraw_prompt
}

function zle_fs_navigation_left() {
  zle .kill-buffer
  zsh_fs_navigation_left
  zle_redraw_prompt
}

function zle_fs_navigation_right() {
  zle .kill-buffer
  zsh_fs_navigation_right
  zle_redraw_prompt
}

zle -N zle_fs_navigation_up
zle -N zle_fs_navigation_down
zle -N zle_fs_navigation_left
zle -N zle_fs_navigation_right

for keymap in emacs vicmd viins; do
  bindkey -M $keymap "\e[1;3A" zle_fs_navigation_up
  bindkey -M $keymap "\e[1;3C" zle_fs_navigation_right
  bindkey -M $keymap "\e[1;3D" zle_fs_navigation_left
  bindkey -M $keymap "\e[1;3B" zle_fs_navigation_down
done

unset keymap
