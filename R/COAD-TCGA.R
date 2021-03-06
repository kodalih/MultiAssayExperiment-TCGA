library(MultiAssayExperiment)
library(RTCGAToolbox)
library(BiocInterfaces)
library(readr)

rD <- getFirehoseRunningDates(last = 1)
## run date: 20151101
gD <- getFirehoseAnalyzeDates(last = 1)
## gistic date: 20150821

coad <- getFirehoseData("COAD", runDate = rD, destdir = "./inst/extdata",
                        gistic2_Date = gD,
                        RNAseq_Gene=TRUE,
                        miRNASeq_Gene=TRUE,
                        RNAseq2_Gene_Norm=TRUE,
                        CNA_SNP = TRUE,
                        CNV_SNP=TRUE,
                        CNA_Seq = TRUE,
                        CNA_CGH = TRUE,
                        Methylation = TRUE,
                        Mutation = TRUE,
                        mRNA_Array = TRUE,
                        miRNA_Array = TRUE,
                        RPPA = TRUE,
                        fileSizeLimit = 50000,
                        RNAseqNorm = "raw_counts",
                        RNAseq2Norm = "normalized_count")

clinical_coad <- coad@Clinical
rownames(clinical_coad) <- gsub("\\.", "-", rownames(clinical_coad))
clinical_coad <- type_convert(clinical_coad)

targets <- c(slotNames(coad)[c(5:16)], "gistica", "gistict")

dataList <- lapply(targets, function(x) {try(TCGAextract(coad, x))})
names(dataList) <- targets

dataFull <- Filter(function(x){class(x)!="try-error"}, dataList)
ExpList <- Elist(dataFull)
NewElist <- TCGAcleanExpList(ExpList, clinical_coad)
NewMap <- generateMap(NewElist, clinical_coad, TCGAbarcode)

coadMAEO <- MultiAssayExperiment(NewElist, clinical_coad, NewMap)
saveRDS(coadMAEO, file = "./inst/extdata/coadMAEO.rds", compress = "bzip2")
## coadMAEO <- readRDS("./inst/extdata/coadMAEO.rds")
