FROM java:7
MAINTAINER Dave Nunez <dnunez24@gmail.com>

ENV SOLR_VERSION 3.6.2
ENV SOLR apache-solr-$SOLR_VERSION
ENV SOLR_HOME /srv/solr
ENV SOLR_USER solr
ENV SOLR_PORT 8983

WORKDIR /usr/src
RUN wget http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz \
  && wget http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz.asc \
  && wget http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/KEYS \
  && gpg --import KEYS \
  && gpg --verify $SOLR.tgz.asc $SOLR.tgz \
  && tar -xzf $SOLR.tgz \
  && cp -R $SOLR/example $SOLR_HOME \
  && rm -rf $SOLR \
  && rm $SOLR.tgz \
  && rm $SOLR.tgz.asc \
  && rm KEYS \
  && groupadd -r $SOLR_USER \
  && useradd -r -d $SOLR_HOME -s /bin/false -g $SOLR_USER $SOLR_USER
WORKDIR $SOLR_HOME
COPY conf/* solr/conf/
COPY jetty-logging.xml etc/jetty-logging.xml
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint
RUN chown -R $SOLR_USER:$SOLR_USER $SOLR_HOME \
  && chown $SOLR_USER:$SOLR_USER /usr/bin/docker-entrypoint \
  && chmod ug+x /usr/bin/docker-entrypoint

EXPOSE $SOLR_PORT
USER $SOLR_USER
ENTRYPOINT ["/usr/bin/docker-entrypoint"]
CMD ["solr", "-Xms512m", "-Xmx512m"]
