FROM elasticsearch:7.13.2

COPY ./* ./addition-conf/

RUN cp ./addition-conf/change-config.sh ./                                                                                       && \
    chmod +x /usr/share/elasticsearch/change-config.sh                                                                           && \
    sed -i "2a /usr/share/elasticsearch/change-config.sh" /usr/local/bin/docker-entrypoint.sh                                    && \
    sh -c '/bin/echo -e "y" | bin/elasticsearch-plugin install -b file:///usr/share/elasticsearch/addition-conf/analysis-ik.zip' && \
    sh -c '/bin/echo -e "y" | bin/elasticsearch-plugin install -b file:///usr/share/elasticsearch/addition-conf/ltr-plugin.zip'  && \
    sh -c '/bin/echo -e "y" | bin/elasticsearch-plugin install -b file:///usr/share/elasticsearch/addition-conf/elasticsearch-analysis-pinyin.zip' && \
    rm -rf ./addition-conf
