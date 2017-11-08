cd wgcna
Rscript wgcnaworking.R
cd ..
n=1
cat begin.html>result.html
while read a b c
do
    if (( n == 1 ))
    then
        n=0
        continue
    fi
    echo "{data: {id:'"$a"',type : '"$c"'} },">>result.html
done < wgcna/CytoscapeInput-nodes-testData_threshold.05.txt
n=1
while read a b c d e f
do
    if (( n == 1 ))
    then
        n=0
        continue
    fi
    echo "{data: {id:'"$a$b"',source : '"$a"',target:'"$b"'} },">>result.html
done < wgcna/CytoscapeInput-edges-testData_threshold.05.txt
cat end.html >> result.html
