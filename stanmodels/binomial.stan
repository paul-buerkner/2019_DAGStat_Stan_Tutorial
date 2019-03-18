data { 
  int<lower=1> N;  // total number of observations 
  int<lower=1> M;  // market size
  int y[N];  // response variable 
  vector[N] x;  // predictor variable
} 
parameters {
  real alpha;  // intercept
  real beta;  // slope
} 
model {
  // likelihood
  y ~ binomial_logit(M, alpha + beta * x);
  // priors
  alpha ~ normal(0, 10);
  beta ~ normal(0, 5);
}
generated quantities {
  vector[N] theta = inv_logit(alpha + beta * x);
  vector[N] yrep;  // posterior predictions
  vector[N] ll;  // log-likelihood values
  for (n in 1:N) {
    yrep[n] = binomial_rng(M, theta[n]);
    ll[n] = binomial_lpmf(y[n] | M, theta[n]);
  }
}
