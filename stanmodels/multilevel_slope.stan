data { 
  int<lower=1> N;  // total number of observations 
  vector[N] y;  // response variable 
  vector[N] x;  // predictor variable
  int<lower=1> Nside;  // number of sides
  int<lower=1> side[N];  // side index
} 
parameters {
  real mu_alpha;  // intercept mean
  real mu_beta;  // slope mean
  real<lower=0> tau_alpha;  // intercept SD
  real<lower=0> tau_beta;  // slope SD
  // cholesky factor of the correlation matrix
  cholesky_factor_corr[2] L_Cor;
  matrix[2, Nside] z_theta;  // dummy varying effects
  real<lower=0> sigma;  // residual SD
} 
transformed parameters {
  // cholesky factor of the covariance matrix
  matrix[2, 2] L_Sigma = diag_pre_multiply([tau_alpha, tau_beta]', L_Cor);
  matrix[2, Nside] theta;  // actual varying effects
  for (j in 1:Nside) {
    theta[, j] = [mu_alpha, mu_beta]' + L_Sigma * z_theta[, j];
  }
}
model { 
  vector[N] mu;
  for (n in 1:N) {
    mu[n] = theta[1, side[n]] + theta[2, side[n]] * x[n];
  }
  // likelihood
  y ~ normal(mu, sigma);
  // priors
  to_vector(z_theta) ~ normal(0, 1);
  mu_alpha ~ normal(0, 100);
  mu_beta ~ normal(0, 50);
  tau_alpha ~ cauchy(0, 50);
  tau_beta ~ cauchy(0, 30);
  L_Cor ~ lkj_corr_cholesky(2);
  sigma ~ cauchy(0, 50);
}
generated quantities {
  corr_matrix[2] Cor = multiply_lower_tri_self_transpose(L_Cor);
  vector[N] yrep;  // posterior predictions
  vector[N] ll;  // log-likelihood values
  for (n in 1:N) {
    real mu = theta[1, side[n]] + theta[2, side[n]] * x[n];
    yrep[n] = normal_rng(mu, sigma);
    ll[n] = normal_lpdf(y[n] | mu, sigma);
  }
}
