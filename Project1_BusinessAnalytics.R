getwd()
setwd("C:\\Users\\Diwakar Talanki\\Desktop\\Project1")
file_list <- list.files()

var_names <- c("SepalLength","SepalWidth", "PetalLength", "PetalWidth", "Class")                 
var_names                                  # Creating the variabe names(column Header)

###### forming a loop to append all .dat files ######

irisdata <- data.frame()                    # creating a empty data frame

for(file in file_list) {
  temp_irisdata <- read.delim(file ,  sep = "," ,stringsAsFactors = FALSE,header = FALSE ,skip = 9, col.names =var_names)
  irisdata <-rbind(irisdata, temp_irisdata) 
  rm(temp_irisdata)
}

nrow(irisdata)
head(irisdata)
class(irisdata)
str(irisdata)
irisdata$SepalLength <- as.numeric(as.character(irisdata$SepalLength))
irisdata$SepalWidth <- as.numeric(as.character(irisdata$SepalWidth))
irisdata$PetalWidth <- as.numeric(as.character(irisdata$PetalWidth))
irisdata$PetalLength <- as.numeric(as.character(irisdata$PetalLength))
str(irisdata)

#########################################################

#Part II
#The data is present in xml format, with file name, iris.xml. Your task is to read the XML data and store it
#in the data frame df.


install.packages("XML")
library(XML)

dat_xml <- "C:\\Users\\Diwakar Talanki\\Desktop\\Project1\\iris.xml"
df <- xmlToDataFrame(dat_xml)
View(df)
str(df)

#########################################################

#Part III
#Convert the iris data into the JSON format and read the data in JSON format and convert it into
#dataframe "iris_data".


install.packages("rjson")
install.packages("jsonlite")
install.packages("RJSONIO")
install.packages("tidyjson")

library(rjson)
library(jsonlite)
library(RJSONIO)
library(tidyjson)

View(iris)

# Now you have a list of data frames, connect them together in
# one single dataframe
#df <- do.call(rbind, Append_data_tables)
#View(df)

# To convert Iris dataset into JSON format then
# toJSON() needs to be used as follow---

ij <- toJSON(iris, pretty = TRUE)
iris_json_format<-cat(ij)
write_json(ij,"iris_df_jsonformat.json")


# To convert Iris dataset in JSON format once again to dataframe then----

iris_df <- fromJSON(ij)
iris_df
class(iris_df)
AAA<-as.data.frame(iris_df)
View(AAA)
class(AAA)

##############################################################

#Part IV
#Use dplyr function on the data iris_data. Implement -----
#select, #match, #filter, #arrange, #rename, and#mutate 
#functions on the iris_data.
#-----------------------Select -----------------
#Select() selects variables by name. select() keeps only the variables that are mentioned.

install.packages("dplyr")
library(dplyr)
#Syntax: 
select(.data, ...)

select(as_data_frame(iris), Sepal.Length,Sepal.Width)


# Select only the specific columns as follows:-

select(iris,Petal.Length,Sepal.Width)


distinct_df_PL = iris %>% distinct(Petal.Length) %>% select(Petal.Length)
View(distinct_df_PL)

# Selection of distinct/unique values from specified columns within the 
# given data frame

distinct_df_SW = iris %>% distinct(Sepal.Width) %>% select(Sepal.Width)
View(distinct_df_SW)

distinct_df_Species = iris %>% distinct(Species) %>% select(Species)
View(distinct_df_Species)

# OR ---

iris %>% 
  as_data_frame %>%
  select(Petal.Length, Petal.Width,Species)

# To drop the variables from the table , we use minus sign before concatenation() 
# before the specified variable names that needs to be dropped as follows:-

mydata <- select(iris, -c(Sepal.Length,Sepal.Width))
mydata

#####################################################################

# --------------------------Match-----------------------

# matches() isa function from dplyr package.
# It works only on Column names or Variable Names having exact "search-string" matches  
# within the given dataframe. 
# It is case-sensitive. 
# It does NOT search for matching strings within the rows of the given dataframe.i.e. it 
# does not search for matching strings within the given character values.
# In brief, it works only on Variables/Columns having the exact string matches.


# Syntax:  
select(data, matches("search_string"))


select(iris, matches("Petal"))

# Herein the two column  names viz. ---- Petal.Length  and Petal.Width are selected 
# as per the given argument.

#######################################################################################

# --------------------------Filter--------------------------------
# filter() is a function from dplyr package.
# Use filter() to find rows where conditions are true
# It filter (subset) rows.
# It is equivalent to WHERE from SQL.

# Syntax:
filter(.data, ...)

#Useful filter functions
#  . ==, >, >= etc
#  . &, |, !, xor()
#  . is.na()
#  . between(), near()

# filter() for a single criteria
# It searches for the specified criteria within the rows as follows:---

filter(iris, Species == "versicolor")

filter(iris, Sepal.Length < 4.5)
filter(iris,Petal.Length>6)

