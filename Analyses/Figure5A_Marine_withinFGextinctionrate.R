#measure within-functional group extinction % - marine functional groups 
library(divDyn)
library(vegan)

#Data input
load('TJ_marine_ecospacedata')
TJ_data <- final_marine_rawdat
data(stages)
TJ_stages <- stages$stage[56:63]
fgnumber_list <- unique(TJ_data$FG_Number)
fgnumber_list <- sort(fgnumber_list[!is.na(fgnumber_list)])

#===== subsampling protocol =====#
preTJ_stage <- stages$stage[58]
postTJ_stages <- stages$stage[59:62]
these_TJ_stages <- c(preTJ_stage, postTJ_stages)

fg_ext_data_subbed <- as.data.frame(matrix(NA, ncol=6, nrow=length(fgnumber_list)))
colnames(fg_ext_data_subbed) <- c('FunctionalGroup', 'PreExtinctionOccupancy', 'PreExtinction', 'Survivors', 'ExtRate', 'PreGeneraCount')
fg_ext_data_subbed$FunctionalGroup <- fgnumber_list

iter <- 1000   #1000 iterations
colls.n <- 400

occs_all <- as.data.frame(matrix(NA, ncol=length(fgnumber_list), nrow=iter))
colnames(occs_all) <- fgnumber_list

ext_all <- as.data.frame(matrix(NA, ncol=length(fgnumber_list), nrow=iter))
colnames(ext_all) <- fgnumber_list

pregen_all <- as.data.frame(matrix(NA, ncol=length(fgnumber_list), nrow=iter))
colnames(pregen_all) <- fgnumber_list

survivors_all <- as.data.frame(matrix(NA, ncol=length(fgnumber_list), nrow=iter))
colnames(survivors_all) <- fgnumber_list

for(i in 1:iter){
  
 #get stage data and take 400 random collections  of each  
 Rhae_data <- TJ_data[which(TJ_data$stage=='Rhaetian'),]
 colls <- unique(Rhae_data$collection_no)
 subbed_colls <- sample(colls, colls.n, replace=TRUE)
 Rhae_subbed <- Rhae_data[which(Rhae_data$collection_no %in% subbed_colls),]
 
 Hett_data <- TJ_data[which(TJ_data$stage=='Hettangian'),]
 colls <- unique(Hett_data$collection_no)
 subbed_colls <- sample(colls, colls.n, replace=TRUE)
 Hett_subbed <- Hett_data[which(Hett_data$collection_no %in% subbed_colls),]
 
 Sine_data <- TJ_data[which(TJ_data$stage=='Sinemurian'),]
 colls <- unique(Sine_data$collection_no)
 subbed_colls <- sample(colls, colls.n, replace=TRUE)
 Sine_subbed <- Sine_data[which(Sine_data$collection_no %in% subbed_colls),]
 
 Pliens_data <- TJ_data[which(TJ_data$stage=='Pliensbachian'),]
 colls <- unique(Pliens_data$collection_no)
 subbed_colls <- sample(colls, colls.n, replace=TRUE)
 Pliens_subbed <- Pliens_data[which(Pliens_data$collection_no %in% subbed_colls),]
 
 Toar_data <- TJ_data[which(TJ_data$stage=='Toarcian'),]
 colls <- unique(Toar_data$collection_no)
 subbed_colls <- sample(colls, colls.n, replace=TRUE)
 Toar_subbed <- Toar_data[which(Toar_data$collection_no %in% subbed_colls),]
 
 preTJ_data <- Rhae_subbed 
 postTJ_data <- rbind(Hett_subbed, Sine_subbed, Pliens_subbed, Toar_subbed)
 
 for(j in 1:length(fgnumber_list)){
   
   this.fg <- fgnumber_list[j]
   this.fg_pre <- preTJ_data[which(preTJ_data$FG_Number == this.fg),] 
   pre_genera <- unique(this.fg_pre$genus)
   this.fg_post <- postTJ_data[which(postTJ_data$FG_Number == this.fg),]
   surviving_genera_data <- this.fg_post[which(this.fg_post$genus %in% pre_genera),]
   preext_genera <- nrow(this.fg_pre)
   surviving_genera <- unique(surviving_genera_data$genus)
   extinction <- ((length(pre_genera)-length(surviving_genera))/length(pre_genera))*100
   
   occs_all[i,j] <- preext_genera
   ext_all[i,j] <- extinction
   pregen_all[i,j] <- length(pre_genera)
   survivors_all[i,j] <- length(surviving_genera)
   
 }
 
 print(paste('iteration # ', i, 'finished'))
 print(paste('average extinction rate:', rowMeans(ext_all[i,], na.rm=TRUE)))
  
}

save(occs_all, file='Output/marine_occsall_unprocessed_allFGs.RData')
save(ext_all, file='Output/marine_extall_unprocessed_allFGs.RData')
save(pregen_all, file='Output/marine_pregenall_unprocessed_allFGs.RData')
save(survivors_all, file='Output/marine_survivorsall_unprocessed_allFGs.RData')

fg_ext_data_subbed <- as.data.frame(matrix(NA, ncol=8, nrow=length(fgnumber_list)))
colnames(fg_ext_data_subbed) <- c('FunctionalGroup', 'PreExtinctionOccupancy', 'PreExtinction', 'Survivors', 'ExtRate', 'Ext_5', 'Ext_95', 'PreGeneraCount')
fg_ext_data_subbed$FunctionalGroup <- fgnumber_list

fg_ext_data_subbed$PreExtinctionOccupancy <- colMeans(occs_all, na.rm=TRUE)
fg_ext_data_subbed$PreExtinction <- colMeans(pregen_all, na.rm=TRUE)
fg_ext_data_subbed$Survivors     <- colMeans(survivors_all, na.rm=TRUE)
fg_ext_data_subbed$ExtRate       <- colMeans(ext_all, na.rm=TRUE)
fg_ext_data_subbed$Ext_5         <- apply(ext_all, 2, quantile, probs=0.05, na.rm=TRUE)
fg_ext_data_subbed$Ext_95        <- apply(ext_all, 2, quantile, probs=0.95, na.rm=TRUE)

for(i in 1:nrow(fg_ext_data_subbed)){
  
  pre_genera <- fg_ext_data_subbed$PreExtinction[i]
  
  if(pre_genera < 10){
    fg_ext_data_subbed$PreGeneraCount[i] <- '<10'
  } else{ fg_ext_data_subbed$PreGeneraCount[i] <- '>10'}
  
}

save(fg_ext_data_subbed, file='Output/marine_fg_ext_data_subbed_allFGs.RData')




