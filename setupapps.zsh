#=========================
# Installing Prezto - ZSH
#=========================
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ] ; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  chsh -s /bin/zsh

  # getting the best prezto theme
  cd /tmp
  wget https://github.com/chauncey-garrett/zsh-prompt-garrett/archive/v1.0.zip
  unzip v1.0.zip
  cp zsh-prompt-garrett-1.0/prompt_garrett_setup  "${ZDOTDIR:-$HOME}"/.zprezto/modules/prompt/functions/.
  rm -rf v1.0.zip zsh-prompt-garrett-1.0

  # setting the best prezto theme
  cd -
  mv "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc_backup
  ln -s "`pwd`"/.zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc
fi

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

which -s brew
if [[ $? == 0 ]] ; then
  echo "Install Homebrew extension Caske"
  brew install caskroom/cask/brew-cask

  COMMON_APPS="ack autojump automake colordiff curl git git-flow hub icoutils imagemagick libmemcached memcached openssl ossp-uuid qt readline redis tmux wget"
  echo "Install common applications via Homebrew --> $COMMON_APPS"
  brew install ack autojump automake colordiff curl git git-flow hub icoutils imagemagick libmemcached memcached openssl ossp-uuid qt readline redis tmux wget

  # The below command will install the application present in the Brewfile
  brew bundle install
fi

#=============================
# Post Install Postgres Steps
#=============================
# Start Automatically on System Starup
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
createuser postgres -s -d -i -r

# Optional: Install AdminPack for PgAdmin
for db in $(psql -d postgres -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | sed '1,2d' | head -n 1 | grep -v '^ postgres$'); do
  echo "Adding adminpack to ${db}"
  psql -c "CREATE EXTENSION adminpack;" ${db};
done

#=======================
# Set git config values
#=======================
git config --global user.name "Kishore Kumar"
git config --global user.email "kishorevaishnav@gmail.com"
git config --global github.user kishorevaishnav
git config --global core.editor "subl -w"
git config --global color.ui true

#==============
# Update Heroku
#==============
heroku update

#===========================
# Post Install Docker Steps
#===========================
docker-machine create --driver virtualbox default
docker-machine ls
eval $(docker-machine env default)


# Installing the Package Manager for Sublime
import urllib2,os; pf='Package Control.sublime-package'; ipp=sublime.installed_packages_path(); os.makedirs(ipp) if not os.path.exists(ipp) else None; urllib2.install_opener(urllib2.build_opener(urllib2.ProxyHandler())); open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read()); print 'Please restart Sublime Text to finish installation'
#
# --> parse error near `()' --> from the above command

zsh visual_studio_code/install_extensions.zsh

mkdir -p ~/.vscode
cp visual_studio_code/launch.json ~/.vscode/.
cp visual_studio_code/settings.json ~/.vscode/.
cp visual_studio_code/tasks.json ~/.vscode/.
