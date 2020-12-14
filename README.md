# Prediction, Communication, and Computing Duration Optimization for VR Video Streaming

This repository provides codes for reproducing all the results in the paper：
- [Prediction, Communication, and Computing Duration Optimization for VR Video Streaming](https://ieeexplore.ieee.org/abstract/document/9268977/). Xing Wei, Chenyang Yang, Shengqian Han.

Published on IEEE Transactions on Communications, 2020.

Specifically, the whole reproducing procedure is recommended by the following steps:

- Run the LR and LinUCB predictors on a 360 video dataset.
- Reproduce the fitting functions of prediction performance of predictors.
- Reproduce other results with the fitting functions.

It is recommended to download all the files before you start the reproducing procedure.

# Run the LR and LinUCB predictors on a 360 video dataset

## Tile requests of a public 360 video dataset

We use the following public 360 video dataset:

-[360 video viewing dataset in head-mounted virtual reality](https://dl.acm.org/doi/abs/10.1145/3083187.3083219).  Wen-Chih Lo,  Ching-Ling Fan,   Jean Lee,  Chun-Ying Huang,   Kuan-Ta Chen, Cheng-Hsin Hsu.

Published on ACM MMsys, 2017. If you find the dataset useful for your research, please cite their paper.

You can find the tile requests of the dataset in this repository named "tile". Download the file, unzip, and store it locally. Log the absolute path and transform the absolute  path into  `dataset_path`.

For example, if you store it in D:\tile,  then the `dataset_path` is D:/tile/.  


## Run the LinUCB predictor on the dataset 

Download the folder "LR_LinUCB_predictors_python",  and run `LinUCB_prediction_results.py`.  

Input the `dataset_path`, the prediction starts  and the results on the dataset will be stored in the file `average_DoO_CB.mat`.

## Run the LR predictor on the dataset 

 Run `LR_prediction_results.py`.  Input the `dataset_path`, the prediction starts  and the results on the dataset will be stored in the file `average_DoO_LR.mat`.

# Reproduce the fitting functions of prediction performance of predictors

Download the folder "obtain_results_matlab". Copy `average_DoO_CB.mat` and `average_DoO_LR.mat` to the folder. 

Run `plot_Fig4a_Table_I_LR_fitting_function.m`,  `plot_Fig4b_Table_II_CB_fitting_function.m`, and `plot_Fig4c_Table_III_GRU_fitting_function.m`, respectively, the fitting functions as well as the fitting parameters can be obtained. 

The fitting parameters will be stored as `fitting_performance_LR.mat`, `fitting_performance_LinUCB.mat`, and `fitting_performance_GRU.mat`, respectively.

# Reproduce other results with the fitting functions.

Run all the other files prefixed by "plot", you will obtain all other results in the paper.
