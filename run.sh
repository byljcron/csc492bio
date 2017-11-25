#!/bin/bash
path=$1/netVisualStatic
mkdir $path
echo "no"> $path/powerncut.txt
cp code.js $path/code.js
cp index.html $path/index.html
cp style.css $path/style.css
cp cy-style.json $path/cy-style.json
 
cd wgcna
Rscript wgcnaworking.R  $path
cd ..
n=1
#cat begin.html>result.html
echo "[">$path/data.json
while read node b color
do
    if (( $n >0 ))
    then
        n=0
        continue
    fi
    echo '{"data": {"id":"'$node'","type" : "'$color'"} },'>>$path/data.json
    #echo "{$path/data: {id:'"$node"',type : '"$color"'} },">>result.html
done < $path/CytoscapeInput-nodes-testData_threshold.out.txt
n=1
while read nodefrom nodeto weight e f
do
    if (( $n >0 ))
    then
        n=0
        continue
    fi
    #echo "{$path/data: {id:'"$nodefrom$nodeto"',source : '"$nodefrom"',target:'"$nodeto"','weight':"$weight"} },">>result.html
    echo '{"data": {"id":"'$nodefrom$nodeto'","source" : "'$nodefrom'","target":"'$nodeto'","weight":'$weight'} },'>>$path/data.json
done < $path/CytoscapeInput-edges-testData_threshold.out.txt
sed -i '$ s/.$//' $path/data.json
echo "]">>$path/data.json
#echo "]});">>result.html
#while read node shapeset
#do
#    echo "cy.getElementById('$node').data'set','$shapeset');">>result.html
#done < shape.txt #cat end.html >> result.html
