MCMCdef_jags <- function(MCMCinfo, 
                         MCMCcontrol, 
                         monitorInfo, 
                         modelInfo) {
  MCMCdef_jags_impl(MCMCinfo,
                    MCMCcontrol, 
                    monitorInfo, 
                    modelInfo)
}

MCMCdef_jags_impl <- function(MCMCinfo,
                              MCMCcontrol, 
                              monitorInfo, 
                              modelInfo) {
  if(requireNamespace('rjags', quietly = TRUE)) {
    modelFileName <- 'model.txt'
    code <- modelInfo$code
    constantsAndData <- c(modelInfo$constants, modelInfo$data)
    writeLines(paste0('model\n', paste0(deparse(code), collapse='\n')),
               con=modelFileName)
    jags_mod <- rjags::jags.model(file=modelFileName,
                                  data=constantsAndData,
                                  inits=modelInfo$inits,
                                  n.chains=1,
                                  quiet=FALSE)
    timeResult <- system.time({
      jags_out <- rjags::coda.samples(model=jags_mod,
                                      variable.names=monitorInfo$monitorVars,
                                      n.iter=MCMCcontrol$niter,
                                      thin=MCMCcontrol$thin)
    })
    monitorNodesBUGS <<- gsub(' ', '', monitorInfo$monitors)
    samplesArray <- jags_out[[1]][
      (MCMCcontrol$burnin+1):floor(MCMCcontrol$niter/MCMCcontrol$thin),
      monitorNodesBUGS,
      drop=FALSE]
    result <- MCMCresult$new(samples = samplesArray,
                             times = list(sample = timeResult))
    unlink(modelFileName)
    return(result)
  } else {
    stop("run_jags: rjags package is required for 'jags' option.  jags will not be run.\n")
    return(NULL)
  }
}
