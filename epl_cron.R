library(cronR)
setwd("~/projects/epl-pool/epl-pool")
cmd <- cron_rscript("scrape-21-22.R")
cmd

cron_add(command = cmd, frequency = 'daily', at='1PM', id = 'epl-pool-first', ask = TRUE)
cron_add(command = cmd, frequency = 'daily', at='4PM', id = 'epl-pool-second', ask = TRUE)
cron_add(command = cmd, frequency = 'daily', at='6PM', id = 'epl-pool-third', ask = TRUE)
cron_add(command = cmd, frequency = 'daily', at='11PM', id = 'epl-pool-fourth', ask = TRUE)
cron_add(command = cmd, frequency = 'daily', at='8PM', id = 'epl-pool-fifth', ask = TRUE)
