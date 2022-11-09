df <- mtcars
df <- df[1:5, 1:3 ]
data.table::setDT(df)

new_df <- data.frame(
	mpg = c(21,21,22,21.4,18.7),
	
)
