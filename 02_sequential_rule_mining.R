library(arulesSequences)
options(max.print=999999)
baskets <- read_baskets(con = "arules_input_final.txt", sep = "[ \t]+",
                        info = c("sequenceID","eventID","SIZE"))
s1 <- cspade(baskets, parameter = list(support =  0.15, maxsize=1),
             control = list (verbose = TRUE, 
                            tidLists = TRUE, 
                            memsize = 100000,
                            numpart =30))
df = as(ruleInduction(s1 , confidence = 0.15), "data.frame")
write.table(df, "association_rules_final.txt", sep = "\t", row.names = FALSE)
