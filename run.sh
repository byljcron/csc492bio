cd wgcna
Rscript wgcnaworking.R
cd ..
n=1
#cat begin.html>result.html
echo "[">data.json
while read node b color
do
    if (( n == 1 ))
    then
        n=0
        continue
    fi
    echo '{"data": {"id":"'$node'","type" : "'$color'"} },'>>data.json
    #echo "{data: {id:'"$node"',type : '"$color"'} },">>result.html
done < wgcna/CytoscapeInput-nodes-testData_threshold.out.txt
n=1
while read nodefrom nodeto weight e f
do
    if (( n == 1 ))
    then
        n=0
        continue
    fi
    #echo "{data: {id:'"$nodefrom$nodeto"',source : '"$nodefrom"',target:'"$nodeto"','weight':"$weight"} },">>result.html
    echo '{"data": {"id":"'$nodefrom$nodeto'","source" : "'$nodefrom'","target":"'$nodeto'","weight":'$weight'} },'>>data.json
done < wgcna/CytoscapeInput-edges-testData_threshold.out.txt
sed -i '$ s/.$//' data.json
echo "]">>data.json
#echo "]});">>result.html
#while read node shapeset
#do
#    echo "cy.getElementById('$node').data'set','$shapeset');">>result.html
#done < shape.txt
#cat end.html >> result.html
