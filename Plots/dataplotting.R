# Results for NL-SGD (Small and Medium Datasets)
## Compared with NN-ISDA (Zigic Lj) & MN-SVM (Strack R)
### by: Gabriella Melki

### Clear Workspace and Import Libraries

rm(list=ls())
library(ggplot2)

### set width and height of plots

w <- 300
h <- 480

### SGD vs. NNISDA & MNSVM
#### Small Data
##### Accuracy

smldata_accuracy_compare <- read.csv("AccuracyComparisonSmallData.csv", header = TRUE)
smldata_accuracy_compare$Algorithm <- factor(smldata_accuracy_compare$Algorithm, levels = c("NL-SGD", "NN-ISDA", "MN-SVM"))
head(smldata_accuracy_compare)

g_plot <- ggplot(smldata_accuracy_compare, aes(x=Dataset,y=Accuracy)) +
  geom_bar(aes(fill=Algorithm),position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#E69F00", "Blue", "Red")) +
  facet_grid(scales="free", space="free", .~Dataset) +
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
  labs(y = "Accuracy %") + 
  ggtitle("Accuracy Comparison for Small Data Sets") +
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("AccuracyComparisonSmallData.tiff", height=8, width=12, units='in', dpi = 300)

##### CPU Time

smldata_cpu_compare <- read.csv("CPUTimeComparison_SmallData.csv", header = TRUE)
smldata_cpu_compare$Algorithm <- factor(smldata_cpu_compare$Algorithm, levels = c("NL-SGD", "NN-ISDA", "MN-SVM"))
head(smldata_cpu_compare)

proeuk <- smldata_cpu_compare[smldata_cpu_compare[,"Dataset"] == "Prokaryotic" | smldata_cpu_compare[,"Dataset"] == "Eukaryotic",]
smldata_cpu_compare <- smldata_cpu_compare[smldata_cpu_compare[,"Dataset"] != "Prokaryotic" & smldata_cpu_compare[,"Dataset"] != "Eukaryotic",]

g_plot <- ggplot(smldata_cpu_compare, aes(x=factor(Dataset), y=CPU)) +
  geom_bar(aes(fill=Algorithm),position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#E69F00", "Blue", "Red")) +
  facet_grid(scales="free", space="free", .~Dataset) +
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
  labs(y = "CPU Time (s)") + 
  ggtitle("CPU Time Comparison for Small Data Sets") +
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("CPUTimeComparison_SmallData.tiff", height=8, width=12, units='in', dpi = 300)

g_plot <- ggplot(proeuk, aes(x=factor(Dataset), y=CPU)) +
  geom_bar(aes(fill=Algorithm),position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#E69F00", "Blue", "Red")) +
  facet_grid(scales="free", space="free", .~Dataset) +
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
  labs(y = "CPU Time (s)") + 
  ggtitle("CPU Time Comparison for Prokaryotic & Eukaryotic Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("CPUTimeComparison_SmallData_ProkEuk.tiff", height=8, width=12, units='in', dpi = 300)

rm(proeuk)

#### Medium Data
##### Accuracy

meddata_accuracy_compare <- read.csv("AccuracyComparison_MediumData.csv", header = TRUE)
meddata_accuracy_compare$Algorithm <- factor(meddata_accuracy_compare$Algorithm, levels = c("NL-SGD", "NN-ISDA", "MN-SVM"))
head(meddata_accuracy_compare)

g_plot <- ggplot(meddata_accuracy_compare, aes(x=factor(Dataset), y=ACC)) +
  geom_bar(aes(fill=Algorithm),position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#E69F00", "Blue", "Red")) +
  facet_grid(scales="free", space="free", .~Dataset) +
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
  labs(y = "Accuracy %") + 
  ggtitle("Accuracy Comparison for Medium Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("AccuracyComparison_MediumData.tiff", height=8, width=12, units='in', dpi = 300)

##### CPU Time

meddata_cpu_compare <- read.csv("CPUTimeComparison_MediumData.csv", header = TRUE)
meddata_cpu_compare$Algorithm <- factor(meddata_cpu_compare$Algorithm, levels = c("NL-SGD", "NN-ISDA", "MN-SVM"))
head(meddata_cpu_compare)

g_plot <- ggplot(meddata_cpu_compare, aes(x=factor(Dataset), y=CPU)) +
  geom_bar(aes(fill=Algorithm),position = "dodge", stat = "identity") +
  scale_fill_manual(values=c("#E69F00", "Blue", "Red")) +
  facet_grid(scales="free", space="free", .~Dataset) +
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
  labs(y = "CPU Time (s)") + 
  ggtitle("CPU Time Comparison for Medium Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("CPUTimeComparison_MediumData.tiff", height=8, width=12, units='in', dpi = 300)

### SGD Configurations
#### Small Data
##### Accuracy
library(plyr)
SGD_SmallData <- read.csv("SGD_SmallData.csv", header = TRUE)
SGD_SmallData$KT <- factor(SGD_SmallData$KT, levels = c("0.5", "0.75", "1"))
SGD_SmallData$KT <- revalue(SGD_SmallData$KT, c("0.5"="50%", "0.75"="25%", "1"="0%"))
head(SGD_SmallData)

g_plot <- ggplot(SGD_SmallData, aes(x=factor(KT), y=ACCURACY)) +
  geom_bar(aes(group=interaction(KT,NEPOCH),fill=factor(NEPOCH)),position = "dodge", stat = "identity") +
  guides(fill=guide_legend(title="Epochs")) +
  facet_grid(scales="free", space="free", .~DATASET) +
  labs(x = "Alpha Changes %", y = "Accuracy %") + 
  ggtitle("NL-SGD Accuracy for Small Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        axis.title.x = element_text(size=18, face = "bold", colour = "black"), axis.text.x = element_text(size=14, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("SGDAccuracy_SmallData.tiff", height=8, width=12, units='in', dpi = 300)

##### CPU Time

proeuk <- SGD_SmallData[SGD_SmallData[,"DATASET"] == "Prokaryotic" | SGD_SmallData[,"DATASET"] == "Eukaryotic",]
SGD_SmallData <- SGD_SmallData[SGD_SmallData[,"DATASET"] != "Prokaryotic" & SGD_SmallData[,"DATASET"] != "Eukaryotic",]

g_plot <- ggplot(SGD_SmallData, aes(x=factor(KT), y=CPU)) +
  geom_bar(aes(group=interaction(KT,NEPOCH),fill=factor(NEPOCH)),position = "dodge", stat = "identity") +
  guides(fill=guide_legend(title="Epochs")) +
  facet_grid(scales="free", space="free", .~DATASET) +
  labs(x = "Alpha Changes %", y = "CPU Time (s)") + 
  ggtitle("NL-SGD CPU Time for Small Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        axis.title.x = element_text(size=18, face = "bold", colour = "black"), axis.text.x = element_text(size=14, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("SGDCPUTime_SmallData.tiff", height=8, width=12, units='in', dpi = 300)

g_plot <- ggplot(proeuk, aes(x=factor(KT), y=CPU)) +
  geom_bar(aes(group=interaction(KT,NEPOCH),fill=factor(NEPOCH)),position = "dodge", stat = "identity") +
  guides(fill=guide_legend(title="Epochs")) +
  facet_grid(scales="free", space="free", .~DATASET) +
  labs(x = "Alpha Changes %", y = "CPU Time (s)") + 
  ggtitle("NL-SGD CPU Time for Small Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        axis.title.x = element_text(size=18, face = "bold", colour = "black"), axis.text.x = element_text(size=14, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("SGDCPUTime_SmallData_ProEuk.tiff", height=8, width=12, units='in', dpi = 300)

rm(proeuk)

#### Medium Data
##### Accuracy

SGD_MediumData <- read.csv("SGD_MediumData.csv", header = TRUE)
SGD_MediumData$KT <- factor(SGD_MediumData$KT, levels = c("0.5", "0.75", "1"))
SGD_MediumData$KT <- revalue(SGD_MediumData$KT, c("0.5"="50%", "0.75"="25%", "1"="0%"))
head(SGD_MediumData)

g_plot <- ggplot(SGD_MediumData, aes(x=factor(KT), y=ACCURACY)) +
  geom_bar(aes(group=interaction(KT,NEPOCH),fill=factor(NEPOCH)),position = "dodge", stat = "identity") +
  guides(fill=guide_legend(title="Epochs")) +
  facet_grid(scales="free", space="free", .~DATASET) +
  labs(x = "Alpha Changes %", y = "Accuracy %") + 
  ggtitle("NL-SGD Accuracy for Medium Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        axis.title.x = element_text(size=18, face = "bold", colour = "black"), axis.text.x = element_text(size=14, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("SGDAccuracy_MediumData.tiff", height=8, width=12, units='in', dpi = 300)

##### CPU Time

g_plot <- ggplot(SGD_MediumData, aes(x=factor(KT), y=CPU)) +
  geom_bar(aes(group=interaction(KT,NEPOCH),fill=factor(NEPOCH)),position = "dodge", stat = "identity") +
  guides(fill=guide_legend(title="Epochs")) +
  facet_grid(scales="free", space="free", .~DATASET) +
  labs(x = "Alpha Changes %", y = "CPU Time (s)") + 
  ggtitle("NL-SGD CPU Time for Medium Data Sets")+
  theme(plot.title = element_text(size=18, face = "bold", colour = "black", lineheight = 1), legend.text = element_text(size=14), legend.title = element_text(size=14),
        axis.title.y = element_text(size=18, face = "bold", colour = "black"), axis.text.y = element_text(size=18, face = "bold", colour = "black"),
        axis.title.x = element_text(size=18, face = "bold", colour = "black"), axis.text.x = element_text(size=14, face = "bold", colour = "black"),
        strip.text.x = element_text(size=12,colour = "black",face = "bold"))
ggsave("SGDCPUTime_MediumData.tiff", height=8, width=12, units='in', dpi = 300)
