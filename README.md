
Carnivoran Dentition & Ordinal Diet Rankings 
=========

## Predicting multivariate ecology using phenotypic data yields novel insights into the diets of cryptic and extinct taxa

GitHub repo for the manuscript. All scripts necessary to perform the analyses and generate the plots from this manuscript are found here.

## Required Packages:

- `pacman`, `here`, `brms`, `cmdstanr`, `tidyverse`, `tidybayes`, `phytools`, `geiger`, `mclust`, `polycor`, `NbClust`, `ggstar`, `janitor`, `caret`, `scico`, `furrr` (for parallel computing)

- All of these packages should be available in CRAN. See the brms [FAQ](https://github.com/paul-buerkner/brms#faq) for details on installing Stan, cmndstanr, and brms. [pacman](http://trinker.github.io/pacman/vignettes/Introduction_to_pacman.html) makes it easy to install and load multiple packages. 

## Layout:

- The contents of this repo is split up into 3 main directories:`Code`, `Data`, and `Plots`. We use the awesome package "[here](https://here.r-lib.org/)" to deal with the repo structure. Currently anyone can download the repo ***as is*** and run the code without dealing with paths (if all packages are installed).

## **`Data`** 

- The data directory contains all of the raw data used in the initial models, and the data generated from the model outputs. The `Master_Data.txt` is the primary source for dental metrics, body mass, dietary rankings for all extant species including those that lack diet rankings (the "cryptic" species we use for prediction later), and the discrete categories from the four diet categorization schemes we use for comparative purposes (see Figure 2 in the text). We also store outputs in this directory because **every output .csv file is later called as an input**, either for additional analyses, predictions, or as input data for a plot. 

## **`Code`** 

#### Prior Predictive Checks and Model Estimation
- All of the models, prior and posterior checking, predictions, data wrangling, etc. are found in this directory.

- To determine the parameters for each prior distribution on the response variables, we ran prior predictive checks. Similar to the model scripts, these are in the `Code/Prior_Pred_Checks/` directory and labeled `FOODITEM_Prior_Check.Rmd`. The script `Prior_Pred_Checks_All.Rmd` runs all 13 of these scripts, and stores the outputs in the `Code/Prior_Pred_Checks/prior_pred_outputs` directory. **Figure_S2_Prior_Pred_Checks.pdf**, stored in the `Plots dir`, shows the prior distributions that we used for each tooth metric for each food item. Note that we used a $N$(0,1) prior on all of our predictor variables, as they are all scaled to a mean of 0 and an sd of 1, and this loosely regularizing prior keeps the models in check but still allows for large effect sizes. 

- All of our ordinal **brms** models use one of three priors on the response variable (the ranks): A Normal distribution, a Student-$T$ distribution, and a  Dirichlet Prior on the threshold (aka cutpoint) values. The Dirichet prior script is found in `Dirichlet_Prior.R`. We used the Stan code described in [this Stan Discourse post](https://discourse.mc-stan.org/t/dirichlet-prior-on-ordinal-regression-cutpoints-in-brms/20640/3), written by [Staffan Betnèr](https://github.com/StaffanBetner), to create this prior. This code was generated from and informed by the case study by [Michael Betancourt](https://betanalpha.github.io/) found [here](https://betanalpha.github.io/assets/case_studies/ordinal_regression.html). We set the mean intercept	$\phi$ to 0 rather than have the model estimate it, which performed better in our simulations. See comment #9 in the discourse post.

- The bulk of our results are from the multilevel models generated in [**brms**](https://github.com/paul-buerkner/brms). The scripts containing the models for each food item are in the `Code/Models/` directory and labeled `Mods_FOODITEM.Rmd`. Each script contains 15 models. To run all of these, visit the script `Code/D_All_Models.Rmd`, which wrangles the data and calls each food item script individually. ***This Must Be Run Before the Plotting or Prediction Scripts*** because the brms model objects are necessary for those. The outputs of the models will be stored in the `Code/Models/mod_outputs` directory (see below). These are imported later for predictive and plotting scripts (it's better than running all the models again).

- After running the models, we estimated the LOO model weights of each model using stacking. We first calculated the weights for each model for each metric (3 per metric, each with a different prior on the response, see above). Then we took the models with the highest weight for each metric (n=5) and estimated the model weights for these. This is all in the `Mods_FOODITEM.Rmd` scripts. The model weights are collected iteratively as each food item file runs in `Code/D_All_Models.Rmd`, and the weights are stored in the file `Data/Test_weights_all.csv`. 

- The parameter estimates of all the models with a model weight >0 are found in `Data/Supp_model_results_table.csv`, and kept as a supporting file in the manuscript. The script for generating this table is called `Code/Model_Results_Supp_Table.Rmd`. There is a lot of data wrangling involved to get the table formatted like it is. 

#### Model Posterior Validation & Accuracy Checks

- We performed Posterior Predictive Checks on every model that has a loo model weight > 0. The model outputs are stored in the `Code/Models/mod_outputs` directory. The `posterior_pred_plots.Rmd` script calls these and plots them in the same way as the prior predictive plots. **Figure_S3_Posterior_Pred_Checks.pdf** in the `Plots` dir shows the results, which look quite good (mean is mostly centered on empirical values with little uncertainty on most food items). 

- We checked the accuracy of our model predictions by comparing them to the empirical ranks for each species. This script is in `Code/Accuracy_Predictions.Rmd`, and the results are reported in Table 4 of the text and are saved as `Data/Accuracy_Table.csv`. We report these results as percentages of estimates that are the exact rank, and within 1 rank (which we consider a good estimate in this ranking scale). We estimate 1000 draws from the posterior of each model, then model average over them using the LOO weights, then estimate the accuracy of the predictions. `Data/Prediction_Table.csv` gives the mean predictions from the 1000 samples, and `Data/Accuracy_Table.csv` provides the values in table 4. The `Code/Accuracy_Predictions.Rmd` script contains a few custom functions, some parallel computing, and is time intensive. Reach out with questions :)

- Our third method of validating the predictive power of our models is interrogating our predictive accuracy and model fit using leave-one-out cross validation. There is a lot of information on CV, LOO CV, and the Pareto-Smoothed-Importance-Sampling (PSIS) method of LOO approximation out there (try starting with this [Excellent FAQ Page](https://mc-stan.org/loo/articles/online-only/faq.html) from the `LOO` package). In addition to model comparison, which we did above by using model weights generated from LOO scores, we are interested in the stability of our estimates within individual models. If a species is removed from the analysis, does that alter the prediction of other species? The Pareto-$K$ diagnostic score answers that. If, when the sample is removed from the analysis, the posterior changes substantially, it produces a high Pareto-$K$ estimate, and a small Pareto-$K$ means that the estimate is stable without the particular sample. We gathered these scores in the `Code/Accuracy_Predictions.Rmd` script described above, and they are reported along side the additional predictions in the `Data/Prediction_Table.csv` file. 

#### Posterior Predicitons of Extant Data-Rich, Data-Deficient, and Fossil Taxa

- We generate model_averaged predictions of the Fossil and Data-Deficient Taxa, as well as the Data-Rich Extant Taxa, in the script `Code/Weighted_Predictions.Rmd`. This generates four `Data` files:
    1.  `Data/Model_Averaged_Post_Sims.csv` - 1000 posterior probability draws of the model averaged probabilities for each species/food item from the extant, data rich taxa. Columns are the probabilities of the 4 rankings, plus a weighted importance score for each row. *Warning, >1m rows.* 
    2.  `Data/Extant_Predictions_Summary.csv` - The means of each of the 1000 draws from the `Model_Averaged_Post_Sims.csv` data frame. 13 * 89 = 1157 rows.
    3. `Data/Model_Averaged_Post_Sims_Crypt_Fos.csv` - The same as above, but for the data deficient extant and fossil taxa. 
    4. `Data/Crypt_Fos_Predictions_Summary.csv` - same as 2, but for the data deficient extant and fossil taxa.  
- The summary files are used to generate figures 4 & 5, and some of the values are reported in the text. The larger `Sims` files are used in the nearest neighbor predictions below. This script uses several custom functions to perform the tasks and makes use of [`tidybayes`](http://mjskay.github.io/tidybayes/articles/tidybayes.html). 

#### Nearest Neighbor Calculations



############

Weighted Predictions New is the next thing
Also the model figures! Those should be above validation? Or a separate file below (maybe this)


####
OLD Past THis
####
- The `Weighted_Predictions_Fig3_Fig4.Rmd` script generates weighted posterior predictions and weighted averages for the extant-with-data, cryptic and fossil taxa, and produces Figures 3 & 4. 

- The `Diet_Space_Ordination_and_Clustering.Rmd` script contains the polychoric PCA analysis that generates a multivariate diet space, the clustering analysis that generates Figure 1B, and the diet space projection of cryptic and fossil taxa used to make Table 4.

- The remainder of the scripts are for plotting (plot name/number included in the title), or tables generates in [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) as `.tex` and `.png` files. The plots are stored in the `Plots` directory.

## **`mod_outputs`** 

- This directory stores the model outputs generated in the 13 model scripts called in the `Code/D_All_Models.Rds` file. brms stores the model objects as `.rds` files. These can be loaded via `brms:brm()` or with the `readRds()` command, which we use a lot in other scripts here. 

- This directory will be empty in the Dryad repo to save space (all 67 model outputs = 367Mb in size), but running the `Code/D_All_Models.Rds` script will populate it. 



## **`Plots`** 

- All of the output plots are stored here. There are both `.pdf`s and `.png`s of most of the plot files. Additionally, several table outputs are stored here as they are rendered in the package [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) into figures and `.tex` files. 


