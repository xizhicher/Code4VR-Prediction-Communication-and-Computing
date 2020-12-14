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

Published on ACM MMsys, 2017.

You can find the tile requests of the dataset in the folder "tile". Download the folder and store it locally, log the absolute  path and transform the absolute  path into  `dataset_path`.

For example, if you store it in D:\tile,  then the `dataset_path` is D:/tile/.  


## Run the LinUCB predictor on the dataset 

All your files and folders are presented as a tree in the file explorer. You can switch from one to another by clicking a file in the tree.
