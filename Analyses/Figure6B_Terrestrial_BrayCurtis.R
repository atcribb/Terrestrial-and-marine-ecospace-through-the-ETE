#Bray-Curtis dissimilarity for ecological flux and stability - Terretrial 
library('divDyn')
library('vegan')

#Data input
load('Datasets/TJ_terrestrial_ecospacedata.RData')
TJ_data <- final_marine_rawdat
data(stages)
TJ_stages <- stages$stage[56:63]

#Bray-Curtis Dissimilarity:
Carnian_data       <- TJ_data[which(TJ_data$stage=='Carnian'),]
Norian_data        <- TJ_data[which(TJ_data$stage=='Norian'),]
Rhaetian_data      <- TJ_data[which(TJ_data$stage=='Rhaetian'),]
Hettangian_data    <- TJ_data[which(TJ_data$stage=='Hettangian'),]
Sinemurian_data    <- TJ_data[which(TJ_data$stage=='Sinemurian'),]
Plinesbachian_data <- TJ_data[which(TJ_data$stage=='Pliensbachian'),]
Toarcian_data      <- TJ_data[which(TJ_data$stage=='Toarcian'),]
Aalenian_data      <- TJ_data[which(TJ_data$stage=='Aalenian'),]

fgnumber_list <- unique(TJ_data$FG_Number)

#use vegdist in vegan package, method='bray'#
#need to create a matrix of data
#columns -> stages
#rows -> functional groups

#==== Subsampling protocol ====#
TJ_stages <- stages$stage[57:62] #Carnian and Aalenian too small

fg_data_subbed <- matrix(NA, ncol=length(TJ_stages), nrow=length(unique(TJ_data$FG_Number)))
rownames(fg_data_subbed) <- fgnumber_list
colnames(fg_data_subbed) <- TJ_stages

fg_data_fifths <- matrix(NA, ncol=length(TJ_stages), nrow=length(unique(TJ_data$FG_Number)))
rownames(fg_data_fifths) <- fgnumber_list
colnames(fg_data_fifths) <- TJ_stages

fg_data_ninetyfifths <- matrix(NA, ncol=length(TJ_stages), nrow=length(unique(TJ_data$FG_Number)))
rownames(fg_data_ninetyfifths) <- fgnumber_list
colnames(fg_data_ninetyfifths) <- TJ_stages


iter <- 1000
coll.n <- 30
  
bcd_array <- array(0, dim=c(6,6,iter))

for(m in 1:iter){ 
  
  for(i in 1:length(TJ_stages)){
    
    this.stage <- TJ_stages[i]
    stage.data <- TJ_data[which(TJ_data$stage==this.stage),]
    
    temp.fgdata <- as.data.frame(matrix(NA, nrow=1, ncol=length(fgnumber_list)))
    colnames(temp.fgdata) <- fgnumber_list 
    
      #which collections are in this stage?
      colls <- unique(stage.data$collection_no)
      
      #get random collection numbers 
      coll.sub <- sample(colls, coll.n, replace=TRUE)
      subbed.data <- stage.data[which(stage.data$collection_no %in% coll.sub),]
      
      for(k in 1:ncol(temp.fgdata)){
        
        this.fg <- fgnumber_list[k]
        fg.data <- subbed.data[which(subbed.data$FG_Number==this.fg),]
        
        temp.fgdata[,as.character(this.fg)] <- length(fg.data$genus)
        
      }
      
    fg_data_subbed[,this.stage] <- colMeans(temp.fgdata)
    fg_data_fifths[,this.stage] <- apply(temp.fgdata, 2, quantile, probs=0.05, na.rm=TRUE)
    fg_data_ninetyfifths[,this.stage] <- apply(temp.fgdata, 2, quantile, probs=0.95, na.rm=TRUE)
    
  }
  
  this.braycurt <- as.matrix(vegdist(t(fg_data_subbed), method='bray'))
  bcd_array[,,m] <- this.braycurt
  
  print(paste('Finished Bray Curtis #', m, 'of', iter))
  
}

colnames(bcd_array) <- TJ_stages
rownames(bcd_array) <- TJ_stages

#Now we want to take means of:
#1 - the Hettangian - Aalenian compared to the Rhaetian
#2 - sequential 

rhaetcomp.results <- as.data.frame(matrix(NA, nrow=8, ncol=7))
colnames(rhaetcomp.results) <- c('age', 'label', 'bcd_mean', 'bcd_fifth', 'bcd_ninetyfifth', 'bcd_type', 'raw_subbed')
rhaetcomp.results$age <- stages$mid[56:63]
rhaetcomp.results$label <- c('Rhaetian-Carnian',
                             'Rhaetian-Norian',
                             'Rhaetian-Rhaetian',
                             'Rhaetian-Hettangian',
                             'Rhaetian-Sinemurian',
                             'Rhaetian-Pliensbachian',
                             'Rhaetian-Toarcian',
                             'Rhaetian-Aalenian')
