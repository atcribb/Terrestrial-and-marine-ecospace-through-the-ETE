#Some useful functions to reconstruct TJ terrestrial and marine ecospace richness analyses 

#====== RICHNESS FUNCTIONS ======#

#Function 1a,b - by-collection subsampling
#inputs:  dataset - PDBD dataset
#         stages - each stage in analysis 
#         coll.n - number of collections sampled
#         iter - number of iterations
#         genrich.output - generic richness dataframe for output
#OR       funcrich.output - functional richness dataframe for output
# output dataframes require columns corresponding to stages and number of rows equaling iter
        
#Function 1a
subcollections.genrich <- function(dataset, stages, coll.n, iter, genrich.output){
  
  for(i in 1:length(stages)){
    
    curr.stage <- stages[i]
    stage.data <- dataset[which(dataset$stage==curr.stage),]
    n.colls <- length(unique(stage.data$collection_no))
    colls <- unique(stage.data$collection_no)
    
    for(j in 1:iter){
      
      these.colls <- sample(colls, coll.n, replace=TRUE)
      subbed.colls <- stage.data[which(stage.data$collection_no %in% these.colls),]
      
      #calculate generic richness
      genrich <- length(unique(subbed.colls$genus))
      genrich.output[j,as.character(curr.stage)] <- genrich
      
    }
    
  }
  
  return(genrich.output)
  
}

#Function 1b
subcollections.funcrich <- function(dataset, stages, coll.n, iter, funcrich.output){
  
  for(i in 1:length(stages)){
    
    curr.stage <- stages[i]
    stage.data <- dataset[which(dataset$stage==curr.stage),]
    n.colls <- length(unique(stage.data$collection_no))
    colls <- unique(stage.data$collection_no)
    
    for(j in 1:iter){
      
      these.colls <- sample(colls, coll.n, replace=TRUE)
      subbed.colls <- stage.data[which(stage.data$collection_no %in% these.colls),]
      
      #calculate functional richness
      funcrich <- length(unique(subbed.colls$FG_Number))
      funcrich.output[j,as.character(curr.stage)] <- funcrich
      
    }
    
  }
  
  return(funcrich.output)
  
}

#Function 2a,b - by-stage subsampling
#inputs: dataset - PBDB dataset
#        stages - each stage in analysis
#        occ.n - number of occurrences samples
#        iter - number of iterations
#        genrich.output - generic richness dataframe for output 
#OR      funcrich.output - functional richness dataframe for output
# output dataframes require columns corresponding to stages and number of rows equaling iter 

#Function 2a
substages.genrich <- function(dataset, stages, occ.n, iter, genrich.output){
  
  for(i in 1:length(stages)){
    
    curr.stage <- stages[i]
    stage.data <- dataset[which(dataset$stage==curr.stage),]
    
    for(j in 1:iter){
      
      #how big is the current stage?
      max.x <- nrow(stage.data)
      
      #get random samples numbers
      rand.idx <- sample(rep(1:max.x), occ.n, replace=TRUE)
      subbed.data <- stage.data[rand.idx,]
      
      #count unique genera!
      subbed.gendiv <- length(unique(subbed.data$genus))
      genrich.output[j,as.character(curr.stage)] <- subbed.gendiv
      
      #count unique functional groups!
      # subbed.funcdiv <- length(unique(subbed.data$FG_Number))
      # funcrich.output[j,as.character(curr.stage)] <- subbed.funcdiv
      
    }
  }
  
  return(genrich.output)
  
}

#Function 2b
substages.funcrich <- function(dataset, stages, occ.n, iter, funcrich.output){
  
  for(i in 1:length(stages)){
    
    curr.stage <- stages[i]
    stage.data <- dataset[which(dataset$stage==curr.stage),]
    
    for(j in 1:iter){
      
      #how big is the current stage?
      max.x <- nrow(stage.data)
      
      #get random samples numbers
      rand.idx <- sample(rep(1:max.x), occ.n, replace=TRUE)
      subbed.data <- stage.data[rand.idx,]
      
      #count unique functional groups!
      subbed.funcdiv <- length(unique(subbed.data$FG_Number))
      funcrich.output[j,as.character(curr.stage)] <- subbed.funcdiv

    }
  }
  
  return(funcrich.output)
  
}


