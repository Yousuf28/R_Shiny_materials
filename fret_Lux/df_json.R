
df <- mtcars[1:5, 1:3]
df_tib <- tibble::as_tibble(df)
dt <- data.table::as.data.table(df)
df_js  <-  jsonlite::toJSON(df)
tib_js <-  jsonlite::toJSON(df_tib)
dt_js  <-  jsonlite::toJSON(dt)
print("tojson")
print(df)
df = gsub("],", ",", tib_js)
df = gsub(":\\[", ":",df)
df = gsub("[[:space:]]", "", df)
