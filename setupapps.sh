#==================
# Install Homebrew
#==================
which -s brew
if [[ $? != 0 ]] ; then
    echo "Install Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
    brew update
fi

echo "Install Homebrew extension Caske"
brew install caskroom/cask/brew-cask

COMMON_APPS="ack autojump automake colordiff curl git git-flow hub icoutils imagemagick libmemcached memcached openssl ossp-uuid qt readline redis tmux wget"
echo "Install common applications via Homebrew --> $COMMON_APPS"
brew install $COMMON_APPS

# The below command will install the application present in the Brewfile
brew bundle install

#============================
# Post Install Postgres Steps
#============================
# Start Automatically on System Starup
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

# Optional: Install AdminPack for PgAdmin
psql postgres -c 'CREATE EXTENSION "adminpack";'

#================================
# Installing Prezto - ZSH
#================================
zsh
git clone --recursive https://github.com/kishorevaishnav/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

#=============================
# Copy the .zshrc
#=============================
cp .zshrc ~/.zshrc
cp .zpreztorc ~/.zpreztorc
