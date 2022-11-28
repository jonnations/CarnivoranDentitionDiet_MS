

#### Dirichlet Cutpoint Prior
dirichlet_prior <- 
"real induced_dirichlet_lpdf(vector c, vector alpha, real phi) {
    int K = num_elements(c) + 1;
    vector[K - 1] anchoredcutoffs = phi - c;
    // sigma is the CDF of the latent distribution
    // logit:
    vector[K - 1] sigma = inv_logit(anchoredcutoffs); 
    // probit:
    // vector[K - 1] sigma = Phi(anchoredcutoffs);
    // or: 
    // vector[K - 1] sigma = Phi_approx(anchoredcutoffs);
    vector[K] p;
    matrix[K, K] J = rep_matrix(0, K, K);
    
    // Induced ordinal probabilities
    p[1] = 1 - sigma[1];
    for (k in 2:(K - 1))
      p[k] = sigma[k - 1] - sigma[k];
    p[K] = sigma[K - 1];
    
    // Baseline column of Jacobian
    for (k in 1:K) J[k, 1] = 1;
    
    // Diagonal entries of Jacobian
    for (k in 2:K) {
      // rho is the PDF of the latent distribution
      // logit:
      real rho = sigma[k - 1] * (1 - sigma[k - 1]);
      // probit: 
      // real rho = exp(std_normal_lpdf(anchoredcutoffs));
      J[k, k] = - rho;
      J[k - 1, k] = rho;
    }
    
    return dirichlet_lpdf(p | alpha)
           + log_determinant(J);
}
"

dirichlet_prior_stanvar <- stanvar(scode = dirichlet_prior, block = "functions")
