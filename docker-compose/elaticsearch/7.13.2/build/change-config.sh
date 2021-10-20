#!/bin/bash

# 解析REMOTE_EXT_DIC和REMOTE_EXT_STOPWORDS并替换对应文件内容
# /usr/share/elasticsearch/config/analysis-ik/IKAnalyzer.cfg.xml
#
ik_cfg_file="/usr/share/elasticsearch/config/analysis-ik/IKAnalyzer.cfg.xml"


if [[ -n $REMOTE_EXT_STOPWORDS ]]
then
  sed -i "7,8d"                                                                    $ik_cfg_file
  sed -i "7a <entry key=\"remote_ext_stopwords\">$REMOTE_EXT_STOPWORDS</entry>"    $ik_cfg_file
fi


if [[ -n $REMOTE_EXT_DIC ]]
then
  sed -i "5,6d"                                                         $ik_cfg_file
  sed -i "5a <entry key=\"remote_ext_dict\">$REMOTE_EXT_DIC</entry>"    $ik_cfg_file
fi

if [[ $AUTO_CREATE_INDEX ]]
then
  configed=$(grep action.auto_create_index /usr/share/elasticsearch/config/elasticsearch.yml)
  if [[ -z $configed ]]
  then
    echo "action.auto_create_index: '*'" >> /usr/share/elasticsearch/config/elasticsearch.yml
  fi
fi
