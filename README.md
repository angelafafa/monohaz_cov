# Monotone Harzard Ratio
A repository for the paper "monotone harzard ratio"

[![Journal](https://img.shields.io/badge/RA--L2023-Accepted-success)](https://ieeexplore.ieee.org/iel7/7083369/7339444/10251585.pdf)
[![Arxiv](http://img.shields.io/badge/arxiv-cs:2309.05131-B31B1B.svg)](https://arxiv.org/abs/2309.05131.pdf)

> A better framework to compute monotone harzard ratio.

This repository contains the original code and tutorial for our ICRA2024 paper, "Signal Temporal Logic Neural Predictive Control." [[link]](https://arxiv.org/abs/2309.05131.pdf)


```
@article{meng2023signal,
  title={Signal Temporal Logic Neural Predictive Control},
  author={Meng, Yue and Fan, Chuchu},
  journal={IEEE Robotics and Automation Letters},
  year={2023},
  publisher={IEEE}
}
```

## Prerequisite
Ubuntu 20.04 (better to have a GPU like NVidia RTX 2080Ti)

Packages (steps 1 and 2 suffice for just using our STL Library (see [tutorial](tutorial.ipynb))):
1. Numpy and Matplotlib: `conda install numpy matplotlib`
2. PyTorch v1.13.1 [[link]](https://pytorch.org/get-started/previous-versions/): `conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia` (other version might also work )
3. Casadi, Gurobi and RL libraries: `pip install casadi gurobipy stable-baselines3 && cd mbrl_bsl && pip install -e . && cd -`
4. (Just for the manipulation task) `pip install pytorch_kinematics mujoco forwardkinematics pybullet && sudo apt-get install libffi7`

## Model/Data preparation
Download all the pretrained models `exps_cyclf.zip` and necessary data `walker.zip` from [Google Drive](https://drive.google.com/drive/folders/101wBUH-M9y-tbCQ_HE_PdRNEswRrcVha?usp=sharing) and extract them in `exps_cyclf` and `walker` under the project directory.


## Main evaluation experiments
### Car experiment (figure 4 in our paper)
```shell
# (from package directory)
cd car
python car_planner.py --exp_name CAR_25X --gpus 0 --dt 0.01 --nt 100 --num_samples 10000 --joint_pretrained_path g0128-111623_JOI_ROA_U12_SA_grow --net_pretrained_path g0128-125740_EST_grow --mono_actor_pretrained_path g0511-000521_JOI_ROA_U12_SA_grow_singleclf_one --u_limit 8 8 --allow_factor 1.0 --cap_seg 16 --num_workers 1 --skip_viz 100 --use_sample --lqr_nt 100 --clf_nt 120 --use_middle --new_ring_seg 10 --race --race_angle 30 --num_trials 25 --methods mbpo mbpo mbpo rl-sac rl-sac rl-sac rl-ppo rl-ppo rl-ppo rl-ddpg rl-ddpg rl-ddpg mpc lqr clf ours ours-d --auto_rl --mbpo_paths g1124-015808_car_mbpo_1007 g1124-015809_car_mbpo_1008 g1124-015811_car_mbpo_1009
```

### Pogo experiment (figure 6)
```shell
# (from package directory)
cd pogo
python beta_plan.py --exp_name Pp_25X_d --gpus 0 --normalize --viz_freq 500 --data_path g0208-214752_Pda_10M --dyna_pretrained_path g0208-222845_Pfit --actor_pretrained_path g0209-012818_Pclf_mgn --clf_pretrained_path g0209-012818_Pclf_mgn --net_pretrained_path g0209-112138_Proa --methods mbpo mbpo mbpo rl-sac rl-sac rl-sac rl-ppo rl-ppo rl-ppo rl-ddpg rl-ddpg rl-ddpg mpc ours ours-d --num_trials 25 --auto_rl --mbpo_paths g1124-074642_beta_mbpo_1007 g1124-091519_beta_mbpo_1008 g1124-093210_beta_mbpo_1009
```

## Tutorial
You can find basic usage in our tutorial jupyter notebook [here](tutorial.ipynb).
