#!/usr/bin/env zsh

typeset -A opts
zparseopts -A opts -force=force -- $*

PYTHON3_VERSION=3.8.2
PYTHON2_VERSION=2.7.17
RUBY_VERSION=2.7.0
NODE_VERSION=12.16.2

KOTLIN_LANGUAGE_SERVER_VERSION=0.5.2

# stop on first error
set -o nounset -o pipefail -o errexit

os_name=$(uname -s)

function is_linux() {
  [ "${os_name}" = "Linux" ]
}

function is_osx() {
  [ "${os_name}" = "Darwin" ]
}

function install_pkg() {
  local linux_pkg=$1
  local osx_pkg=${2:-$linux_pkg}

  install_linux_pkg $linux_pkg
  install_osx_pkg $osx_pkg
}

function install_linux_pkg() {
  local pkg=$1
  if is_linux; then
    if [[ pkg == *.git ]]; then
      install_aur_pkg "https://aur.archlinux.org/${pkg}"
    elif [ -z "${force}" ] && is_linux_pkg_installed ${pkg}; then
      echo "${pkg} is already installed, skipping..."
    else
      sudo pacman -S --quiet --noconfirm --noprogressbar ${pkg}
    fi
  fi
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

function install_osx_pkg() {
  local pkg=$1
  if is_osx; then
    if is_osx_pkg_installed ${pkg}; then
      echo "${pkg} is already installed, skipping..."
    else
      brew install "${pkg}" "${@:2}"
    fi
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

function is_osx_pkg_installed() {
  local pkg=$1
  brew list "${pkg}" >/dev/null 2>&1
  [ "$?" -eq 0 ]
}

if is_osx; then
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

function download_zip_extract() {
  local url=$1
  local dir=$2

  if [ ! -d "${dir}" ]; then
    local parent_dir=$(dirname "${dir}")
    local base_dir=$(basename "${dir}")
    local tmpzip="${base_dir}.zip"
    mkdir -p "${parent_dir}"
    echo "Downloading ${url} to ${parent_dir}/${tmpzip}"
    (cd "${parent_dir}" && curl -L -o "${tmpzip}" "${url}")
    echo "Unzipping ${tmpzip} to ${dir}"
    (cd "${parent_dir}" && unzip "${tmpzip}" -d "${base_dir}" && rm -f "${tmpzip}")
  fi
}

###############################################################
# system/dev tools
###############################################################

install_osx_pkg coreutils
install_pkg ack
install_pkg ag
install_pkg rg
install_pkg fzf
install_pkg jq
install_pkg fasd
install_pkg z
install_pkg source-highlight
install_pkg colordiff

install_linux_pkg openssh
install_pkg gnupg
install_osx_pkg pinentry-mac

install_pkg go
install_pkg rustup rust
install_pkg pyenv
install_pkg rbenv.git rbenv
install_pkg ruby-build.git ruby-build
install_pkg nodenv.git nodenv

install_pkg gradle
install_osx_pkg gradle-completion

pyenv install -s "${PYTHON3_VERSION}"
pyenv install -s "${PYTHON3_VERSION}"
pyenv global "${PYTHON3_VERSION}" "${PYTHON2_VERSION}"
eval "$(pyenv init -)"
pip install --quiet pipx
pip install --quiet neovim
PYENV_VERSION=${PYTHON2_VERSION} pip install --quiet neovim

rbenv install -s "${RUBY_VERSION}"
rbenv global "${RUBY_VERSION}"
eval "$(rbenv init -)"
gem install --silent neovim

nodenv install -s "${NODE_VERSION}"
nodenv global "${NODE_VERSION}"
eval "$(nodenv init -)"
npm install -g --silent yarn
yarn global --silent add neovim

install_pkg aws-cli awscli
install_osx_pkg aws/tap/aws-sam-cli

###############################################################
# language servers, linters, formatters, fixers
###############################################################

install_pkg golangci-lint golangci/tap/golangci-lint
install_pkg prettier
install_pkg yamllint
install_pkg shfmt
install_pkg autopep8
install_pkg flake8
install_pkg mypy
pipx install isort
pipx install pylint
install_pkg eslint
install_pkg shellcheck
install_pkg pandoc

download_zip_extract "https://github.com/fwcd/kotlin-language-server/releases/download/${KOTLIN_LANGUAGE_SERVER_VERSION}/server.zip" ~/.local/share/kotlin-language-server

###############################################################
# zsh
###############################################################

zshrc="${HOME}/.zshrc"
zplugdir="${HOME}/.zplug"

if [ ! -d "${zplugdir}" ]; then
  git clone https://github.com/zplug/zplug "${zplugdir}"
fi

# for zsh-system-clipboard
install_linux_pkg xsel

# open shell so antigen installs plugins
/usr/bin/env zsh -c "source ${zshrc}; exit"

###############################################################
# tmux
###############################################################

install_osx_pkg reattach-to-user-namespace
pip install powerline-status
install_linux_pkg powerline-fonts
install_pkg tmux
tmux -c "powerline-config tmux setup"

###############################################################
# vim
###############################################################

vimdir="${HOME}/.vim"

install_pkg neovim

# vim-plug
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install all vim plugins and quit
nvim +PlugInstall +qall

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
  install_pkg polybar.git
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
unfunction install_aur_pkg
unfunction install_osx_pkg
unfunction git_clone_or_update
unfunction is_linux_pkg_installed
unfunction is_osx_pkg_installed
unfunction download_zip_extract