# filter() for a multiple criteria
# It searches for the specified criteria within the rows as follows:---   

filter(iris, Sepal.Length == "NA" | Petal.Length == 4.5)

filter(iris, Petal.Length >=6.5 ,Species == "virginica")

# Or--
# Using filter()to find value(s) by using piping operator as follows:---

iris %>% 
  select(Sepal.Length, Petal.Length,Species) %>%
  filter(Species == "setosa")

iris %>% 
  select(Petal.Length,Sepal.Width,Species) %>%
  filter(Petal.Length>= 4.5 & Sepal.Width<=2.5,Species == "versicolor")

# In the below-mentioned code, in order to exclude Species starting with letters/character values "SE"--

iris %>% 
  select(Sepal.Length,Sepal.Width,Species) %>%
  filter(Species != "SE" & Sepal.Length >= 6.9)%>%
  summarise(mean(Sepal.Width, na.rm = TRUE))

##################################################################################################

# ---------------------Arrange-------------------------------------

# arrange() arranges rows by the variable names or in simple terms---sorts the data.
# It forms a part of dplyr package.
# By default arrange() sorts the rows in an ascending order
# In case if descending values are desired then arrange() needs to be combined with desc().
#arrange() is eq1uivalent to ORDER BY in SQL

# Syntax:
#arrange(data_frame, variable(s)_to_sort)
# or
#data_frame %>% arrange(variable(s)_to_sort)
# To sort a variable in descending order, use desc(x).


arrange(iris, Petal.Length, Petal.Width)

arrange(iris, Petal.Length, desc(Petal.Width))
arrange(iris, Sepal.Width, desc(Petal.Width))

# By using arrange_all() then-----

arrange_all(iris, desc)

# OR By using Pipe Operator---

iris %>% 
  select(Petal.Length,Petal.Width,Species) %>%
  arrange(Petal.Length, desc(Petal.Width)) %>% 
  filter(Petal.Length<= 3.5)


iris %>% 
  select(Sepal.Length,Sepal.Width,Species) %>%
  arrange(Sepal.Length, desc(Sepal.Width)) %>% 
  filter(Species!= 'setosa' & Sepal.Width<=2.5)

###################################################################################### 

# ---------------------Rename---------------------------------


#Syntax:
rename(.data, ...)

rename(iris, petal_length = Petal.Length)
rename(iris, petal_width = Petal.Width)
rename(iris, Sepal_length = Sepal.Length)
rename(iris, Sepal_width = Sepal.Width)

# OR----

rename_demo<- rename(iris,petal_length = Petal.Length, petal_width = Petal.Width,Sepal_length = Sepal.Length, Sepal_Width=Sepal.Width)
View(rename_demo)

# OR-----


library(dplyr)
iris %>% 
  as_data_frame %>%
  rename(petalLth = Petal.Length)

# OR  ----

rename_demo_B <- rename(iris, Sepal.Wth = Sepal.Width, Species_Varieties=Species)
View(rename_demo_B)
######################################################################################

# -----------------------Mutate-----------------------------------
# Syntax:
mutate(.data, ...)

# Newly created variables are available immediately
iris_data_calc<- iris %>% as_tibble() %>% mutate(
  Sepal.Area = (Sepal.Length * Sepal.Width),
  Petal.Area=(Petal.Length * Petal.Width))
View(iris_data_calc)


# Using mutuate() to create Ranks based on Sepal.Area:-----

Rank_Sepal_Area<-iris_data_calc %>% mutate(rank=dense_rank(desc(Sepal.Area)))
View(Rank_Sepal_Area)
iris_sepal_ranking<-arrange(Rank_Sepal_Area, rank)

View(iris_sepal_ranking)

# Using mutuate() to create Ranks based on Petal.Area:----

Rank_Petal_Area<-iris_data_calc %>% mutate(rank=dense_rank(desc(Petal.Area)))
View(Rank_Petal_Area)
iris_petal_ranking<-arrange(Rank_Petal_Area, rank)

View(iris_petal_ranking)

# mutate()  is also used to remove variables and modify 
# the existing variables
iris %>% as_tibble() %>% mutate(
  Petal.Length = NULL,
  Petal.Width = Petal.Width * 0.016 
)

#Part V
#Print the summary of iris_data

summary.data.frame(iris)
# or
summary(iris)

class(iris)
View(iris)

# OR---Some more Descriptive Statistics

iris <- group_by(Species)
summarise(iris, Sepal_Lt_Mean=mean(Sepal.Length),Sepal_Wt_Mean=mean(Sepal.Width),
          Petal_Lt_Mean=mean(Petal.Length),Petal_Wt_Mean=mean(Petal.Width),
          Sepal_Wt_SD=sd(Sepal.Width),Petal_Wt_SD=sd(Petal.Width),
          Sepal_Wt_Var=var(Sepal.Width),Petal_Wt_Var=sd(Petal.Width))

#####################################################################




