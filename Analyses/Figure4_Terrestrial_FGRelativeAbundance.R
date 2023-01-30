#relative abundance of functional groups in each stage bin - marine
library('divDyn')
data(stages)

load('Datasets/TJ_terrestrial_ecospacedata.RData')
TJ_data <- final_terrestrial_rawdat
TJ_stages <- stages$stage[56:63] 
fgnumber_list <- unique(TJ_data$FG_Number)
fgnumber_list 

#make table of all functional groups, their total # taxa, and # of unique genera
fg_table <- as.data.frame(matrix(NA, ncol=5, nrow=length(fgnumber_list)))
colnames(fg_table) <- c('FG_code', 'total_taxa', 'unique_genera', 'totaltaxapercent', 'genericpercent')
rownames(fg_table) <- sort(fgnumber_list)
fg_table$FG_code <- sort(fgnumber_list)

for(i in 1:nrow(fg_table)){
  
  this.fg <- fgnumber_list[i]
  fg.data <- subset(TJ_data, (TJ_data$FG_Number==this.fg))
  
  #total taxa count
  fg_table[as.character(this.fg),'total_taxa'] <- nrow(fg.data)
  fg_table[as.character(this.fg),'totaltaxapercent'] <- nrow(fg.data)/nrow(TJ_data)*100
  
  #unique genera 
  fg_table[as.character(this.fg),'unique_genera'] <- length(unique(fg.data$genus))
  fg_table[as.character(this.fg),'genericpercent'] <- length(unique(fg.data$genus))/length(unique(TJ_data$genus))*100                                                         
  
}

write.table(fg_table, file='Output/terrestrial_fgtable.txt')


#initial dataframe to save results
relabund_occs_df <- as.data.frame(matrix(NA, ncol=length(TJ_stages), nrow=length(fgnumber_list)))
colnames(relabund_occs_df) <- TJ_stages
rownames(relabund_occs_df) <- fgnumber_list
head(relabund_occs_df)


#===== subsampling ======#
#for each stage,
#set up a temporary dataframe
#do the following 1000 times:
#get n.colls occurrences (30 for terrestrial)
#calculate the relative abundance of each generic richness
#save in temporary dataframe
#take the colMeans of the temporary dataframe
#same in relabund_df[fg_number,stage]

colls.n <- 30
iter <- 1000

for(i in 1:length(TJ_stages)){
  
  curr.stage <- TJ_stages[i]
  stage.data <- TJ_data[which(TJ_data$stage==curr.stage),]
  colls <- unique(stage.data$collection_no)
  
  #temporary dataframe
  temp.results <- as.data.frame(matrix(NA, nrow=iter, ncol=length(fgnumber_list)))
  colnames(temp.results) <- fgnumber_list
  
  print(paste('on stage:', curr.stage))
  
  for(j in 1:iter){
    
    sub.colls <- sample(colls, colls.n, replace=TRUE)
    subbed.data <- stage.data[which(stage.data$collection_no %in% sub.colls),]
    
    tot.fgs <- nrow(subbed.data)
    
    for(k in 1:length(fgnumber_list)){
      
      #print(paste('calculating functional group:', fgnumber_list[k]))
      this.fgdata <- subbed.data[which(subbed.data$FG_Number==fgnumber_list[k]),]
      these.fgs <- nrow(this.fgdata)
      prop.occs <- these.fgs/tot.fgs
      
      temp.results[j,as.character(fgnumber_list[k])] <- prop.occs
      
    }
    
    mean.stage.results <- colMeans(temp.results)
    relabund_occs_df[,TJ_stages[i]] <- mean.stage.results
    
  }
  
}

colSums(relabund_occs_df) #should all = 1

save(relabund_occs_df, file='Output/terrestrial_relabund_occs_df.RData')

#same thing for proportional richness
#initial dataframe to save results
relabund_genrich_df <- as.data.frame(matrix(NA, ncol=length(TJ_stages), nrow=length(fgnumber_list)))
colnames(relabund_genrich_df) <- TJ_stages
rownames(relabund_genrich_df) <- fgnumber_list
head(relabund_genrich_df)

colls.n <- 30
iter <- 1000


for(i in 1:length(TJ_stages)){
  
  curr.stage <- TJ_stages[i]
  stage.data <- TJ_data[which(TJ_data$stage==curr.stage),]
  colls <- unique(stage.data$collection_no)
  
  #temporary dataframe
  temp.results <- as.data.frame(matrix(NA, nrow=iter, ncol=length(fgnumber_list)))
  colnames(temp.results) <- fgnumber_list
  
  print(paste('on stage:', curr.stage))
  
  for(j in 1:iter){
    
    #get 400 random collection numbers
    sub.colls <- sample(colls, colls.n, replace=TRUE)
    subbed.data <- stage.data[which(stage.data$collection_no %in% sub.colls),]
    
    tot.fgs.richness <- length(unique(subbed.data$genus))
    
    for(k in 1:length(fgnumber_list)){
      
      this.fgdata <- subbed.data[which(subbed.data$FG_Number==fgnumber_list[k]),]
      these.fgs <- length(unique(this.fgdata$genus))
      prop.rich <- these.fgs/tot.fgs.richness
      
      temp.results[j,as.character(fgnumber_list[k])] <- prop.rich
      
    }
    
    mean.stage.results <- colMeans(temp.results)
    relabund_genrich_df[,TJ_stages[i]] <- mean.stage.results
    
  }
  
}


colSums(relabund_genrich_df) # should all equal 1 again

save(relabund_genrich_df, file='Output/terrestrial_relabund_genrich_df.RData')

