
# Carnivoran Dentition & Ordinal Diet Rankings 
=========

## Predicting multivariate ecology using phenotypic data yields novel insights into the diets of cryptic and extinct taxa

GitHub repo for the manuscript. All scripts necessary to perform the analyses and generate the plots from this manuscript are found here.

## Required Packages:

- pacman, tidyverse, tidybayes, brms, cmdstanr, phytools, geiger, mclust, polycor, NbClust, ggstar, janitor, here, caret

- All of these packages should be available in CRAN. See the brms [FAQ](https://github.com/paul-buerkner/brms#faq) for details on installing Stan, cmndstanr, and brms. [pacman](http://trinker.github.io/pacman/vignettes/Introduction_to_pacman.html) makes it easy to install and load multiple packages. 

## Layout:

- The contents of this repo is split up into 3 main directories:`Code`, `Data`, and `Plots`. We use the awesome package called  "[here](https://here.r-lib.org/)" to deal with the repo structure. Currently anyone can download the repo ***as is*** and run the code without dealing with paths (if all packages are installed).

## **`Code`** 

#### Prior Predictive Checks and Model Estimation
- All of the models, prior and posterior checking, predictions, data wrangling, etc. are found in this directory.

- The bulk of our results are from the multilevel models generated in [**brms**](https://github.com/paul-buerkner/brms). The scripts containing the models for each food item are in the `Code/Models/` directory and labeled `Mods_FOODITEM.Rmd`. Each script contains 15 models. To run all of these, visit the script `Code/D_All_Models.Rmd`, which wrangles the data and calls each food item script individually. ***This Must Be Run Before the Plotting or Prediction Scripts*** because the brms model objects are necessary for those. The outputs of the models will be stored in the `Code/Models/mod_outputs` directory (see below). These are imported later for predictive and plotting scripts (rather than running the whole thing again).

- All of our ordinal **brms** models use one of three priors on the response variable (the ranks): A Normal distribution, a Student-$T$ distribution, and a  Dirichlet Prior on the threshold (aka cutpoint) values. The Dirichet prior script is found in `Dirichlet_Prior.R`. We used the Stan code described in [this Stan Discourse post](https://discourse.mc-stan.org/t/dirichlet-prior-on-ordinal-regression-cutpoints-in-brms/20640/3), written by [Staffan Betnèr](https://github.com/StaffanBetner), to create this prior. This code was generated from and informed by the case study by [Michael Betancourt](https://betanalpha.github.io/) found [here](https://betanalpha.github.io/assets/case_studies/ordinal_regression.html). We set the mean intercept	$\phi$ to 0 rather than have the model estimate it, which performed better in our simulations. See comment #9 in the discourse post.

- To determine the parameters for each prior distribution on the response variables, we ran prior predictive checks. Similar to the model scripts, these are in the `Code/Prior_Pred_Checks/` directory and labeled `FOODITEM_Prior_Check.Rmd`. The script `Prior_Pred_Checks_All.Rmd` runs all 13 of these scripts, and stores the outputs in the `Code/Prior_Pred_Checks/prior_pred_outputs` directory. **Figure_S2_Prior_Pred_Checks.pdf**, stored in the `Plots dir`, shows the prior distributions that we used for each tooth metric for each food item. Note that we used a $N$(0,1) prior on all of our predictor variables, as they are all scaled to a mean of 0 and an sd of 1, and this loosely regularizing prior keeps the models in check but still allows for large effect sizes. 

#### Posterior Model Verification

- We performed Posterior Predictive Checks on every model that was assigned a loo model weight > 0. The model outputs are stored in the `Code/Models/mod_outputs` directory. The `posterior_pred_plots.Rmd` script calls these and plots them in the same way as the prior predictive plots. **Figure_S3_Posterior_Pred_Checks.pdf** in the `Plots` dir shows the results, which look quite good (mean is mostly centered on empirical values with little uncertainty on most food items). 

- We checked the accuracy of our model predictions compared to the empirical ranks for each species. This script is in `Code/Accuracy_Predictions.Rmd` and the results are reported in Table 4 of the text. We report these results as percentages of estimates that are the exact rank, and within 1 rank, which we consider a good estimate. We estimate 1000 draws from the posterior of each model, then model average over them using the LOO weights, then estimate the accuracy of the predictions. `Data/Prediction_Table.csv` gives the mean predictions from the 1000 samples, and `Data/Accuracy_Table.csv` provides the values in table 4. The `Code/Accuracy_Predictions.Rmd` script contains a lot of custom functions, some parallel computing, and is time intensive. Reach out with questions :)

- Our third means of validating the predictive power of our models is by confirming that the LOO cross validation provides acceptable results. There is a lot of information on CV and LOO CV out there (try starting with this [Excellent FAQ Page](https://mc-stan.org/loo/articles/online-only/faq.html)!) In addition to model comparison, which we did using model weights generated from LOO scores, we are interested in the stability of our estimates. If a species is removed from the analysis, does that alter the prediction? The Pareto-$K$ diagnostic score reports just that. If, when the sample is removed from the analysis, the posterior changes, then there is a high Pareto-$K$, and a small Pareto-$K$ means that the estimate is stable without the particular sample. We gathered these scores in the `Code/Accuracy_Predictions.Rmd` script described above, and they are reported along side the additional predictions in the `Data/Prediction_Table.csv` file. 

############

Weighted Predictions New runs 


####
OLD Past THis
####
- The `Weighted_Predictions_Fig3_Fig4.Rmd` script generates weighted posterior predictions and weighted averages for the extant-with-data, cryptic and fossil taxa, and produces Figures 3 & 4. 

- The `Diet_Space_Ordination_and_Clustering.Rmd` script contains the polychoric PCA analysis that generates a multivariate diet space, the clustering analysis that generates Figure 1B, and the diet space projection of cryptic and fossil taxa used to make Table 4.

- The remainder of the scripts are for plotting (plot name/number included in the title), or tables generates in [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) as `.tex` and `.png` files. The plots are stored in the `Plots` directory.

## **`mod_outputs`** 

- This directory stores the model outputs generated in the 13 model scripts called in the `Code/D_All_Models.Rds` file. brms stores the model objects as `.rds` files. These can be loaded via `brms:brm()` or with the `readRds()` command, which we use a lot in other scripts here. 

- This directory will be empty in the Dryad repo to save space (all 67 model outputs = 367Mb in size), but running the `Code/D_All_Models.Rds` script will populate it. 


## **`Data`** 

- The data directory contains all of the raw data used in the initial models, and the data generated from the model outputs. The `Master_Data.txt` is the primary source for dental metrics, body mass, and dietary rankings for all extant species, including those that lack diet rankings (the "cryptic" species we use for prediction later). We also store results in this directory because **every output is called later as an input**, either for additional analyses, predictions, or as input data for a plot. 

## **`Plots`** 

- All of the output plots are stored here. There are both `.pdf`s and `.png`s of most of the plot files. Additionally, several table outputs are stored here as they are rendered in the package [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) into figures and `.tex` files. 


