data { 
  int<lower=1> N;  // total number of observations 
  vector[N] y;  // response variable 
  vector[N] x;  // predictor variable
  int<lower=1> Nside;  // number of sides
  int<lower=1> side[N];  // side index
} 
parameters {
  vector[Nside] alpha;  // intercepts
  real mu_alpha;  // intercept mean
  real<lower=0> tau_alpha;  // intercept SD
  real beta;  // slope
  real<lower=0> sigma;  // residual SD 
} 
model { 
  vector[N] mu;
  for (n in 1:N) {
    mu[n] = alpha[side[n]] + beta * x[n];
  }
  // likelihood
  y ~ normal(mu, sigma);
  // priors
  alpha ~ normal(mu_alpha, tau_alpha);
  mu_alpha ~ normal(0, 100);
  tau_alpha ~ cauchy(0, 50);
  beta ~ normal(0, 50);
  sigma ~ cauchy(0, 50);
}
generated quantities {
  vector[N] yrep;  // posterior predictions
  vector[N] ll;  // log-likelihood values
  for (n in 1:N) {
    yrep[n] = normal_rng(alpha[side[n]] + beta * x[n], sigma);
    ll[n] = normal_lpdf(y[n] | alpha[side[n]] + beta * x[n], sigma);
  }
}
