FROM docker.io/heroku/builder:22

RUN mkdir -p /tmp/cache
COPY Aptfile /app/Aptfile
COPY aptfiles /app/aptfiles
RUN git clone https://github.com/fxtentacle/heroku-buildpack-apt.git /tmp/heroku-buildpack-apt
RUN chmod 0777 /app
RUN bash /tmp/heroku-buildpack-apt/bin/compile /app /tmp/cache

RUN curl -L https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-src.zip > t.zip
RUN unzip t.zip

RUN cp /app/.apt/usr/bin/gcj-6 /app/.apt/usr/bin/gcj-6-orig &&\
    sed -i.bak s/\\/usr\\/share\\/java\\/libgcj-6.4.0.jar/~usr\\/share\\/java\\/libgcj-6.4.0.jar/g /app/.apt/usr/bin/gcj-6

RUN cp /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6/ecj1 /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6/ecj1-orig &&\
    sed -i.bak s/\\/usr\\/share\\/java/~usr\\/share\\/java/g /app/.apt/usr/bin/../lib/gcc/x86_64-linux-gnu/6/ecj1

WORKDIR /layers/pdftk-2.02-dist/java
RUN ln -s /app/.apt/usr/ ~usr

WORKDIR /layers/pdftk-2.02-dist/pdftk
RUN ln -s /app/.apt/usr/ ~usr

RUN sed -i.bak s/\\/usr\\/lib/~usr\\/lib/g ./~usr/lib/x86_64-linux-gnu/libm.so &&\
    sed -i.bak s/\\/usr\\/lib/~usr\\/lib/g ./~usr/lib/x86_64-linux-gnu/libc.so &&\
    sed -i.bak s/VERSUFF=-4.6/VERSUFF=-6/g Makefile.Debian &&\
    sed -i.bak s/\\/usr\\/share\\/java/~usr\\/share\\/java/g Makefile.Debian &&\
    sed -i.bak "s/CXXFLAGS=/CXXFLAGS= -I\\/app\\/.apt\\/usr\\/include\\/c++\\/6\\/ -idirafter\\/app\\/.apt\\/usr\\/include -I\\/app\\/.apt\\/usr\\/include\\/x86_64-linux-gnu /g" Makefile.Debian

RUN cd /app/.apt/usr/lib/x86_64-linux-gnu && ln -s libisl.so.23 libisl.so.19

ENV CPATH=/app/.apt/usr/include/c++/6:`pwd`/../java
ENV LD_LIBRARY_PATH=/app/.apt/usr/lib:/app/.apt/usr/lib/x86_64-linux-gnu
ENV PATH=/app/.apt/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN make -f Makefile.Debian || true

RUN mkdir -p /tmp/output &&\
    mv pdftk /tmp/output &&\
    cp --dereference /app/.apt/usr/lib/x86_64-linux-gnu/libgcj.so.17 /tmp/output
