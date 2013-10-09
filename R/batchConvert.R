# total runtime
tStart = Sys.time();

cwd = getwd()
# first read the necessary files
source('convert.R')

sourceDirectory <- '~/net/O/stefanSchinkel/___AU_Net/RawData/'
targetDirectory <- '~/work/daten2/11.faces/converted'
setwd(sourceDirectory)

srcFiles <- list.files(pattern="AU Data 210*.")
for (s in srcFiles){ 

  if (grepl(pattern = '21030',s)) {
      cat('SKIPPING 21030')  
      next;
    }
    nChars  <- nchar(s)
    end     <- nChars - 4; # extension and dot
    start   <- end-4      # should be 5 but not for R so ?!?
    
    
    targetFile <- sprintf('%s/male%s.dat',targetDirectory,substr(s,start,end))
    convertCERT(s,targetFile)

}
# be nice and say goodbye
cat('Males');Sys.time()-tStart

srcFiles <- list.files(pattern="AU Data 220*.")
for (s in srcFiles){ 
  
  if (grepl(pattern = '22014',s)) {
    cat('SKIPPING 22014')  
    next;
  }
  nChars  <- nchar(s)
  end     <- nChars - 4; # extension and dot
  start   <- end-4      # should be 5 but not for R so ?!?
  
  
  targetFile <- sprintf('%s/female%s.dat',targetDirectory,substr(s,start,end))
  convertCERT(s,targetFile)
}
# be nice and say goodbye
cat('Females');Sys.time()-tStart

