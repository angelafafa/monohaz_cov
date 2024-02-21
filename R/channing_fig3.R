library(survival)
library(boot)
chaning=boot::channing
chaning=channing[channing$entry<channing$exit,]
chaning$gender=ifelse(chaning$sex=="Male",0,1)
mono.haz.real.data=function(df1=chaning,adjust=TRUE,beta.hat){
  z_k=unique(sort(c(df1$exit,df1$entry)))
  z1=unique(sort(df1[df1$cens==1,"exit"]))
  N=length(z_k)
  death.sum=c()
  risk.set=c()
  exp.term=c()
  lambda=c()
  for(h in 1:length(z_k)){
    index=(df1$exit>z_k[h])&(df1$entry<=z_k[h])
    risk.set[h]=sum(index)
    death.sum[h]=sum(z1==z_k[h])
    if(adjust){
      exp.term[h]=sum(exp(df1$gender[index]*beta.hat))
    }
  }
  for(j in 1:(N-1)){
    ratio.candidates=c()
    for (r in 1:j){
      ratio=c()
      i=1
      for (s in j:(N-1)){
        nom=sum(death.sum[r:s])
        difference=diff(z_k)
        if(adjust){
          denom=sum(exp.term[r:s]*(difference[r:s])) 
        }
        else{
          denom=sum((risk.set[r:s])*(difference[r:s]))
        }
        ratio[i]=nom/denom
        i=i+1
      }
      ratio.candidates[r]=min(ratio)
    }
    lambda[j]=max(ratio.candidates)
  }
  lambda[N]=lambda[N-1]
  return(lambda)
}
baseline_survival=function(t1,df1,hazard.est=tsai_men){
  z_k=unique(sort(c(df1$exit,df1$entry)))
  distinct.time=append(0,z_k)
  l=findInterval(t1,z_k,left.open=TRUE)
  cumhaz1=ifelse(t1<=z_k[1],0,cumsum(diff(distinct.time)*hazard.est)[l])
  rest=ifelse(t1<=z_k[1],t1*hazard.est[1],(t1-z_k[l])*hazard.est[l+1])
  integration=cumhaz1+rest
  baseline.survival=exp(-integration)
  return(baseline.survival)
}
chaning_men=chaning[chaning$gender==0,]
wu_men=mono.haz.real.data(df1=chaning_men,beta.hat=0,adjust=TRUE)
tsai_men=mono.haz.real.data(df1=chaning_men,beta.hat,adjust=FALSE)
men_surv_wu=sapply(unique(sort(c(chaning_men$exit,chaning_men$entry))), baseline_survival,df1=chaning_men,hazard.est=wu_men)
men_surv_tsai=sapply(unique(sort(c(chaning_men$exit,chaning_men$entry))), baseline_survival,df1=chaning_men,hazard.est=tsai_men)
cox_men=coxph(Surv(entry,exit, cens) ~ 1, data=chaning_men)
bh1=basehaz(cox_men)
cox.men.surv=exp(-bh1[,1])
km_men=survfit(Surv(entry,exit, cens) ~ 1, data=chaning_men)
channing.men=data.frame(time=c(unique(sort(c(chaning_men$exit,chaning_men$entry))),
                               unique(sort(c(chaning_men$exit,chaning_men$entry))),
                               c(751,759,sort(summary(km_men)$time),1153),
                               c(751,759,sort(bh1$time))),
                        type=c(rep("Proposed method",length(unique(sort(c(chaning_men$exit,chaning_men$entry))))),
                               rep("Tsai",length(unique(sort(c(chaning_men$exit,chaning_men$entry))))),
                               rep("KM",length(summary(km_men)$time)+3),
                               rep("Breslow",length(bh1$time)+2)),
                        survival=c(c(men_surv_wu),c(men_surv_tsai),
                                   c(1,1,summary(km_men)$surv,0),c(1,1,cox.men.surv)))
#figure 3
ggplot(channing.men, aes(x=time, y=survival)) + 
  geom_line(aes(linetype=type, color=type)) +
  theme_bw()+xlab("Time") + ylab("Survival Probability")+
  theme(legend.position = c(0.75, 0.8),
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


