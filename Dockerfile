FROM ubuntu:16.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
RUN apt-get update

# projects
RUN mkdir -p /projects
WORKDIR /projects


# tools
RUN apt-get -y install wget curl git make


# golang 1.7
ENV GOROOT=/usr/local/go
ENV GOPATH=/projects
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
RUN tar -xvf go1.7.linux-amd64.tar.gz
RUN rm go1.7.linux-amd64.tar.gz
RUN mv go /usr/local

# Go tools
# RUN go get github.com/golang/lint/golint

# Go tools for vim-go
# run :GoUpdateBinaries in vim to update the installed binaries
RUN go get github.com/nsf/gocode
RUN go get github.com/alecthomas/gometalinter
RUN go get golang.org/x/tools/cmd/goimports
RUN go get golang.org/x/tools/cmd/guru
RUN go get golang.org/x/tools/cmd/gorename
RUN go get github.com/rogpeppe/godef
RUN go get github.com/kisielk/errcheck
RUN go get github.com/jstemmer/gotags
RUN go get github.com/klauspost/asmfmt/cmd/asmfmt
RUN go get github.com/fatih/motion
RUN go get github.com/zmb3/gogetdoc
RUN go get github.com/josharian/impl

# Create local directory
RUN mkdir /projects/src/local


# vim 8.0
# http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/
RUN add-apt-repository ppa:jonathonf/vim && apt-get update && apt-get install -y vim
RUN apt-get install -y vim-nox

# pathogen vi plugin manager
# https://github.com/tpope/vim-pathogen
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
COPY vimrc /root/.vimrc

# vim-go
# https://github.com/fatih/vim-go
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

# fugative
RUN git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive

# nerdtree
# https://github.com/scrooloose/nerdtree
RUN git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

# vim.ack (full-text search)
RUN apt-get install -y ack-grep
RUN git clone https://github.com/mileszs/ack.vim.git ~/.vim/bundle/ack.vim

# neocomplete (auto complete)
# https://github.com/Shougo/neocomplete.vim
RUN git clone https://github.com/Shougo/neocomplete.vim ~/.vim/bundle/neocomplete.vim

# vim.airline (status bar)
RUN git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
RUN git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes

RUN git clone https://github.com/powerline/fonts.git ~/.vim/fonts
RUN ~/.vim/fonts/install.sh

# ctrlp.vim (finding files)
RUN git clone https://github.com/kien/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim


# setup git config
COPY .gitconfig /root/.gitconfig


# start up
RUN mkdir -p /run
COPY ./start.sh /run


# Terraform - comment if not needed
RUN wget https://releases.hashicorp.com/terraform/0.8.2/terraform_0.8.2_linux_amd64.zip
ENV TERRAFORMPATH=/var/terraform
RUN mkdir $TERRAFORMPATH
RUN unzip terraform_0.8.2_linux_amd64.zip -d $TERRAFORMPATH && rm terraform_0.8.2_linux_amd64.zip
ENV PATH=$PATH:$TERRAFORMPATH




# Ruby

# dependencies
#RUN apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# rbenv
#ENV RBENVINSTPATH=/root/.rbenv
#RUN git clone https://github.com/rbenv/rbenv.git $RBENVINSTPATH
#ENV PATH=$PATH:$RBENVINSTPATH
#RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
#RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc

# ruby-build
#RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build

# install ruby 2.2.5 as default
RUN eval "$(rbenv init -)"
# RUN rbenv install ruby 2.2.5
# RUN rbenv global 2.2.5



# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD [ "/run/start.sh" ]
