library(survival)
library(ggplot2)
#load data generated for each trial
df_concat=read.csv("~/Downloads/df_concat1.csv")
df_concat$delta=ifelse(df_concat$delta=="True",1,0)
#average survival estimates at median survival calculated in python
result_df=read.csv("~/Downloads/result_df1.csv")
surv.est.km=c()
mean.km=c()
for(i in 1:100){
  surv.est.km=c()
  tt1=Sys.time()
  for (j in unique(df_concat$trial_i)) {
    fit1=survfit(Surv(truncation,y1, delta) ~ cov1, data = df_concat[df_concat$trial_i==j,]) 
    km_index=findInterval(seq(0,1225,length.out=100)[i],summary(fit1)$time[1:sum(summary(fit1)$strata=="cov1=0")],left.open=TRUE)
    surv.est.km[j]=ifelse(km_index==0,1,summary(fit1)$surv[km_index])
  }
  mean.km[i]=mean(surv.est.km)
  tt2=Sys.time()
  print(tt2-tt1)
}
#average KM survival estimates at median survival
result_df$km_avg=mean.km
#calculate average bias and MCSE under setting 5
surv.median.est.km=c()
for (j in unique(df_concat$trial_i)) {
  fit1=survfit(Surv(truncation,y1, delta) ~ cov1, data = df_concat[df_concat$trial_i==j,]) 
  km_med_index=findInterval(912.4443,summary(fit1)$time[1:sum(summary(fit1)$strata=="cov1=0")],left.open=TRUE)
  surv.median.est.km[j]=summary(fit1)$surv[km_med_index]
}
#Bias (S5) of KM in table 2
mean(surv.median.est.km)
#MCSE (S5) of KM in table 3
sqrt(sum((surv.median.est.km-mean(surv.median.est.km))^2)/(999))
#create dataset used to generate figure 2
coxfail.df=data.frame(time=c(rep(seq(0,1225,length.out=100),5)),
                      type=c(rep("Proposed method",100),rep("Tsai",100),
                             rep("KM",100),rep("Breslow",100),
                             rep("True",100)),
                      survival=c(result_df$wu_avg,result_df$tsai_avg,
                                 result_df$km_avg,result_df$cox_avg,
                                 result_df$true_prob))
#figure 2
ggplot(coxfail.df, aes(x=time, y=survival)) + 
  geom_line(aes(linetype=type, color=type)) +
  theme_bw()+xlab("Time") + ylab("Survival Probability")+
  theme(legend.position = c(0.23, 0.22),
        legend.title= element_blank(),
        legend.box.background = element_rect(color="black",linewidth = 1),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(fill=NA,color="black", size=0.8, linetype="solid"),
        axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size=10))