rhaetcomp.results$raw_subbed <- c('raw', rep('subbed',6), 'raw')

#First -
bcd_rhaetian_mean <- c( raw_bcdist['Carnian', 'Rhaetian'],
                        mean(bcd_array['Norian', 'Rhaetian',]),
                        NA,
                        mean(bcd_array['Hettangian','Rhaetian',]),
                        mean(bcd_array['Sinemurian','Rhaetian',]),
                        mean(bcd_array['Pliensbachian','Rhaetian',]),
                        mean(bcd_array['Toarcian','Rhaetian',]),
                        raw_bcdist['Aalenian', 'Rhaetian'])
rhaetcomp.results$bcd_mean <- bcd_rhaetian_mean


bcd_rhaetian_fifths <- c( NA,
                          as.numeric(quantile(bcd_array['Norian','Rhaetian',], probs=0.05)),
                          NA,
                          as.numeric(quantile(bcd_array['Hettangian','Rhaetian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Sinemurian','Rhaetian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Pliensbachian','Rhaetian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Toarcian','Rhaetian',], probs=0.05)),
                          NA)

rhaetcomp.results$bcd_fifth <- bcd_rhaetian_fifths

bcd_rhaetian_ninetyfifths <- c( NA,
                                as.numeric(quantile(bcd_array['Norian','Rhaetian',], probs=0.95)),
                                NA,
                                as.numeric(quantile(bcd_array['Hettangian','Rhaetian',], probs=0.95)),
                                as.numeric(quantile(bcd_array['Sinemurian','Rhaetian',], probs=0.95)),
                                as.numeric(quantile(bcd_array['Pliensbachian','Rhaetian',], probs=0.95)),
                                as.numeric(quantile(bcd_array['Toarcian','Rhaetian',], probs=0.95)),
                                NA)
rhaetcomp.results$bcd_ninetyfifth <- bcd_rhaetian_ninetyfifths

rhaetcomp.results$bcd_type <- 'B-C compared to Rhaetian'
rhaetcomp.results

#Second - sequential 
seqcomp.results <- eqcomp.results <- as.data.frame(matrix(NA, nrow=7, ncol=ncol(rhaetcomp.results)))
colnames(seqcomp.results) <- colnames(rhaetcomp.results)
seqcomp.results$age <-stages$mid[57:63]
seqcomp.results$label <- c('Norian-Canian',
                           'Rhaetian-Norian',
                           'Hettangian-Rhaetian',
                           'Sinemurian-Rhaetian',
                           'Pliensbachian-Sinemurian',
                           'Toarcian-Pliensbachian',
                           'Aalenian-Toarcian')
seqcomp.results$raw_subbed <- c('raw', rep('subbed',5), 'raw')


bcd_sequential_mean <- c( raw_bcdist['Carnian','Norian'],
                          mean(bcd_array['Rhaetian','Norian',]),
                          mean(bcd_array['Hettangian','Rhaetian',]),
                          mean(bcd_array['Sinemurian','Hettangian',]),
                          mean(bcd_array['Pliensbachian','Sinemurian',]),
                          mean(bcd_array['Toarcian','Pliensbachian',]),
                          raw_bcdist['Toarcian', 'Aalenian'])
seqcomp.results$bcd_mean <- bcd_sequential_mean

bcd_sequential_fifths <- c(NA,
                          as.numeric(quantile(bcd_array['Rhaetian','Norian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Hettangian','Rhaetian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Sinemurian','Hettangian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Pliensbachian','Sinemurian',], probs=0.05)),
                          as.numeric(quantile(bcd_array['Toarcian','Pliensbachian',], probs=0.05)),
                          NA
                         )
seqcomp.results$bcd_fifth <- bcd_sequential_fifths

bcd_sequential_ninetyfifths <- c( NA,
                            as.numeric(quantile(bcd_array['Rhaetian','Norian',], probs=0.95)),
                            as.numeric(quantile(bcd_array['Hettangian','Rhaetian',], probs=0.95)),
                            as.numeric(quantile(bcd_array['Sinemurian','Hettangian',], probs=0.95)),
                            as.numeric(quantile(bcd_array['Pliensbachian','Sinemurian',], probs=0.95)),
                            as.numeric(quantile(bcd_array['Toarcian','Pliensbachian',], probs=0.95)),
                            NA
                            )
seqcomp.results$bcd_ninetyfifth <- bcd_sequential_ninetyfifths
seqcomp.results$bcd_type <- 'Sequential B-C'
seqcomp.results

terrestrial_BC.results <- rbind(seqcomp.results, rhaetcomp.results)

save(terrestrial_BC.results, file='Output/terrestrial_braycurtis.RData')

