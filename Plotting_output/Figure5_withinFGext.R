library(egg)
library(ggplot2)

load('Analyses/output/marine_fg_ext_data_subbed_allFGs_093022.RData')
load('Output/marine_fg_ext_data_subbed.RData')

#MARINE
#Extinction severity in Figure 5A
marinecol <- 'lightblue'

marine_fg_extinction <- ggplot(data=fg_ext_data_subbed, aes(x=as.character(FunctionalGroup), y=ExtRate)) +
  geom_col(aes(x=as.character(FunctionalGroup), y=ExtRate), fill=marinecol, color='black', size=0.25, width=0.5) +
  geom_errorbar(data=fg_ext_data_subbed, aes(ymin=Ext_5, ymax=Ext_95), width=0.2, position=position_dodge(0.9)) +
  scale_color_manual(values=marinecol) +
  scale_y_continuous(expand=c(0,0)) +
  scale_x_discrete(expand=c(0.025,0)) +
  theme_classic() +
  xlab('Functional Group') +
  ylab('Extinct Genera (%)') +
  theme(
    axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))
marine_fg_extinction

#TERRESTRIAL
#Extinction severity in Figure 5B
terr.col <- 'darkseagreen4'

terrestrial_fg_extinction <- ggplot(data=fg_ext_data_subbed, aes(x=as.character(FunctionalGroup), y=ExtRate)) +
  geom_col(aes(x=as.character(FunctionalGroup), y=ExtRate), fill=terr.col, color='black', size=0.25, width=0.5) +
  geom_errorbar(data=fg_ext_data_subbed, aes(ymin=Ext_5, ymax=Ext_95), width=0.2, position=position_dodge(0.9)) +
  scale_color_manual(values=land.col) +
  scale_y_continuous(expand=c(0,0)) +
  scale_x_discrete(expand=c(0.025,0)) +
  theme_classic() +
  xlab('Functional Group') +
  ylab('Extinct Genera (%)') +
  theme(
    axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))
terrestrial_fg_extinction

ggarrange(marine_fg_extinction, terrestrial_fg_extinction, ncol=1)







