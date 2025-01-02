#' Maximum likelihood applied to a special case
#'
#' The `neg_log_lik()` function returns the maximum likelihood estimates to a special case of hierarchical Bernoulli data, as discussed in *DBDA3*, Chapter 9.
#'
#' @param param A character vector of the parameter names. All parameters must be specified.
#' @param z A numeric vector of the number of successful Bernoulli trials for each level of \eqn{S}.
#' @param n A numeric vector of the total number of Bernoulli trials for each level of \eqn{S}.
#'
#' @returns A numeric value, which is the negative log likelihood (NLL).
#'
#' @examples
#' z_ex <- c(15, 20, 25, 30, 35)
#' n_ex <- c(50, 50, 50, 50, 50)
#' param_try <- c(theta = z_ex / n_ex, omega = sum(z_ex) / sum(n_ex), kappa = 2.01)
#' neg_log_lik(param = param_try, z = z_ex, n = n_ex)
#'
#' @export
neg_log_lik = function(param, z, n) {

  # Convert param components to meaningful names, and
  # ensure that the parameter values respect range restrictions:
  theta <- pmax(0.00001, pmin(0.99999, param[1:(length(param) - 2)]))  # All `param` but the last 2
  omega <- pmax(0.00001, pmin(0.99999, param[length(param) - 1]))      # All `param` but the last 1
  kappa <- pmax(2.00000, param[length(param)])                         # The last element in `param`

  # Convert `omega` and `kappa` to `a` and `b`:
  a <- omega * (kappa - 2) + 1
  b <- (1 - omega) * (kappa - 2) + 1

  # Compute log likelihood; first bernoulli, then beta, then add:
  log_p_data_g_theta <- z * log(theta) + (n - z) * log(1 - theta)           # vector
  log_p_theta_g_ab <- dbeta(x = theta, shape1 = a, shape2 = b, log = TRUE)  # vector
  neg_log_lik <- -sum(log_p_data_g_theta + log_p_theta_g_ab)

  return(neg_log_lik)

}

