#Set the main directory
directory = 'data'

#Set the directory to save the files
s_dir = 'data/Organized_by_Date'

#List all the files in the folders. If recursive = T, it will list files in folders inside the derectory
files = list.files(directory, full.names = TRUE, recursive = F)

#Create a empty list to storage the date information
date_l = list()

#Create a dummie df to storage the date and the file related to it
df_date = data.frame(1,2)
names(df_date) = c('date', 'filename')

#Read each file metadata and get the information about the creation date and save everything in a list
for (i in 1:length(files)){
  file = files[i]
  df_date$date = as.Date(file.info(file)$ctime)
  df_date$filename = file
  date_l[[i]] = df_date
}

files_date = do.call(rbind, date_l)


dates = sort(unique(files_date$date))
dates = as.character(dates)


#Based on the dataframe created, select the files by date and save it according to it   
for (date in dates){
  print(date)
  save_list = files_date[files_date$date == date,]
  save_list = c(save_list$filename)
  to_file = file.path(s_dir, date)
  dir.create(to_file, recursive = T)
  file.copy(save_list, to_file, overwrite = T)
  }





