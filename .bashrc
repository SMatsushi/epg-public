alias nemacs="emacs -nw"
alias pu=pushd
alias po=popd
alias ph='pushd ~'
# alias ls='ls -F'
alias vi=vim
alias ls='ls -F --color=auto'
alias h=history
alias j=jobs
alias more=less
alias ddiff='diff -l -r '
alias sob='source ~/.bashrc'
alias quicktime='/Applications/QuickTime\ Player.app/Contents/MacOS/QuickTime\ Player'
#alias '-'='%-'
#alias '+'='%+'
alias sshushome='ssh -p 12122 -Y iphonedays.miniDNS.net'
alias sshvushome='ssh -v -p 12122 -Y iphonedays.miniDNS.net'
alias sftpushome='sftp -P 12122 iphonedays.miniDNS.net'

# wrong space corrupts it...
# alias linkpub='echo ln $1 ~/public/$1; echo chmod 444 ~/public/$1'
function linkpub() {
    ln $1 ~/public
    chmod 444 ~/public/$1
}

alias pucp='tar cf - $* | (pushd; tar xvf - )'

#function pucp() {
#   tar cf - $* | (pushd; tar xvf - )
#}

#export PS1="\h:\!:\W> "
#export PS1="\h:\W\$ "
export PS1="[\u@\h \W]\$ "

alias emacs="Emacs" # referes /Applications/Emacs.app
# export PATH=/opt/local/bin:~/bin:~/scripts:$PATH:/Applications/Emacs-23.3.app/Contents/MacOS:/Applications/gnuplot.app:/Applications/gnuplot.app/bin:/Applications/Xcode.app/Contents/Developer/usr/bin:/Applications/ImageMagick-6.8.7/bin/:.
export PATH=PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/bin:~/scripts:.

#export PATH=/opt/local/bin:~/bin:~/scripts:$PATH:/Applications/Emacs-23.3.app/Contents/MacOS:/Applications/gnuplot.app:/Applications/gnuplot.app/bin:/Applications/Xcode.app/Contents/Developer/usr/bin:/usr/texbin/:/Applications/ImageMagick-6.8.7/bin/:.
#export PATH=~/bin:$PATH:/usr/local/bin:/usr/local/teTeX/bin:/Applications/pTeX.app/teTeX/bin:/Users/satoshi/programming/android-sdk-mac_x86/platform-tools:/Users/satoshi/programming/android-sdk-mac_x86/tools:/Applications/gnuplot.app:/Applications/gnuplot.app/bin:.

# alias gs8="sudo rm /usr/local/bin/gs; sudo ln -s /usr/local/bin/gs8 /usr/local/bin/gs"
# alias gs7="sudo rm /usr/local/bin/gs; sudo ln -s /usr/local/bin/gs7 /usr/local/bin/gs"
# For RAMCloud Environment
# alias rcmaster_ssh="ssh -i ~/.ssh/PrivateKey.ppk -l satoshi rcmaster.scs.stanford.edu"
# enable SSH X forwarding
# alias rcmaster_ssh="ssh -X -i ~/.ssh/id_rsa satoshi@rcmaster.scs.stanford.edu"

# for trusted X connection
alias sshrcmaster="ssh -Y -i ~/.ssh/id_rsa satoshi@rcmaster.scs.stanford.edu"
## alias sshrc01="ssh -Y -i ~/.ssh/id_rsa satoshi@rc01.scs.stanford.edu"
# forward http, https to rcmaster to access stanford library ebook.
# see also: http://support.suso.com/supki/SSH_Tutorial_for_Linux
#           http://ja.wikipedia.org/wiki/%E3%83%9D%E3%83%BC%E3%83%88%E7%95%AA%E5%8F%B7
#  Use as:  http://searchworks.stanford.edu:10080/ or https://foo.edu:10443/

# alias ramcloud_ssh="ssh -Y -i ~/.ssh/id_rsa satoshi@ramcloud.stanford.edu"

# added sshfs to rcmaster_ssh. So it covers everything now.
alias rcmaster_ssh="ssh -L10080:rcmaster.scs.stanford.edu:80 -L10443:rcmaster.scs.stanford.edu:443 -Y -i ~/.ssh/id_rsa satoshi@rcmaster.scs.stanford.edu; rcmaster_sshfs"
alias rcmaster_sftp="sftp satoshi@rcmaster.scs.stanford.edu"

# alias rcmaster_sshfs="/Applications/sshfs.app/Contents/MacOS/sshfs satoshi@rcmaster.scs.stanford.edu:/home/satoshi /Users/matsushi/work/rcmaster -aauto_cache,reconnect,volume=rcmaster"

alias rcmaster_fs="sshfs satoshi@rcmaster.scs.stanford.edu:/home/satoshi ~/work/rcmaster"
alias rcmaster_rsync='(date +"%n----Rsync on %c ----%n"; rsync --exclude-from=$HOME/scripts/rsync_rcmaster_exclude.list -av ~/work/rcmaster/work/ramcloud/ ~/work/ramcloud_local) 2>&1 | tee -a rsync_w_slash.log'
alias nas_backup="nas_backup.sh >> ~/nas_backup.log"

alias punook='pushd /Volumes/disk/PubTools/KeitaiTools/Nook'
alias punoc='pushd /Volumes/disk/PubTools/KeitaiTools/Nook/Rooting3-XDA/Extracted/'

# ~/kill-talagent.pl &

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export TEXMFLOCAL=/usr/local/texlive/texmf-local/

## Bibunsho  ver6.
# /Applications/TeXLive/Library/texlive/2013/bin/x86_64-darwin
export BibunshoBase=/Applications/TeXLive/Library
export PATH=${BibunshoBase}/texlive/2013/bin/x86_64-darwin:$PATH
export PATH=${BibunshoBase}/mactexaddons/bin:$PATH
# export LS_COLORS='rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lz=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.bz=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.rar=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:'

