library(ggplot2)
library(deeptime)
library(egg)

load('Output/marine_braycurtis.RData')
load('Analyses/output/marine_braycurtis_041222.RData')

#ggplot
periods.edit <- deeptime::periods
periods.edit[6, 'max_age'] <- 237.0 
periods.edit[5, 'min_age'] <- 170.3
stages.edit <- deeptime::stages
stages.edit[50, 'max_age'] <- 237.0
stages.edit[43, 'min_age'] <- 170.3

#==== marine plotting output =====#
marine_bc <- ggplot(data=marine_BC.results) +
  geom_vline(xintercept=201.3, linetype='dotted', color='darkred') +
  geom_line(aes(x=age, y=bcd_mean, linetype=bcd_type)) +
  geom_point(aes(x=age, y=bcd_mean, shape=bcd_type), size=2, fill='white') +
  geom_errorbar(aes(x=age, ymin=bcd_fifth, ymax=bcd_ninetyfifth), width=0.5) +
  scale_shape_manual(values=c(8,21)) +
  scale_linetype_manual(values=c('twodash', 'longdash')) +
  scale_x_reverse('Age (Ma)', expand=c(0,0)) +
  scale_y_continuous('Bray-Curtis dissimilarity index', expand=c(0,0)) +
  coord_geo(dat=list(stages.edit, periods.edit), size='auto',
            xlim=c(237.0, 170.3), ylim=c(0, 1), pos=list('b', 'b'), abbrv=list(TRUE, TRUE), expand=TRUE) +
  theme_light() +
  theme(
    legend.position='top',
    legend.title=element_blank()
  )
marine_bc

#==== terrestrial plotting output =====#
terrrestrial_bc <- ggplot(data=terrestrial_BC.results) +
  geom_errorbar(aes(x=age, ymin=bcd_fifth, ymax=bcd_ninetyfifth), width=0.5) +
  geom_vline(xintercept=201.3, linetype='dotted', color='darkred') +
  geom_line(aes(x=age, y=bcd_mean, linetype=bcd_type)) +
  geom_point(aes(x=age, y=bcd_mean, shape=bcd_type), fill='white', size=2) +
  #scale_fill_manual(values='black', 'white') +
  scale_shape_manual(values=c(8,21)) +
  scale_linetype_manual(values=c('twodash', 'longdash')) +
  scale_x_reverse('Age (Ma)', expand=c(0,0)) +
  scale_y_continuous('Bray-Curtis dissimilarity index', expand=c(0,0)) +
  coord_geo(dat=list(stages.edit, periods.edit), size='auto',
            xlim=c(237.0, 170.3), ylim=c(0, 1), pos=list('b', 'b'), abbrv=list(TRUE, TRUE), expand=TRUE) +
  theme_light() +
  theme(
    legend.position='top',
    legend.title=element_blank()
  )
terrestrial_bc

ggarrange(marine_bc, terrestrial_bc, ncol=2)

