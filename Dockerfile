FROM ubuntu:20.04

RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
RUN apt-get update

# projects
RUN mkdir -p /projects
WORKDIR /projects


# tools
RUN apt-get -y install wget curl git make openssh-server


# ssh
# default ssh user password (define value in .env file)
ARG SSH_PASS=dontusethisdefault
ARG SSH_AUTHORIZED_KEYS=authorized_keys
ARG SSH_USER=lupin

RUN useradd -m -s /bin/bash -p $(openssl passwd -1 $SSH_PASS) $SSH_USER
RUN mkdir /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys


# golang 1.15
ENV GOROOT=/usr/local/go
ENV GOPATH=/projects
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN wget https://storage.googleapis.com/golang/go1.15.linux-amd64.tar.gz
RUN tar -xvf go1.15.linux-amd64.tar.gz
RUN rm go1.15.linux-amd64.tar.gz
RUN mv go /usr/local

# Go tools
RUN go get -u golang.org/x/lint/golint

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



# VIM

# vim 8.2
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


# AWS CLI

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


# Node.js
ENV NODE_VERSION=12.9
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash


# setup git config
COPY .gitconfig /root/.gitconfig


# start up
RUN mkdir -p /run
COPY ./start.sh /run

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD [ "/run/start.sh" ]
