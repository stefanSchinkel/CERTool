convertCERT <- function(source, target){
        # # Sample USE:
        #
        # convertCERT("c:\\CERT\\AU Data 21001.txt","c:\\CERT\\PROC\\dat_all_21001.txt")
        # 
        # Or in batch mode: 
        #
        # sourceDirectory = '/Users/jondoe/CERT/'
        # targetDirectory = '/Users/jondoe/CERT/processed/'
        # source('convert.R')
        # setwd(sourceDirectory)
        # srcFiles = list.files(pattern="AU.*Data.*.txt")
        # for (s in srcFiles){ 
        #       source = sprintf('%s%s',sourceDirectory,s)
        #       target = sprintf('%s%s',targetDirectory,s)
        #       convertCERT(source,target)
        # }

        # feedback and timer
        spacer()
        cat( sprintf('Converting from %s to %s  \n',source,target) )
        spacer()
        tStart = Sys.time()

        # read data, skipping header
        dat <- read.table(source, sep="\t", skip=3)

        # fill in column names
        names(dat) <- c("subj", "MouthImpX", "MouthImpY", "LeftEyeImpX", "LeftEyeImpY", "RightEyeImpX", "RightEyeImpY", "MouthLeftCornerImpX", 
                "MouthLeftCornerImpY", "RightEyeNasalImpX", "RightEyeNasalImpY", "MouthRightCornerImpX", "MouthRightCornerImpY", 
                "RightEyeTemporalImpX", 
                "RightEyeTemporalImpY", "LeftEyeTemporalImpX", "LeftEyeTemporalImpY", "LeftEyeNasalImpX", "LeftEyeNasalImpY", 
                "NoseImpX", "NoseImpY", "MouthLeftCornerX", "MouthLeftCornerY", "MouthRightCornerX", "MouthRightCornerY", 
                "A1", "A2", "A4", "A5", "A9", "A10", 
                "A12", "A14", "A15", "A17", "A20", 
                "A6", "A7", "A18", "A23", "A24", "A25", 
                "A26", "A28", "A45BlinkEyeClosure", "FearBrow124", "DistressBrow114", 
                "A10L", "A12L", "A14L", "A10R", "A12R", "A14R", "Gender", "Glasses", "Yaw", "Pitch", 
                "Roll", "SmileDetector", "Angerv3", "Contemptv3", "Disgustv3", "Fearv3", "Joyv3", "Sadv3", 
                "Surprisev3", "Neutralv3")

        # consider re-ordering to better match AU oder in ML
        # once this is fully establiched
        dat <- dat[, c("subj",
                "A1",   "A2",   # ###########################
				"A4",   "A5",   # THOSE AU  HAVE TO 		#
				"A6",   "A7",	# BE SPLIT IN MATLAB		#
				"A9",   		#############################
				"A10R",	"A10L",  
				"A12R", "A12L", 
				"A14R", "A14L",
                "A15",  		# THIS ONE TOO
				"A17",  
				"A20",    		# THIS ONE TOO
				"A23",	"A24",  "A25",  "A26",  "A28"  
 )]


        ###Trial Coding
        # Init empty 
        dat$task<-rep(NA, dim(dat)[1])
        dat$trial<-rep(NA, dim(dat)[1])
        dat$TrialReq_n<-rep(NA, dim(dat)[1])
        dat$TrialReq_c<-rep(NA, dim(dat)[1])

        # fill by indexing per trial
        idx <- 1:125;dat$task[idx] = 1;dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 126:250;dat$task[idx] = 1; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 251:375;dat$task[idx] = 1; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 376:500;dat$task[idx] = 1; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 501:625;dat$task[idx] = 1; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 626:750;dat$task[idx] = 1; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 751:875;dat$task[idx] = 1; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 876:1000;dat$task[idx] = 1; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1001:1125;dat$task[idx] = 1; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1126:1250;dat$task[idx] = 1; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1251:1375;dat$task[idx] = 1; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1376:1500;dat$task[idx] = 1; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1501:1625;dat$task[idx] = 1; dat$trial[idx] = 13;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 1626:1750;dat$task[idx] = 2; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 1751:1875;dat$task[idx] = 2; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 1876:2000;dat$task[idx] = 2; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 2001:2125;dat$task[idx] = 2; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 2126:2250;dat$task[idx] = 2; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 2251:2375;dat$task[idx] = 2; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 2376:2500;dat$task[idx] = 2; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 2501:2625;dat$task[idx] = 2; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 2626:2750;dat$task[idx] = 2; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 2751:2875;dat$task[idx] = 2; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 2876:3000;dat$task[idx] = 2; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 3001:3125;dat$task[idx] = 2; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 3126:3250;dat$task[idx] = 3; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 3251:3375;dat$task[idx] = 3; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 3376:3500;dat$task[idx] = 3; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 3501:3625;dat$task[idx] = 3; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 3626:3750;dat$task[idx] = 3; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 3751:3875;dat$task[idx] = 3; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 3876:4000;dat$task[idx] = 3; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 4001:4125;dat$task[idx] = 3; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 4126:4250;dat$task[idx] = 3; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 4251:4375;dat$task[idx] = 3; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 4376:4500;dat$task[idx] = 3; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 4501:4625;dat$task[idx] = 3; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 4653:4777;dat$task[idx] = 4; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 4808:4932;dat$task[idx] = 4; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 4985:5109;dat$task[idx] = 4; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 5144:5268;dat$task[idx] = 4; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 5311:5435;dat$task[idx] = 4; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 5479:5603;dat$task[idx] = 4; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 5643:5767;dat$task[idx] = 4; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 5816:5940;dat$task[idx] = 4; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 5980:6104;dat$task[idx] = 4; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 6143:6267;dat$task[idx] = 4; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 6304:6428;dat$task[idx] = 4; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 6480:6604;dat$task[idx] = 4; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 6646:6770;dat$task[idx] = 4; dat$trial[idx] = 13;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 6810:6934;dat$task[idx] = 4; dat$trial[idx] = 14;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 6981:7105;dat$task[idx] = 4; dat$trial[idx] = 15;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 7148:7272;dat$task[idx] = 4; dat$trial[idx] = 16;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 7312:7436;dat$task[idx] = 4; dat$trial[idx] = 17;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 7483:7607;dat$task[idx] = 4; dat$trial[idx] = 18;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 7644:7768;dat$task[idx] = 4; dat$trial[idx] = 19;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 7812:7936;dat$task[idx] = 4; dat$trial[idx] = 20;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 7981:8105;dat$task[idx] = 4; dat$trial[idx] = 21;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 8151:8275;dat$task[idx] = 4; dat$trial[idx] = 22;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 8315:8439;dat$task[idx] = 4; dat$trial[idx] = 23;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 8480:8604;dat$task[idx] = 4; dat$trial[idx] = 24;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 8626:8751;dat$task[idx] = 5; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 8752:8876;dat$task[idx] = 5; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 8877:9001;dat$task[idx] = 5; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 9002:9126;dat$task[idx] = 5; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 9127:9251;dat$task[idx] = 5; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 9252:9376;dat$task[idx] = 5; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 9377:9501;dat$task[idx] = 5; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 9502:9626;dat$task[idx] = 5; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 9627:9751;dat$task[idx] = 5; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 9752:9876;dat$task[idx] = 5; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 9877:10001;dat$task[idx] = 5; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 10002:10126;dat$task[idx] = 5; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 10127:10251;dat$task[idx] = 6; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 10252:10376;dat$task[idx] = 6; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 10377:10501;dat$task[idx] = 6; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 10502:10626;dat$task[idx] = 6; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 7; dat$TrialReq_c[idx] = c("SU");
        idx <- 10627:10751;dat$task[idx] = 6; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 2; dat$TrialReq_c[idx] = c("DI");
        idx <- 10752:10876;dat$task[idx] = 6; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 10877:11001;dat$task[idx] = 6; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 11002:11126;dat$task[idx] = 6; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 6; dat$TrialReq_c[idx] = c("SA");
        idx <- 11127:11251;dat$task[idx] = 6; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 11252:11376;dat$task[idx] = 6; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 3; dat$TrialReq_c[idx] = c("FE");
        idx <- 11377:11501;dat$task[idx] = 6; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 4; dat$TrialReq_c[idx] = c("HA");
        idx <- 11502:11626;dat$task[idx] = 6; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 1; dat$TrialReq_c[idx] = c("AN");
        idx <- 11627:11751;dat$task[idx] = 7; dat$trial[idx] = 1;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 11752:11876;dat$task[idx] = 7; dat$trial[idx] = 2;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 11877:12001;dat$task[idx] = 7; dat$trial[idx] = 3;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12002:12126;dat$task[idx] = 7; dat$trial[idx] = 4;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12127:12251;dat$task[idx] = 7; dat$trial[idx] = 5;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12252:12376;dat$task[idx] = 7; dat$trial[idx] = 6;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12377:12501;dat$task[idx] = 7; dat$trial[idx] = 7;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12502:12626;dat$task[idx] = 7; dat$trial[idx] = 8;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12627:12751;dat$task[idx] = 7; dat$trial[idx] = 9;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12752:12876;dat$task[idx] = 7; dat$trial[idx] = 10;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 12877:13001;dat$task[idx] = 7; dat$trial[idx] = 11;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");
        idx <- 13002:13126;dat$task[idx] = 7; dat$trial[idx] = 12;  dat$TrialReq_n[idx] = 5; dat$TrialReq_c[idx] = c("NE");


        # write out, removing any possibly existing files 
        write.table(dat, target, quote = F, row.names = F, append = F)

        # be nice and say goodbye
  #      cat( sprintf('Converstion took %.1f secs. Have a nice day\n',Sys.time()-tStart) )
}

##########################################
### HELPER FUNCTIONS    ####
############################
spacer <- function(sym="+",x=45){
        s <-cat( paste( rep(sym,x) ),'\n',sep='' )
        cat(s)
} #spacer
