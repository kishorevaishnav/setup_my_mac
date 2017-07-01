#=========================
# Installing Prezto - ZSH
#=========================
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

cd /tmp
wget https://github.com/chauncey-garrett/zsh-prompt-garrett/archive/v1.0.zip
unzip v1.0.zip
cp zsh-prompt-garrett-1.0/prompt_garrett_setup  "${ZDOTDIR:-$HOME}"/.zprezto/modules/prompt/functions/.
rm -rf v1.0.zip zsh-prompt-garrett-1.0

cd -
cp "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc_backup
cp .zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc

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
brew install ack autojump automake colordiff curl git git-flow hub icoutils imagemagick libmemcached memcached openssl ossp-uuid qt readline redis tmux wget

# The below command will install the application present in the Brewfile
brew bundle install
#=============================

# Post Install Postgres Steps
#=============================
# Start Automatically on System Starup
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

# Optional: Install AdminPack for PgAdmin
for db in $(psql -d postgres -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | sed '1,2d' | head -n 1 | grep -v '^ postgres$'); do
  echo "Adding adminpack to ${db}"
  psql -c "CREATE EXTENSION adminpack;" ${db};
done
