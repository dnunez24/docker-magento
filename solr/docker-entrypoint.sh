#!/bin/bash
set -e

if [ "$1" = "solr" ]; then
  shift
  
  JAVA_OPTIONS="-Djetty.home=$SOLR_HOME \
  -Djetty.logs=$SOLR_HOME/logs \
  -Djetty.port=$SOLR_PORT \
  -Djetty.user=$SOLR_USER \
  -Dsolr.solr.home=$SOLR_HOME/solr"

  exec /usr/bin/java $JAVA_OPTIONS "$@" -jar start.jar
fi

exec "$@"