#Function 3 - calculate mean, 5th and 95th percentiles for error bars
#inputs: data - dataframe with all x iterations of subsampled data outputs
#        stages - each stage in analysis
#        output - empty dataframe to store column means, 5th percentiles, 95th percentiles, and sd for each stage

calc.quantiles <- function(data, stages, output){
  
  output$mean <- as.numeric(colMeans(data))
  
  fifth.percs <- c()
  for(i in 1:length(stages)){
    fifth.percs[i] <- as.numeric(quantile(data[,stages[i]], 0.05))
  }
  output$fifth <- fifth.percs
  
  ninetyfifth.percs <- c()
  for(i in 1:length(stages)){
    ninetyfifth.percs[i] <- as.numeric(quantile(data[,stages[i]], 0.95))
  }
  output$ninetyfifth <- ninetyfifth.percs
  
  sds <- c()
  for(i in 1:length(stages)){
    sds[i] <- as.numeric(sd(data[,stages[i]]))
  }
  output$sd <- sds
  
  return(output)
  
}

#========== WITHIN FUNCTION-GROUP RICHNESS FUNCTIONS ========#
#Function 3a - Raw generic richness
raw.genrich <- function(data,stages, output){
  
  for(i in 1:length(stages)){
    
    this.stage <- stages[i]
    stage.data <- data[which(data$stage == this.stage),]
    gen.count <- length(unique(stage.data$genus))
    
    output[i] <- gen.count
    
  }
  
  return(output)
  
}

#Function 4a - Raw functional group richness
raw.fgrich <- function(data, stages, output){
  
  for(i in 1:length(stages)){
    
    this.stage <- stages[i]
    stage.data <- data[which(data$stage == this.stage),]
    gen.count <- length(unique(stage.data$FG_Number))
    
    output[i] <- gen.count
    
  }
  
  return(output)
  
}

#===== Functions 5a,b =======#
#Within-functional group occurrences and generich richness subsampling by collections

collsubbed_withinfg_occs <- function(extinction_data, fg_number_list, colls.n, iter,
                                        occs_output){
 
  #get list of collection numbers in the pre-extinction and post-extinction stage 
  colls <- unique(extinction_data$collection_no)
   
  for(i in 1:iter){
    
    #get random collection numbers to sample from
    subcolls <- sample(colls, colls.n, replace=TRUE)
    
    #subset out those random collections
    data_subbed <- extinction_data[which(extinction_data$collection_no %in% subcolls),]
   
    for(j in 1:length(fg_number_list)){
      
      #get data for each functional group
      this.fg <- fg_number_list[j]
      this.fg_data <- data_subbed[which(data_subbed$FG_Number == this.fg),]
      
      #count total genera occurrences of each functional group
      fg.occs <- length(this.fg_data$genus)
    
      #save in dataframe
      occs_output[i,as.character(this.fg)] <- fg.occs
    }
  }
  
  return(occs_output)
  
}

#generich richness
collsubbed_withinfg_genrich <- function(extinction_data, fg_number_list, colls.n, iter,
                                     genrich_output){
  
  #get list of collection numbers in the pre-extinction and post-extinction stage 
  colls <- unique(extinction_data$collection_no)
  
  for(i in 1:iter){
    
    #get random collection numbers to sample from
    subcolls <- sample(colls, colls.n, replace=TRUE)
    
    #subset out those random collections
    data_subbed <- extinction_data[which(extinction_data$collection_no %in% subcolls),]
    
    for(j in 1:length(fg_number_list)){
      
      #get data for each functional group
      this.fg <- fg_number_list[j]
      this.fg_data <- data_subbed[which(data_subbed$FG_Number == this.fg),]
      
      #count total genera occurrences of each functional group
      fg.genrich <- length(unique(this.fg_data$genus))
      
      #save in dataframe
      genrich_output[i,as.character(this.fg)] <- fg.genrich
    }
  }
  
  return(genrich_output)
  
}

