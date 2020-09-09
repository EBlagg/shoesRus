#setting up the dataframe
filepath <- list.files("/Users/erynblagg/Documents/CSAFE/shoescans/My_Scans", pattern = ".stl", full.names = T)
shoescans<-data.frame(filepath)
name<-gsub("/Users/erynblagg/Documents/CSAFE/shoescans/My_Scans/", "", filepath, fixed = TRUE)
shoescans$filenames <- gsub(".stl", "", name, fixed = TRUE)
shoescans$date<-as.Date(as.character(as.numeric(unlist(regmatches(shoescans$filenames, gregexpr("[[:digit:]]+", shoescans$filenames ))))),format="%Y%m%d")
shoescans$side<-stringr::str_extract(shoescans$filenames,"[RL]")
front<-sub("\\_.*", "", shoescans$filenames)
shoescans$brand<-stringr::str_replace(front, "[LR]", "")
shoescans<-shoescans%>%group_by(brand,side)%>%arrange(date) %>% mutate(scan_no=1:n())
shoescans$mesh<-shoescans$filepath%>%purrr::map( function(x){Rvcg::vcgImport(as.character(x), clean = T)})


#extracting each row
for(i in 1:nrow(shoescans)){
shoe<-shoescans[i,]

assign(paste(shoe$brand, shoe$side, shoe$scan_no, sep = "_" ),shoe)
}


usethis::use_data(saucony_R_1)



