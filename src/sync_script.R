cur_time <- format(Sys.time(), "%Y-%m-%d-%H-%M")
fname1 <- paste0("camp.log.", cur_time)
fname2 <- paste0("master_data.rds.", cur_time)
cmd1 <- paste("scp", 
"vik@sta93.stat.nus.edu.sg:./ShinyApps/data_upload/camp.log",
 fname1, sep=" ")
cmd2 <- paste("scp", 
"vik@sta93.stat.nus.edu.sg:./ShinyApps/data_upload/master_data.rds",
 fname2, sep=" ")
system(cmd1)
system(cmd2)
