library(miniCRAN)
tags <- c("plotly")
pkgDep(tags, suggests = FALSE )

dg <- makeDepGraph(tags, suggests = FALSE)
set.seed(1)
plot(dg, legendPosition = c(-1, -1), vertex.size = 10, cex = 0.7)
