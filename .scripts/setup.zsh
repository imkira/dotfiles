#!/bin/env zsh

typeset -A opts
zparseopts -A opts -force=force -- $*

# stop on first error
set -e

os_name=$(uname -s)

function is_linux() {
  [ "${os_name}" = "Linux" ]
}

function is_osx() {
  [ "${os_name}" = "Darwin" ]
}

function install_pkg() {
  local linux_pkg=$1
  local osx_pkg=${2:-$linux}

  install_linux_pkg $linux_pkg
  install_osx_pkg $osx_pkg
}

function install_linux_pkg() {
  local pkg=$1
  if is_linux; then
    if [ -z "${force}" ] && is_linux_pkg_installed ${pkg}; then
      echo "${pkg} is already installed, skipping..."
    else
      sudo pacman -S --quiet --noconfirm --noprogressbar ${pkg}
    fi
  fi
}

function install_osx_pkg() {
  if is_osx; then
    brew install $1
  fi
}

function git_clone_or_update() {
  local repo=$1
  local dir=$2

  if [ ! -d "${dir}/.git" ]; then
    git clone "${repo}" "${dir}"
  else
    (cd "${dir}" && git pull)
  fi
}

function is_linux_pkg_installed() {
  local pkg=$1
  local installed=$(pacman -Qq "${pkg}" 2>/dev/null || true)
  [ ! -z "${installed}" ]
}

function install_aur_pkg() {
  local repo=$1
  local pkg=$(basename $repo .git)
  if [ -z "${force}" ] && is_linux_pkg_installed ${pkg}; then
    echo "${pkg} is already installed, skipping..."
  else
    local dir=~/.tmp/${pkg}
    if is_linux; then
      git_clone_or_update "${repo}" "${dir}"
      (cd "${dir}" && MAKEFLAGS="-j4" makepkg -siCc --noconfirm && cd - && rm -rf "${dir}")
    fi
  fi
}

###############################################################
# system/dev tools
###############################################################

install_pkg ack
install_pkg jq
install_pkg fasd
install_pkg z
install_linux_pkg source-highlight
install_linux_pkg openssh

install_pkg go
install_pkg rustup rust
if is_linux; then
  install_aur_pkg "https://aur.archlinux.org/rbenv.git"
  install_aur_pkg "https://aur.archlinux.org/ruby-build.git"
elif is_osx; then
  install_pkg rbenv
fi
install_pkg gradle

###############################################################
# zsh
###############################################################

zshdir="${HOME}/.zsh"
zshrc="${HOME}/.zshrc"

#curl -L https://git.io/antigen > "${zshdir}/antigen.zsh"

# for zsh-system-clipboard
install_linux_pkg xsel

# open shell so antigen installs plugins
/bin/env zsh -c "source ${zshrc}; exit"

###############################################################
# tmux
###############################################################

install_linux_pkg powerline
install_linux_pkg powerline-fonts
install_pkg tmux

###############################################################
# vim
###############################################################

vimdir="${HOME}/.vim"

# for GUI support
install_pkg gvim macvim

# universal-ctags
if is_linux; then
  install_aur_pkg "https://aur.archlinux.org/universal-ctags-git.git"
elif is_osx; then
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags
fi

#curl -fLo "${vimdir}/autoload/plug.vim" --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install all vim plugins and quit
vim +PlugInstall +qall

# YCM
install_pkg clang
install_pkg make cmake
if [ ! -f "${vimdir}/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
  "${vimdir}/plugged/YouCompleteMe/install.py" --clang-completer --go-completer --rust-completer --java-completer
fi

###############################################################
# fonts
###############################################################

if is_linux; then
  install_pkg terminus-font
  install_pkg ttf-font-awesome
  install_pkg ttf-dejavu
  install_pkg ttf-hack
  install_pkg otf-ipafont
  install_pkg wqy-microhei
fi

###############################################################
# X11
###############################################################

if is_linux; then
  install_pkg xdg-utils
fi

###############################################################
# i3-wmhttps://aur.archlinux.org/siji-git.git
###############################################################

if is_linux; then
  install_pkg i3-gaps
  install_pkg rofi
  install_pkg compton
  install_pkg feh

  install_aur_pkg "https://aur.archlinux.org/polybar.git"
fi

###############################################################
# alacritty
###############################################################

if is_linux; then
  install_pkg "alacritty"
fi

if is_osx; then
  brew cask install alacritty
fi

###############################################################
# cleanup
###############################################################

unfunction is_linux
unfunction is_osx
unfunction install_pkg
unfunction install_linux_pkg
unfunction install_osx_pkg
unfunction git_clone_or_update
