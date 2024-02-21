# Monotone Harzard Estimator
This repository contains the original code for the paper "Estimating Baseline Survival Function in the Proportional Hazards Model Under Monotone Hazards".

The `R/` folder contains R code and data to create figure 2 and 3 as well as to calculate average bias and MCSE of Kaplan–Meier estimator under setting 5. The `Python/` folder contains Python code for simulating data, creating figure 1, and generating summary statistics for table 2 and 3.


## Prerequisite

Packages (steps 1 and 2 are for Python; step 3 is for R):
1. Numpy, Matplotlib and Pandas: `conda install numpy matplotlib pandas`
2. Lifetime libraries: `pip install lifelines`
3. survival, boot, and ggplot2: 'install.packages("survival/boot/ggplot2")'

## Data
Download .npz and .csv data or run .ipynb and .R in folder 'R/' and/or 'Python/' 


## Simulation summaries
### Figure 1, Table 2 and 3 (Setting 1-4)
Run 'monotone_hazard.ipynb' in folder 'Python/'.
```python
#(a) Setting 1
main(a=1, x_time=693.1472,n_trials=1000,n_samples_old=1000,method_i = 4,trun_scale=250)
#(b) Setting 2
#main(a=2, x_time=832.5546,n_trials=1000,n_samples_old=1000,method_i = 4,trun_scale=450)
#(c) Setting 3
#main(a=4, x_time=912.4443,n_trials=10,n_samples_old=1000,method_i = 4,trun_scale=500)
#(d) Setting 4
#main(a=6, x_time=940.7428,n_trials=1000,n_samples_old=1000,method_i = 4,trun_scale=500)
```
### Table 2 and 3 (Setting 5)
Status printed after each simulation
```python
print("Trials:%04d/%04d  dt:%.3fs  elapsed:%.3fs  ETA:%.3fs  | OUTPUT=wu:%.4f tsai:%.4f cox:%.4f| min_x:%.4f min_t:%.4f  valid_n:%4d"%(i, n_trials, dt, elapsed, eta, surv_median_est[i], surv_median_tsai[i],cox_med[i],min_x, min_t, n_samples))
```
Below needs to be commented out to avoid calculating KM statistics directly from Python
```python
kmf.fit(durations=y1[cov1==0], event_observed=delta[cov1==0], entry=truncation[cov1==0])
km_med[i]=np.mean(kmf.survival_function_at_times(x_time))
```
Bias and MCSE (S5) of methods other than KM
```python
print("Summary:   bias: %.4f| %.4f| %.4f   variance: %.4f| %.4f| %.4f avg_n:%4d"%(
            np.mean(surv_median_est)-0.5,np.mean(surv_median_tsai)-0.5,
            np.mean(cox_med)-0.5,
            np.std(surv_median_est,ddof=1),np.std(surv_median_tsai,ddof=1),
            np.std(cox_med,ddof=1),np.std(km_med,ddof=1),np.mean(sample_size)
        ))
```
Bias and MCSE (S5) of KM
```r
#Bias (S5) of KM in table 2
mean(surv.median.est.km)
#MCSE (S5) of KM in table 3
sqrt(sum((surv.median.est.km-mean(surv.median.est.km))^2)/(999))
```

### Figure 2 (Setting 5)
We use python to generate data "df_concat_S5.csv" (later read in R to calculate KM summary) and "result_df.csv" (average survival probability at median ready for making a plot)
Run 'coxfail_fig2.R' in folder 'R/' to create figure 2.


### Figure 3 (Channing House)
Run 'channing_fig3.R' in folder 'R/' to create figure 3.
