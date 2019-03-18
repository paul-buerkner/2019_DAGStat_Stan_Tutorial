data { 
  int<lower=1> N;  // total number of observations 
  vector[N] y;  // response variable 
  vector[N] x;  // predictor variable
} 
parameters {
  real alpha;  // intercept
  real beta;  // slope
  real<lower=0> sigma;  // residual SD 
} 
model { 
  // likelihood
  y ~ normal(alpha + beta * x, sigma);
  // priors
  alpha ~ normal(0, 100);
  beta ~ normal(0, 50);
  sigma ~ cauchy(0, 50);
}
generated quantities {
  vector[N] yrep;  // posterior predictions
  vector[N] ll;  // log-likelihood values
  for (n in 1:N) {
    yrep[n] = normal_rng(alpha + beta * x[n], sigma);
    ll[n] = normal_lpdf(y[n] | alpha + beta * x[n], sigma);
  }
}
