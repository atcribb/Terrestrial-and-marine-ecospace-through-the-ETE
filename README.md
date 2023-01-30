# Terrestrial-and-marine-ecospace-through-the-ETE
Datasets and code for the manuscript "Contrasting terrestrial and marine ecospace dynamics after the end-Triassic mass extinction event" by Alison T. Cribb(1*+), Kiersten K. Formoso(1+), C. Henric Woolley(1,2), James Beech (1), Shannon Brophy(1), Paul Byrne (1,2), Victoria C. Cassady(1), Amanda L. Godbold(1), Ekaterina Larina (1,3), Peter Maxeiner (1), Yun-Hsin Wu (2), Frank A. Corsetti(1), and David J. Bottjer (1)

1: Department of Earth Sciences, University of Southern California, Los Angeles, California, USa
2: The Dinosaur Institute, Natural History Museum of Los Angeles County, Los Angeles, California, USA
3: Department of Geological Sciences, Jackson School of Geosciences, University of Texas at Austin, Austin, Texas, USA

The purpose of these analyses is to reconstruct comparative trends in marine and terrestrial functional ecology across the end-Triassic mass extinction event. The analyses scripts utilize the datasets compiled by the manuscript's authors, which assign ecospace functional groups to data from the PaleoDB. The code in this github repository will produce all of the outputs necessary to recreate the figures in the manuscript's main text. Analyses for the suppleentary material are not explicitly given here, but they can be easily reconstructed from the output files. The repository contains four directories: <b> 1) Datasets </b> - .RData files for the PlaeoDB data with ecospace assignments, which is used in every analysis scripts, and .csv files for the colors used in the relative abundance figures. <b> Functions - </b> R script of useful functions to calculate richness, with various subsampling protocols. <b> Analyses </b> - Scripts to reconstruct analyses presented in the mansucript. <b> Figures </b> - Scripts to reproduce Figures 2-5 in the main text of the manuscript.

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

# Analyses

# Plotting_outputs 
