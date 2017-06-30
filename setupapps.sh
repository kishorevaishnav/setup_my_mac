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
