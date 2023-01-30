#Plotting output for TJ marine and terrestrial generic and functional richness
library(ggplot2)
library(deeptime)
library(egg)
library(ggfittext)

#load in marine data
load('Output/marine_collsubbed_functionalrichness.RData')
marine_collsub_func <- collsubfuncdiv.final
load('Output/marine_collsubbed_genericrichness.RData')
marine_collsub_gen <- collsubgendiv.final

#load in terrestrial data
load('Output/terrestrial_collsubbed_functionalrichness.RData')
terrestrial_collsub_func <- collsubfuncdiv.final
load('Output/terrestrial_collsubbed_genericrichness.RData')
terrestrial_collsub_gen <- collsubgendiv.final


#===== plotting output ======#
periods.edit <- deeptime::periods
periods.edit[6, 'max_age'] <- 237
periods.edit[5, 'min_age'] <- 170.3

#Marine generic richness
marine_gr <- ggplot() +
  geom_line(data=marine_collsub_gen, aes(x=age_mid, y=mean), linetype='dashed') +
  geom_point(data=marine_collsub_gen, aes(x=age_mid, y=mean), shape=19) +
  geom_errorbar(data=marine_collsub_gen, aes(x=age_mid, ymin=fifth, ymax=ninetyfifth), width=0.5) +
  scale_x_reverse('Age (Ma)') +
  ylab('Generic Richness') +
  coord_geo(dat=list('stages', 'periods'), xlim=c(237, 170.3), ylim=c(0, 1200), pos=list('b', 'b'), abbrv=list(TRUE, TRUE)) +
  theme_classic()
marine_gr


#Marine functional richness
marine_fgr <- ggplot() +
  geom_line(data=marine_collsub_func, aes(x=age_mid, y=mean), linetype='dashed') +
  geom_point(data=marine_collsub_func, aes(x=age_mid, y=mean), shape=19) +
  geom_errorbar(data=marine_collsub_func, aes(x=age_mid, ymin=fifth, ymax=ninetyfifth), width=0.5) +
  scale_x_reverse('Age (Ma)') +
  ylab('Functionaol Group Richness') +
  coord_geo(dat=list('stages', 'periods'), xlim=c(237, 170.3), ylim=c(0, 1200), pos=list('b', 'b'), abbrv=list(TRUE, TRUE)) +
  theme_classic()
marine_fgr


#Terrestrial generic richness
terrestrial_gr <- ggplot() +
  geom_line(data=terrestrial_collsub_gen, aes(x=age_mid, y=mean), linetype='dashed') +
  geom_point(data=terrestrial_collsub_gen, aes(x=age_mid, y=mean), shape=19) +
  geom_errorbar(data=terrestrial_collsub_gen, aes(x=age_mid, ymin=mean-sd, ymax=mean+sd), width=0.5) +
  scale_x_reverse('Age (Ma)') +
  ylab('Generic Richness') +
  coord_geo(dat=list('stages', 'periods'), xlim=c(237, 170.3), ylim=c(0, 350), pos=list('b', 'b'), abbrv=list(TRUE, TRUE)) +
  theme_classic()
terrestrial_gr


#Terrestrial functional richness
terrestrial_fgr <- ggplot() +
  geom_line(data=terrestrial_collsub_func, aes(x=age_mid, y=mean), linetype='dashed') +
  geom_point(data=terrestrial_collsub_func, aes(x=age_mid, y=mean), shape=19) +
  geom_errorbar(data=terrestrial_collsub_func, aes(x=age_mid, ymin=mean-sd, ymax=mean+sd), width=0.5) +
  scale_x_reverse('Age (Ma)') +
  ylab('Generic Richness') +
  coord_geo(dat=list('stages', 'periods'), xlim=c(237, 170.3), ylim=c(0, 350), pos=list('b', 'b'), abbrv=list(TRUE, TRUE)) +
  theme_classic()
terrestrial_fgr


ggarrange(marine_gr, terrrestrial_gr,
          marine_fgr, terrestrial_fgr,
          ncol=2, nrow=2)




