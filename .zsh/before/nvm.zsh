export NODE_PATH=/usr/local/lib/node_modules
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
export PATH=./node_modules/.bin:/usr/local/share/npm/bin:$PATH

export NVM_DIR=$HOME/.nvm
[[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
