#!/usr/bin/env bash

if [ $? -eq 0 ]
then
    echo "导出xcarchive成功！"
else
    echo "导出xcarchive失败！"
    exit 1
fi

# 获取当前路径
path=$(dirname $0)
path=${path/\./$(pwd)}
file="{$path}/TeamExportOptionsPlist"

echo "TeamExportOptionsPlist.plist" > tempfile

source './create_xml.sh'
source './version.sh'

examineVersion

put_head 'xml version="1.0" encoding="UTF-8"'
put '!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"'
tag_start 'plist version="1.0"'
tag_start 'dict'

compileBitcode='false'

if [ $nine_above == true ]
then
    put_key 'key' 'compileBitcode'
    compileBitcode='true'
fi

if [ ${5} == true ]
then
    compileBitcode=${6}
fi

tag_value $compileBitcode

put_key 'key' 'method'
put_key 'string' ${1}

put_key 'key' 'provisioningProfiles'
tag_start 'dict'
put_key 'key' ${3}
put_key 'string' ${4}
tag_end 'dict'

if [ $nine_above == false ]
then
    tag_end 'dict'
    tag_end 'plist'
    exit 1
fi
put_key 'key' 'signingStyle'
put_key 'string' 'automatic'
put_key 'key' 'stripSwiftSymbols'
tag_value 'true'
put_key 'key' 'teamID'
put_key 'string' ${2}
put_key 'key' 'thinning'
put_key 'string' '&lt;none&gt;'
tag_end 'dict'
tag_end 'plist'

rm tempfile
