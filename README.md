# Terrestrial-and-marine-ecospace-through-the-ETE
Datasets and code for the manuscript "Contrasting terrestrial and marine ecospace dynamics after the end-Triassic mass extinction event" by Alison T. Cribb(1*+), Kiersten K. Formoso(1+), C. Henric Woolley(1,2), James Beech (1), Shannon Brophy(1), Paul Byrne (1,2), Victoria C. Cassady(1), Amanda L. Godbold(1), Ekaterina Larina (1,3), Peter Maxeiner (1), Yun-Hsin Wu (2), Frank A. Corsetti(1), and David J. Bottjer (1)

*1: Department of Earth Sciences, University of Southern California, Los Angeles, California, USA
*2: The Dinosaur Institute, Natural History Museum of Los Angeles County, Los Angeles, California, USA
*3: Department of Geological Sciences, Jackson School of Geosciences, University of Texas at Austin, Austin, Texas, USA

The purpose of these analyses is to reconstruct comparative trends in marine and terrestrial functional ecology across the end-Triassic mass extinction event. The analyses scripts utilize the datasets compiled by the manuscript's authors, which assign ecospace functional groups to data from the PaleoDB. The code in this github repository will produce all of the outputs necessary to recreate the figures in the manuscript's main text. Analyses for the suppleentary material are not explicitly given here, but they can be easily reconstructed from the output files. The repository contains four directories: <b> 1) Datasets </b> - .RData files for the PlaeoDB data with ecospace assignments, which is used in every analysis scripts, and .csv files for the colors used in the relative abundance figures. <b> Functions - </b> R script of useful functions to calculate richness, with various subsampling protocols. <b> Analyses </b> - Scripts to reconstruct analyses presented in the mansucript. <b> Figures </b> - Scripts to reproduce Figures 2-6 in the main text of the manuscript.

Data intput from the .RData files is needed in all analysis scripts. To easily run these scripts, it is recommended to download the .zip of this repository, which you can use as the working directory when running the scripts in R. The analyses scripts will create an /Output folder to save the results, which will be read from the Plotting_Output scripts. 

Datasets are provided as .RData files for faster loading times, but the corresponding .csv files containing the same data are supplied as electronic supplementary files along with the manuscript. 

+Correspoding authors: cribb@usc.edu, formoso@usc.edu

*The R scripts in this repository were created by A.T.C. Please contact Alison Cribb (cribb@usc.edu) for any questions or if you plan to use and edit these scripts in any way.

# Datasets
There are two .RData files in <b>Datasets</b> that contain the PaleoDB data with ecospace assignments to each taxonomic occurrence:
* TJ_marine_ecospacedata.RData 
* TJ_terrestrial_ecospacedata.RData

Additionally, there are two .csv files that contain the colours assigned to each functional group that recreate the relative abundance Figures 3-4. These are optional, as you can always choose your own colours or use R's default -- but they are very useful for getting a cleaner figure.
* tj_relabund_marinecols.csv
* tj_relabund_terrestrialcols.csv


# Functions
One script contains several uesful functions for reconstructing subsampled generic and functional richness:
* TJ_functions.R
The analyses presented in the manuscript specificially use the subcollections.funcrich() and subcollections.genrich() functions for subsampling, and a hand calc.qunatiles() functional to calculate the final mean values and confidence intervals. 

There are a number of other handy functions in this script which are not used in the final version of the manuscript. These include subsampling protocols for subsampling by stage (rather than by collection) and subsampling protocols for within-Functional Group dynamics.

This script of functions is used throughout the  <b>Analyses</b> scripts, so be sure to have it loaded into your environment before attempting to run the Analyses scripts where they are utilized.


# Analyses
The following pakcages are required to run the **Analyses** scripts:
* divDyn
* vegan

There are eight analyses scripts:
* Figure2A_Marine_Richness.R
* Figure2B_Terrestrial_Richness.R
* Figure3_Marine_FGRelativeAbundance.R
* Figure3_Terrestrial_FGRelattiveAbundance.R
* Figure5A_Marine_withinFGextinction.R
* Figure5B_Terrestrial_withinFGextinction.R
* Figure6A_Marine_BrayCurtis.R
* Figure6B_Terrestrial_BrayCurtis.R

Each script is named for the figure in the manuscript that the analyses corresponds to, the dataset used (marine or terrestrial), and a brief description of the analysis.

Each script will produce an output .RData file in an /Output folder in your working directory. These will be used in the <b>Plotting_output</b> scripts, so do not rename them unless you also edit the **Plotting_output** scripts accordingly.


# Plotting_output 
The following packages are required to run the **Plotting_output** scripts:
* deeptime
* ggplot2
* egg

The following scripts will produce the results presented in the manuscript:
* Figure2_Plot_Richness.R - This script will produce four figure: 1) Marine generic richness, 2) Marine fucntional richness, 3) Terrestrial functional richness, 4) Terrestrial generic richness. Note that the final figure combines generic and functional richness into one plot to save space, but it is a bit easier to visualize the data in R when these results are all plotted seperately. Output data is from **Analyses** scripts Figure2A_Marine_Richness.R and **Analyses** scripts Figure 2B_Terrestrial_Richness.R
* Figure3_Plot_Marine_FGRelativeAbundance.R - This script will produce the functional group relative abundance figures in Figure 3. Output data utilized is ultimately the mean results from the subsampling protocol, as it is difficult to visualize this data with error bars. Use tj_relabund_marinecols.csv from **Datasets** for helful colour assignments to the marine functional groups.
* Figure4_Plot_Terrestrial_FGRelativeAbundance.R - Same thing as above, but for terrestrial. Use the tj_relabunud_terrestrialcols.csv from **Datasets**.
* Figure5_withinFGext.R - This script will plot the exinction severity in Figure 5. Output from the marine is from Figure5A_Marine_withinFGextinction.R and Figure 5B_Terrestrial_withinFGextinction.R
* Figure6_BrayCurtis.R - This script will plot the Bray-Curtis dissimilarity indices calculated in the **Analyses** scripts FigureGA_Marine_BrayCurtis.R and Figure6B_Terrestrial_BrayCurtis.R. 

Note that these figures will not be perfect replicas of the final figures in the manuscript. These scripts will ultimately give you more results than the manuscript covers -- for example, more sequential points are plotted for the Bray-Curtis figures (Figure 6) in the scripts than in the final manuscript figure, and the terrestrial results may contain raw Carnian and Aalenian data, which are not presented in the final manuscript due to lack of ability to subsample. Figures have also been slightly edited in illustrator for aesthetic purposes and improved clarity. 

