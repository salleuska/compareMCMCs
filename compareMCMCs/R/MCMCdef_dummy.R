#' @export
MCMCdef_dummy <- function(MCMCinfo, 
                          MCMCcontrol, 
                          monitorInfo, 
                          modelInfo) {
  MCMCdef_dummy_impl(MCMCinfo,
                     MCMCcontrol, 
                     monitorInfo, 
                     modelInfo)
}

#' @export
MCMCdef_dummy_impl <- function(MCMCinfo,
                               MCMCcontrol, 
                               monitorInfo, 
                               modelInfo) {
  if(length(monitorInfo$monitorVars) == 0) {
    warning("No monitorVars provided to dummy MCMCdef.  Using 'param'.")
    monitorInfo$monitorVars <- 'param'
  }
  dummy_results <- matrix(
    rnorm(length(monitorInfo$monitorVars) * MCMCcontrol$niter),
    nrow = MCMCcontrol$niter,
    dimnames = list(NULL, monitorInfo$monitorVars)
  )
  dummytime <- system.time({})
  dummytime[1:5] <- c(60, 60, 60, 0, 0)
  result <- MCMCresult$new(samples = dummy_results,
                           times = list(sample = dummytime))
  return(result)
}
