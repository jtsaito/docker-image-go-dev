FROM ubuntu:16.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
RUN apt-get update

# projects
RUN mkdir -p /projects
WORKDIR /projects


# tools
RUN apt-get -y install wget curl git


# vim 8.0
# http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/
RUN add-apt-repository ppa:jonathonf/vim && apt-get update && apt-get install -y vim

# pathogen vi plugin manager
# https://github.com/tpope/vim-pathogen
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
COPY vimrc /root/.vimrc

# vim-go
# https://github.com/fatih/vim-go
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go


# setup git config
# COPY .gitconfig /root/.gitconfig


# golang 1.7
ENV GOROOT=/usr/local/go
ENV GOPATH=/projects
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
RUN tar -xvf go1.7.linux-amd64.tar.gz
RUN rm go1.7.linux-amd64.tar.gz
RUN mv go /usr/local


# start up
RUN mkdir -p /run
COPY ./start.sh /run


# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD [ "/run/start.sh" ]
