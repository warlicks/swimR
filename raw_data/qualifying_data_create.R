library(devtools)

source("~/Documents/GitHub/swimR/raw_data/cut_times.R")
source("~/Documents/GitHub/swimR/raw_data/standard_clean.R")

D1Qualifying <- cut_times('https://swimswam.com/ncaa-releases-2016-2017-division-time-standards/')

D2Qualifying <- cut_times('https://swimswam.com/ncaa-division-ii-time-standards-released/', division = 2)

D3Qualifying <- cut_times('https://swimswam.com/ncaa-releases-division-iii-time-standards/', division = 3)

setwd("~/Documents/GitHub/swimR")

use_data(D1Qualifying)
use_data(D2Qualifying)
use_data(D3Qualifying)