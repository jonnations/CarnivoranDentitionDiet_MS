Carnivoran Dentition & Ordinal Diet Rankings 
=========

## Bayesian prediction of multivariate ecology from phenotypic data yields novel insights into the diets of extant and extinct taxa

GitHub repo for the manuscript. All scripts necessary to perform the analyses and generate the plots from this manuscript are found here. 

This repo is also in Dryad at https://doi.org/10.5061/dryad.pc866t1rg, and can be downloaded directly from there. The Dryad repo contains a link to a zip file of this GitHub repo, which is officially stored in Zenodo at https://doi.org/10.5281/zenodo.7429701.

## Required Packages:

- `pacman`, `here`, `brms`, `cmdstanr`, `tidyverse`, `tidybayes`, `phytools`, `geiger`, `mclust`, `polycor`, `NbClust`, `ggstar`, `janitor`, `caret`, `scico`, `paletteer`, & `furrr` (for parallel computing)

- All of these packages should be available in CRAN. See the brms [FAQ](https://github.com/paul-buerkner/brms#faq) for details on installing Stan, cmndstanr, and brms. [pacman](http://trinker.github.io/pacman/vignettes/Introduction_to_pacman.html) makes it easy to install and load multiple packages. 

## Layout:

- The contents of this repo is split up into 3 main directories:`Code`, `Data`, and `Plots`. We use the awesome package "[here](https://here.r-lib.org/)" to deal with the repo structure. Currently anyone can download the repo ***as is*** and run the code without dealing with paths (if all packages are installed).

## **`Data`** 

The data directory contains all of the raw data used in the initial models, and the data generated from the model outputs. The `Master_Data.txt` is the primary source for dental metrics, body mass, dietary rankings for all extant species including those that lack diet rankings (the "cryptic" species we use for prediction later), and the discrete categories from the four diet categorization schemes we use for comparative purposes (see Figure 2 in the text). We also store outputs in this directory because **every output .csv file is later called as an input**, either for additional analyses, predictions, or as input data for a plot. 
Here is a list of the data files:  

***Original Data Files*** 

- `Master_data.txt` -- the main data file, includes the data-deficient extant taxa
    *  `Species` & `Family` -- Species and Families of the samples  
    *   `Discrete` -- the Animal Diversity Web diet categories  
    * `m1_opcr` : `RLGA` --  the raw values of the dental metrics used in the study  
    * `log_cuberoot_mass` -- average for each species
    * `large_mammal` : `plant` -- the ranking (0-3) of the importance of each of the 13 food items for each species. Note: these are changed to 1-4 in the text and in the analyses
    * `hopkins_pineda` -- the $k$=4 discrete scheme of Piñeda-Munoz 2017
    * `hopkins_van_valk` -- the $k$=4 discrete scheme of Van Valkenburgh 1988
    * `pantheria` -- the $k$=3 discrete scheme from the panTHERIA database<br>
<br>

- `fossil_carnivoran_data.csv` -- the fossil taxa data
    * `Species` & `Phylo` -- Taxon. Phylo is called in the models
    * `m1_opcr` : `RLGA` --  the raw values of the dental metrics used in the study
    * `m1_tooth_length` -- length of m1
    * `mass_kg` -- mass kg

- `Carnivora_MCC_2.tre`
    * This is the tree file, in nexus format, used in the phylogenetic regression analyses. 

***Data File Outputs*** (most are later used as inputs)

- `Test_weights_all.csv` -- model weights of each model run (5 per food item)
    * `metric` -- dental metric, the `md`, `mn`, or `ms` means Dirichlet, Normal, or Student- $T$, describing the distribution applied to the response variable. 
    * `value` -- LOO model weight
    * `diet` -- food item<br>
<br>

- `prediction_table.csv` -- output of the `Accuracy_Calculations.Rmd` script
    * `Species` -- species
    * `item` -- food item
    * `actual` -- empirical importance ranking
    * `pred` -- predicted importance, model averaged
    * `pareto_k` -- model averaged Pareto-$K$ score for each species. See text for details
    * `pred_round` -- rounded `pred`
    * `pred_dif` -- difference between predicted and empirical rankings<br>
<br>

- `Accuracy_Table_Cont.csv` -- Accuracy values, reported as Table 2 in the text.<br>
<br>

- `Model_Averaged_Post_Sims.csv` -- Output of `Weighted_Predictions.Rmd`. These are the predictions drawn from the entire posterior distribution (4000 draws). **Do Not Try To Open This In Excel** - it's around 4m rows. 
    * `Species` -- species
    * `.draw` -- the draw number from the posterior
    * `P1` : `P4` -- the probability of each of the 4 rankings
    * `item` -- food item
    * `ma` -- *Weighted Importance Score* from text.<br>
<br>

- `Model_Averaged_Post_Sims_Crypt_Fos.csv` -- Same cols as `Model_Averaged_Post_Sims.csv`<br>
<br>

- `Extant_Predictions_Summary.csv` -- Summaries of the posterior predictions. Output of `Weighted_Predictions.Rmd`.
    * `Species` & `item` -- should be clear by now
    * `wa_rank` -- $\overline{WIS}$ from text, the mean weighted importance score
    * `rounded_pred_rank` -- rounded `wa_rank`
    * `real_rank` -- empirical value<br>
<br>

- `Crypt_Fos_Predictions_Summary.csv` -- same as `Extant_Predictions_Summary.csv` but for the extant data-deficient and fossil taxa. `real_rank` is `NA` of course.<br>
<br>

- `Table_S2_Model_Results.csv` -- results of all the models in one sheet. Presented as Table S2 in the text, details there. This is not called into any script. And `Table_S2_Model_Results2.csv` is just a laTex / html friendly version of the exact same thing<br>
<br>

- `NN_probabilities.csv` -- probabilities of nearest neighbors for each taxon. Output of the `Ordination_NN_Probabilities.Rmd` script. This is reduced down to neighbors that are closest at least 5% of the time. 
    * `Species` -- species
    * `nearest_1` -- neighbor
    * `n` -- number of times this taxon `nearest_1` is the nearest neighbor to `Species` out of 4000 analyses
    * `percent` -- `n` / 4000 <br>
<br>

- `mclust_diet_results.csv` -- Results of the `mclust` analysis. Provides the clusters for each of the different mclust runs (k=3 to k=6).
    * `Species` -- species
    * `V1` to `V13` -- Polychoric PCA scores for the 13 dietary axes
    * `Family` -- family
    * `Discrete` -- Animal Diversity Web discrete scores
    * `m1_opcr` to `log_cuberoot_mass` - Dental metrics & mass as in master_data
    * `large_mammal` to `plant` -- food item rankings
    * `hopkins_pineda` to `pantheria` -- discrete classifications from different classification schemes
    * `mass_kg` -- mass kg
    * `phylo` -- phylo (same as species, used for model input)
    * `m1_tooth_length` -- m1_tooth_length for fossil taxa, not used here
    * `class_3` to `class_6` -- clasifications from the `mclust` analyses using k=3, k=4, k=5, and k=6. <br>
<br>


## **`Code`** 

#### Polychoric PCA and Cluster Analyses  
- We are interested if the multivariate diet matches traditional diet categories from several commonly used classification schemes. To do this, we want to project the importance rankings of the 13 food items into a multivariate diet space, then run a cluster analysis to identify natural groupings in dietspace. This is outlined in the `Code/Ord_Clust_Plot_FIgure_2.Rmd/` script. As the dietary importance rankings are ordinal rankings, and not continuous, we use a method called polychoric PCA, which is designed for ordinal variables. We estimate a polychoric correlation matrix, the project the species into diet space. The process is pretty well annotated in the script. Then we use the package [`mclust`](https://cran.r-project.org/web/packages/mclust/vignettes/mclust.html), which performs cluster analyses using finite normal mixture modeling, to determine the natural clusters. Since there is no really strong preference for a number of clusters, we calculate $k$ = 3, 4, 5, and 6. Then we use the adjusted Rand index to compare these to 4 classification schemes. More details in the text. This generates the Figure 2 plots, which are stored as `Plots/Figure_2_Diet_Clusters.pdf`.

#### Prior Predictive Checks and Model Estimation
- All of the models, prior and posterior checking, predictions, data wrangling, etc. are found in this directory.

- To determine the parameters for each prior distribution on the response variables, we ran prior predictive checks. Similar to the model scripts, these are in the `Code/Prior_Pred_Checks/` directory and labeled `FOODITEM_Prior_Check.Rmd`. The script `Prior_Pred_Checks_All.Rmd` runs all 13 of these scripts, and stores the outputs in the `Code/Prior_Pred_Checks/prior_pred_outputs` directory. `Code/Prior_Preds_Figure_S1.Rmd` generates **Figure_S1_Prior_Pred_Checks.pdf**, stored in the `Plots` dir, shows the prior distributions that we used for each tooth metric for each food item. Note that we used a $N$(0,1) prior on all of our predictor variables, as they are all scaled to a mean of 0 and an sd of 1, and this loosely regularizing prior keeps the models in check but still allows for large effect sizes. 

- All of our ordinal **brms** models use one of three priors on the response variable (the ranks): A Normal distribution, a Student- $T$ distribution, and a  Dirichlet Prior on the threshold (aka cutpoint) values. The Dirichet prior script is found in `Dirichlet_Prior.R`. We used the Stan code described in [this Stan Discourse post](https://discourse.mc-stan.org/t/dirichlet-prior-on-ordinal-regression-cutpoints-in-brms/20640/3), written by [Staffan Betnèr](https://github.com/StaffanBetner), to create this prior. This code was generated from and informed by the case study by [Michael Betancourt](https://betanalpha.github.io/) found [here](https://betanalpha.github.io/assets/case_studies/ordinal_regression.html). We set the mean intercept	$\phi$ to 0 rather than have the model estimate it, which performed better in our simulations. See comment #9 in the discourse post.

- The bulk of our results are from the multilevel models generated in [**brms**](https://github.com/paul-buerkner/brms). The scripts containing the models for each food item are in the `Code/Models/` directory and labeled `Mods_FOODITEM.Rmd`. Each script contains 15 models. To run all of these, visit the script `Code/Mod_All.Rmd`, which wrangles the data and calls each food item script individually. ***This Must Be Run Before the Plotting or Prediction Scripts*** because the brms model objects are necessary for those. The outputs of the models will be stored in the `Code/Models/mod_outputs` directory (see below). These are imported later for predictive and plotting scripts (it's better than running all the models again).

- After running the models, we estimated the LOO model weights of each model using stacking. We first calculated the weights for each model for each metric (3 per metric, each with a different prior on the response, see above). Then we took the models with the highest weight for each metric (n=5) and estimated the model weights for these. This is all in the `Mods_FOODITEM.Rmd` scripts. The model weights are collected iteratively as each food item file runs in `Code/D_All_Models.Rmd`, and the weights are stored in the file `Data/Test_weights_all.csv`. 

- The parameter estimates of all the models with a model weight >0 are found in `Data/Table_S2_Model_Results.csv`, and kept as a supporting file in the manuscript. The script for generating this table is called `Code/Table_S2_Model_Results.Rmd`. There is a lot of data wrangling involved to get the table formatted like it is. 

#### Model Posterior Validation & Accuracy Checks

- We performed Posterior Predictive Checks on every model that has a loo model weight > 0. The model outputs are stored in the `Code/Models/mod_outputs` directory.  The `Posterior_Preds_Figure_S2.Rmd` script calls these and plots them in the same way as the prior predictive plots. **Figure_S2_Posterior_Pred_Checks.pdf** in the `Plots` dir shows the results, which look quite good (mean is mostly centered on empirical values with little uncertainty on most food items). 

- We checked the accuracy of our model predictions by comparing them to the empirical ranks for each species. This script is in `Code/Accuracy_Calculations.Rmd`, and the results are reported in Table 4 of the text and are saved as `Data/Accuracy_Table.csv`. We report these results as percentages of estimates that are the exact rank, and within 1 rank (which we consider a good estimate in this ranking scale). We estimate 1000 draws from the posterior of each model, then model average over them using the LOO weights, then estimate the accuracy of the predictions. `Data/Prediction_Table.csv` gives the mean predictions from the 1000 samples, and `Data/Accuracy_Table_Cont.csv` provides the values in table 4. The `Code/Accuracy_Calculations.Rmd` script contains a few custom functions, some parallel computing, and is time intensive. Reach out with questions :)

- Our third method of validating the predictive power of our models is interrogating our predictive accuracy and model fit using leave-one-out cross validation. There is a lot of information on CV, LOO CV, and the Pareto-Smoothed-Importance-Sampling (PSIS) method of LOO approximation out there (try starting with this [Excellent FAQ Page](https://mc-stan.org/loo/articles/online-only/faq.html) from the `LOO` package). In addition to model comparison, which we did above by using model weights generated from LOO scores, we are interested in the stability of our estimates within individual models. If a species is removed from the analysis, does that alter the prediction of other species? The Pareto-$K$ diagnostic score answers that. If, when the sample is removed from the analysis, the posterior changes substantially, it produces a high Pareto-$K$ estimate, and a small Pareto-$K$ means that the estimate is stable without the particular sample. We gathered these scores in the `Code/Accuracy_Calculations.Rmd` script described above, and they are reported along side the additional predictions in the `Data/Prediction_Table.csv` file. The Pareto-$K$ values are reported in the Supporting information Table S1. The `Pareto_Table.tex` file for this table is generated in `Code/Accuracy_Calculations.Rmd` as well, and is used to generate the Table S1 in the latex submission.

#### Posterior Predicitons of Extant Data-Rich, Data-Deficient, and Fossil Taxa

- We generate model_averaged predictions of the Fossil and Data-Deficient Taxa, as well as the Data-Rich Extant Taxa, in the script `Code/Weighted_Predictions.Rmd`. This generates four `Data` files:  
    1.  `Data/Model_Averaged_Post_Sims.csv` - 4000 posterior probability draws of the model averaged probabilities for each species/food item from the extant, data rich taxa. Columns are the probabilities of the 4 rankings, plus a weighted importance score for each row. *Warning, >4m rows.* 
    2.  `Data/Extant_Predictions_Summary.csv` - The means of each of the 4000 draws from the `Model_Averaged_Post_Sims.csv` data frame. 13 * 89 = 1157 rows.
    3. `Data/Model_Averaged_Post_Sims_Crypt_Fos.csv` - The same as above, but for the data deficient extant and fossil taxa. 
    4. `Data/Crypt_Fos_Predictions_Summary.csv` - same as 2, but for the data deficient extant and fossil taxa.  
- The summary files are used to generate Figure 4, in `Code/Figures_4.Rmd`, and some of the values are reported in the text. The larger `Sims` files are used in the nearest neighbor predictions below. This script uses several custom functions to perform the tasks and makes use of [`tidybayes`](http://mjskay.github.io/tidybayes/articles/tidybayes.html). 

#### Nearest Neighbor Calculations

- A neat feature of our multivariate diet method is that species can be projected into $n$-dimensional diet-space. This allows for estimates of disparity, density, and, as we do here, nearest neighbor estimations, which allow us to identify the extant data-rich species that are most similar to the fossil and data deficient taxa in our dataset. The script to do this is `Code/Ordination_NN_Probabilities.Rmd`.  After digging into the results a bit more, we found that the multivariate diet space is fairly dense in some regions (this can be seen in Figure 2), and only providing a single nearest neighbor is misleading. Our Bayesian methodology generates distributions rather than point estimates, so we estimated a data-rich nearest neighbor for the data-deficient taxa from each of 4000 posterior draws. The process goes as follows: For each draw in our 4000 posterior estimates, we manually performed a principal components analysis on the correlation matrix of WIS values for data-rich extant species. Then we take the estimates WIS values of the data deficient taxa and project these into the principal components space of the data-rich taxa. Then, for each of the 4000 PC spaces, we find the data-rich species that are closest in euclidean distance to the data-deficient species, and summarize these results as percentages. For example, in 1520 of the 4000 PC spaces, or 38%, *Ursus speleaus* is closest in euclidean distance to *Ursus maritimus*. We report the most common 3 in Table 5 in the text. The file `Data/NN_probabilities.csv` reports all of the Nearest Neighbors with a percentage above 5% in case you want to dig deeper into these results.


## **`Plots`** 

- All of the output plots are stored here. There are both `.pdf`s and `.png`s of most of the plot files. They all have the figure number in the file name. Additionally, several table outputs are stored here as they are rendered in the package [kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html) into figures and `.tex` files used in the manuscript production. The only plot stored here that is not directly generated in `Code` files is `Figure_1_v2.pdf` & `....png`. This is the figure 1 that appears in the manuscript, and has 3D tooth images and phylopic images manually added in affinity design. 


