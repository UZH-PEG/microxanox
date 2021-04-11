
get_nonlinearity <- function(x, y)
{
  lin_pred <- predict(lm(y ~ x))
  gam_pred <- predict(mgcv::gam(y ~ s(x)))
  L <- sqrt(sum((lin_pred-gam_pred)^2))/length(x)
  L
}
