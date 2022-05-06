library(reshape2)
# load test set
X_test <- read.table("test/X_test.txt", quote="\"", comment.char="")
# load training set
X_train <- read.table("train/X_train.txt", quote="\"", comment.char="")
# merge the sets
df_final <- rbind(X_test, X_train)
# load the features file
features <- read.table("features.txt", quote="\"", comment.char="")
# filter the features with the word "mean" and "sd"
features_2 <- features[grepl("[Mm]ean|[Ss]td",features$V2),]
# filter the mean and standard deviation columns in the data.set
df_final <- df_final[,features_2$V1]
# create a vector of the name of the columns
nm_columns <- features_2$V2
# remove the "()" character
nm_columns <- gsub("\\(\\)","",nm_columns)
# replace the "(" character for "_"
nm_columns <- gsub("\\(","_",nm_columns)
# remove the ")" character
nm_columns <- gsub("\\)","",nm_columns)
# replace the commas for "_"
nm_columns <- gsub("\\,","_",nm_columns)
# replace the "-" for "_"
nm_columns <- gsub("\\-","_",nm_columns)
# rename columns
colnames(df_final) <- nm_columns
# assess the mean of the variables
df_final_mean <- as.data.frame(apply(df_final, 2, mean))
# create a column of the activities
df_final_mean$activity <- rownames(df_final_mean)
# delete rownames
rownames(df_final_mean) <- NULL
# rename columns
colnames(df_final_mean) <- c("mean","activity")
# melt the data in order to put the activity in the columns
df_final_mean <- melt(df_final_mean)
# order the columns
df_final_mean <- dcast(df_final_mean, variable ~ activity, value.var = "value")
# write the dataset
write.table(df_final_mean, "df_final_mean.txt", row.names = F)

