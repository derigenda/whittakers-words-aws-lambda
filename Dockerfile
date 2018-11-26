FROM amazonlinux
RUN yum update -y &&\
    yum install -y \
    gcc-gnat \
    libgnat \
    zip \
    unzip \
    which \
    awscli \
    groff \
    python3 \
    make &&\
    curl -k https://github.com/AdaCore/gprbuild/archive/master.zip -o /home/gprbuild.zip -L &&\
    unzip /home/gprbuild.zip -d /home &&\
    curl -k https://github.com/AdaCore/xmlada/archive/master.zip -o /home/xmlada.zip -L &&\
    unzip /home/xmlada.zip -d /home &&\
    cd /home/gprbuild-master &&\
    ./bootstrap.sh --with-xmlada=/home/xmlada-master --prefix=./bootstrap &&\
    export PATH="/home/gprbuild-master/bootstrap/bin:$PATH" &&\
    make prefix=./bootstrap setup &&\
    ln -s /usr/lib/gcc/x86_64-redhat-linux/7 /usr/lib/gcc/x86_64-redhat-linux/$(gcc -v 2>&1 | awk '/^gcc version/{print $3}') &&\
    curl -k https://github.com/mk270/whitakers-words/archive/master.zip -o /home/whitakers-words.zip -L &&\
    unzip /home/whitakers-words.zip -d /home &&\
    cd /home/whitakers-words-master &&\
    make &&\
    rm -r /home/whitakers-words.zip /home/xmlada* /home/gprbuild* &&\
    mkdir -p /home/dist/bin &&\
    cp INFLECTS.SEC DICTFILE.GEN STEMFILE.GEN UNIQUES.LAT ADDONS.LAT EWDSFILE.GEN INDXFILE.GEN /home/dist &&\
    cp bin/words /home/dist/bin

ADD handler.py /home/dist

RUN  cd /home/dist && zip -r9 /home/dist.zip .

ENTRYPOINT ["aws", "lambda", "update-function-code", "--function-name", "whittaker", "--zip-file", "fileb:///home/dist.zip"]