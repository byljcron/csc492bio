# you have to change work directory to your own
#setwd("/Users/ezeng/Documents/Research/Stuart_Jones/Environmental")

# load WGANA library
library(WGCNA)
options(stringsAsFactors = FALSE)

# read data file, change file name to your file
sdata <- read.table("test_data.txt", header=T, sep="\t",row.names=1)
#convert the data into integer
sdata = sdata*1.0

#transpose data: cluster based on cog not the strains
#remove this to cluster based 
dat0 <- t(sdata)
dat00 <- dat0[,goodGenes(dat0)]
datExpr0 = as.data.frame(dat00)
datExpr0 <- t(datExpr0)
datExpr <- datExpr0
str(datExpr)




# choose appropriate power that achieves R^2 bigger than 0.8, and with reasonable Mean Connectivity (not too small) 

powers = c(c(1:10), seq(from = 2, to=20, by=2))
sft = pickSoftThreshold(datExpr, powerVector = powers, verbose = 5)
sizeGrWindow(9, 5)
par(mfrow = c(1,2));
cex1 = 0.9;
png("tmp.png") 
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",main = paste("Scale independence"))
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],labels=powers,cex=cex1,col="red")

dev.off()

plot(sft$fitIndices[,1], sft$fitIndices[,5],xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")

browseURL("tmp.png") 

cat("Enter an integer for power:  ")
n <- scan("stdin", 0,  n=1, quiet = TRUE)
n=as.numeric(n)

file.remove("tmp.png")
# in this example, power = 5 is picked up
net = blockwiseModules(datExpr, power = n, minModuleSize = 10, reassignThreshold = 0, mergeCutHeight = 0.25,numericLabels = TRUE, pamRespectsDendro = FALSE, saveTOMs = TRUE, saveTOMFileBase = "SigGene_averageTechRep_Temp_qvalue_005", verbose = 3)
TOM <- TOMsimilarityFromExpr(datExpr, power = 5)

sizeGrWindow(12, 9)
mergedColors = labels2colors(net$colors)
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]], "Module colors",dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05)

# note that power = 5, change it accordingly based on your data  
dissTOM = 1-TOMsimilarityFromExpr(datExpr, power = 5)
moduleLabels = net$colors
moduleColors = labels2colors(net$colors)
MEs = net$MEs; geneTree = net$dendrograms[[1]]

# 5 is power
plotTOM = dissTOM^5
diag(plotTOM) = NA

# save the heat map 
jpeg("Module_of_3_Environs.jpg")
TOMplot(plotTOM, geneTree, moduleColors, main = "Network heatmap plot, Test_data")
dev.off()


moduleLabels = net$colors
moduleColors = labels2colors(net$colors)


# get the number of genes belonging to each module
table(moduleColors)

# save network files. Please send me all these Cytoscape input files once you finished
# we are saving two files module file and edge file
cyt = exportNetworkToCytoscape(TOM, edgeFile = paste("CytoscapeInput-edges-testData_threshold.09", ".txt", sep=""), nodeFile = paste("CytoscapeInput-nodes-testData_threshold.09", ".txt", sep=""), weighted = TRUE, threshold = 0.09,nodeNames = colnames(datExpr), nodeAttr = moduleColors)
cyt = exportNetworkToCytoscape(TOM, edgeFile = paste("CytoscapeInput-edges-testData_threshold.05", ".txt", sep=""), nodeFile = paste("CytoscapeInput-nodes-testData_threshold.05", ".txt", sep=""), weighted = TRUE, threshold = 0.05,nodeNames = colnames(datExpr), nodeAttr = moduleColors)
cyt = exportNetworkToCytoscape(TOM, edgeFile = paste("CytoscapeInput-edges-testData_threshold.07", ".txt", sep=""), nodeFile = paste("CytoscapeInput-nodes-testData_threshold.07", ".txt", sep=""), weighted = TRUE, threshold = 0.07,nodeNames = colnames(datExpr), nodeAttr = moduleColors)

