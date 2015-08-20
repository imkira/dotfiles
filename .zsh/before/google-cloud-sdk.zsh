local dir=/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
if [[ -s ${dir} ]]; then
  source "${dir}/path.zsh.inc"
  source "${dir}/completion.zsh.inc"
fi
