#Plotting output for Figure 4 - Terrestrial FG Relative Abundance 
#detach('package:deeptime', unload=TRUE) #detach deeptime to more straightforwardly deal with overlap in stages datasets
library(divDyn)
library(tidyr)
library(egg)

load('Datasets/TJ_marine_ecospacedata.RData')
TJ_data <- final_marine_rawdat

load('Output/marine_relabund_genrich_df.RData')
load('Output/marine_relabund_occs_df.RData')


data(stages)
TJ_stages <- stages$stage[56:63]
fgnumber_list <- unique(TJ_data$FG_Number)

#==== reshape data into dataframe for ggplot =====#
relabund_occs_df$FunctionalGroup <- fgnumber_list
relabund_occs <- as.data.frame(pivot_longer(relabund_occs_df, cols=1:8, values_to='RelOccs', names_to='Stage'))
relabund_occs$Stage <- factor(relabund_occs$Stage, levels=TJ_stages)
relabund_occs$age <- NA

stagenums <- 56:63
for(i in 1:length(TJ_stages)){
  this.stage <- as.character(TJ_stages[i])
  this.stageno <- stagenums[i]
  relabund_occs[which(relabund_occs$Stage==this.stage),'age'] <- stages$mid[this.stageno]
}

relabund_genrich_df$FunctionalGroup <- fgnumber_list
relabund_genrich <- as.data.frame(pivot_longer(relabund_genrich_df, cols=1:8, values_to='RelRich', names_to='Stage'))
relabund_genrich$Stage <- factor(relabund_genrich$Stage, levels=TJ_stages)
relabund_genrich$age <- NA

stagenums <- 56:63
for(i in 1:length(TJ_stages)){
  this.stage <- as.character(TJ_stages[i])
  this.stageno <- stagenums[i]
  relabund_genrich[which(relabund_genrich$Stage==this.stage),'age'] <- stages$mid[this.stageno]
}


relabund_occs$Stage <- factor(relabund_occs$Stage, levels=TJ_stages)
relabund_genrich$Stage <- factor(relabund_genrich$Stage, levels=TJ_stages)

fgcols <- read.csv('Datasets/tj_relabund_terrestrialcols.csv')
fg.levels <- as.character(fgcols$fg)
fg.colors <- as.character(fgcols$color)

relabund_genrich$FunctionalGroup <- factor(relabund_genrich$FunctionalGroup)

names(fg.colors) <- levels(factor(levels(relabund_genrich$FunctionalGroup)))

#ggplot
periods.edit <- deeptime::periods
periods.edit[6, 'max_age'] <- 232.5 
periods.edit[5, 'min_age'] <- 172.2
stages.edit <- deeptime::stages
stages.edit[50, 'max_age'] <- 232.5
stages.edit[43, 'min_age'] <- 172.2

propoccs <- ggplot(data=relabund_occs) +
  geom_area(aes(x=age, y=as.numeric(RelOccs), fill=as.character(FunctionalGroup))) +
  scale_fill_manual(name='FunctionalGroup', values=fg.colors) +
  scale_x_reverse('Age (Ma)', expand=c(0,0)) +
  scale_y_continuous('Relative Abundance (occurrences)', expand=c(0,0)) +
  theme_light() +
  theme(
    axis.title.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    legend.position='none'
  )

propoccs

proprich <- ggplot(data=relabund_genrich) +
  geom_area(aes(x=age, y=as.numeric(RelRich), fill=as.character(FunctionalGroup))) +
  scale_fill_manual(name='Functional Group #', values=fg.colors) +
  scale_x_reverse('Age (Ma)', expand=c(0,0)) +
  scale_y_continuous('Relative Abundance (generic richness)', expand=c(0,0)) +
  coord_geo(dat=list(stages.edit, periods.edit), size='auto',
            xlim=c(232.5, 172.2), ylim=c(0, 1), pos=list('b', 'b'), abbrv=list(TRUE, TRUE), expand=TRUE) +
  theme_light() +
  theme(legend.position='right')
proprich

ecospace_relabund <- ggarrange(propoccs, proprich, ncol=1)


