data { 
  int<lower=1> N;  // total number of observations 
  vector[N] y;  // response variable 
  vector[N] x;  // predictor variable
  int<lower=1> Nlocation;  // number of locations
  int<lower=1> location[N];  // location index
} 
parameters {
  vector[Nlocation] z_alpha;  // dummy intercepts
  real mu_alpha;  // intercept mean
  real<lower=0> tau_alpha;  // intercept SD
  real beta;  // slope
  real<lower=0> sigma;  // residual SD 
} 
transformed parameters {
  vector[Nlocation] alpha = mu_alpha + tau_alpha * z_alpha;
}
model { 
  vector[N] mu;
  for (n in 1:N) {
    mu[n] = alpha[location[n]] + beta * x[n];
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
    yrep[n] = normal_rng(alpha[location[n]] + beta * x[n], sigma);
    ll[n] = normal_lpdf(y[n] | alpha[location[n]] + beta * x[n], sigma);
  }
}
