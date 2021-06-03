FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:avsm/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      opam \
      ocaml \
      build-essential \
      jq \
      aspcud \
      vim \
      gcc \
      ocamlbuild \
      m4 && \
    echo "yes" >> /tmp/yes.txt && \
    opam init --disable-sandboxing -y < /tmp/yes.txt
RUN wget http://downloads.sourceforge.net/project/cil/cil/cil-1.7.3.tar.gz && \
    tar xvzf cil-1.7.3.tar.gz && \
    cd cil-1.7.3 && ./configure; make -j32; make install

RUN mkdir -p /opt/genprog
WORKDIR /opt/genprog
ADD Makefile Makefile
ADD src src

RUN mkdir bin && \
    eval $(opam config env) && \
    make && \
    mv src/repair bin/genprog && \
    ln -s bin/genprog bin/repair && \
    mv src/distserver bin/distserver && \
    mv src/nhtserver bin/nhtserver

ENV PATH "/opt/genprog/bin:${PATH}"

VOLUME /opt/genprog
ADD cil-cg.tar.gz /opt

