require(agricolae)

dados<-mtcars
attach(dados)
names(dados)

descstat<-function(x){
  n=length(x)
  min=min(x)
  max=max(x)
  s=sum(x)
  sq=sum(x^2)
  m=mean(x)
  sqd=sum((x-m)^2)
  md=median(x)
  dp=sd(x)
  err=sd(x)/sqrt(length(x))
  s2=var(x)
  cv=dp/m*100
  as=skewness(x)
  ct=kurtosis(x)
  sw=shapiro.test(x)
  if(shapiro.test(x)$p.value<=0.05)   
    nor="Non-normal" else nor="Normal" 
  
  c(Length=n,Min=min,Max=max,Mean=m,Median=md,
    Variance=s2,StdDev=dp,
    CV=cv,Skewness=as,Kurtosis=ct,
    SWtest=sw,Normality=nor)
}

descstat(mpg)

descritiva_mpg<-t(as.data.frame(descstat(mpg)));descritiva_mpg
