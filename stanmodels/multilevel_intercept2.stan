data { 
  int<lower=1> N;  // total number of observations 
  vector[N] y;  // response variable 
  vector[N] x;  // predictor variable
  int<lower=1> Nside;  // number of sides
  int<lower=1> side[N];  // side index
} 
parameters {
  vector[Nside] z_alpha;  // dummy intercepts
  real mu_alpha;  // intercept mean
  real<lower=0> tau_alpha;  // intercept SD
  real beta;  // slope
  real<lower=0> sigma;  // residual SD 
} 
transformed parameters {
  vector[Nside] alpha = mu_alpha + tau_alpha * z_alpha;
}
model { 
  vector[N] mu;
  for (n in 1:N) {
    mu[n] = alpha[side[n]] + beta * x[n];
  }
  // likelihood
  y ~ normal(mu, sigma);
  // priors
  z_alpha ~ normal(0, 1);
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
