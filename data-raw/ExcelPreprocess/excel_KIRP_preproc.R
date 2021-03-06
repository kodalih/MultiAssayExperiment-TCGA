## Preprocessing of kirp

library(readxl)
library(dplyr)
kirpdata <- read_excel("data-raw/ExcelPreprocess/kirp.xlsx", sheet= "KIRP Compiled Clin. & Mol. Data", skip= 2)


write.csv(kirpdata, file = "./data-raw/ExcelPreprocess/KIRP.csv")
