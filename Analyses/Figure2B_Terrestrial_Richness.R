#anlaysis of generic and functional richness - Terrestrial 

load('Datasets/TJ_terrestrial_ecospacedata.RData')
TJ_data <- final_terrestrial_rawdat

library(divDyn)
data(stages)
data(keys)
names(keys)

#====== SUBSAMPLING PROTOCOL ======#

#======= BY COLLECTION SUBSAMPLING =====#
#Subsampling steps -- subsampling collections
#FOR EACH STAGE -
#1 - for each iter (1000) times...
#2 - sample coll.n (30) collections
#3 - calculate generic diversity from those 1500 occurrences, save in collsubsample.gendiv
#4 - calculate functional diversity from those 1500 occurrences, save in collsubsample.funcdiv
#USE FUNCTIONS FROM TJ_FUNCTIONS.R!!!

coll.n <- 30
iter <- 1000
TJ_stages <- stages$stage[57:62] #can't subsample the Carnian or Aalenian, too small

#generic diversity 
collsubsample.gendiv <- as.data.frame(matrix(NA, nrow=iter, ncol=length(TJ_stages)))
colnames(collsubsample.gendiv) <- TJ_stages
collsubsample.gendiv <- subcollections.genrich(TJ_data, TJ_stages, coll.n, iter, collsubsample.gendiv)
head(collsubsample.gendiv) #check


collsubsample.funcdiv <- as.data.frame(matrix(NA, nrow=iter, ncol=length(TJ_stages)))
colnames(collsubsample.funcdiv) <- TJ_stages
collsubsample.funcdiv <- subcollections.funcrich(TJ_data, TJ_stages, coll.n, iter, collsubsample.funcdiv)
head(collsubsample.funcdiv) #check

#put that into dataframes with the mean, 5th and 95th percentiles, and sd using function calc.quantiles
#generic diversity from collection subsampling
collsubgendiv.final <- as.data.frame(matrix(NA, ncol=6, nrow=length(TJ_stages)))
colnames(collsubgendiv.final) <- c('stage', 'age_mid', 'mean', 'fifth', 'ninetyfifth', 'sd')
collsubgendiv.final$stage <- TJ_stages
collsubgendiv.final$age_mid <- stages$mid[57:62]
collsubgendiv.final <- calc.quantiles(collsubsample.gendiv, TJ_stages, collsubgendiv.final)
collsubgendiv.final

#functional diversity from collection subsampling
collsubfuncdiv.final <- as.data.frame(matrix(NA, ncol=6, nrow=length(TJ_stages)))
colnames(collsubfuncdiv.final) <- c('Stage', 'age_mid', 'mean', 'fifth', 'ninetyfifth', 'sd')
collsubfuncdiv.final$Stage <- TJ_stages
collsubfuncdiv.final$age_mid <- stages$mid[57:62]
collsubfuncdiv.final <- calc.quantiles(collsubsample.funcdiv, TJ_stages, collsubfuncdiv.final)
collsubfuncdiv.final

#SAVE DATA!
save(collsubgendiv.final, file='Output/terrestrial_collsubbed_genericrichness.RData')
save(collsubfuncdiv.final, file='Output/terrestrial_collsubbed_functionalrichness.RData')

