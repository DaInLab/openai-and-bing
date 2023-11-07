# Install and load the 'text' package
if(!("text") %in% installed.packages()) install.packages("text")
library(text)

if(!("text2vec") %in% installed.packages()) install.packages("text2vec")
library(text2vec)

# Example documents
documents <- c("This is the first document.",
               "This document is the second document.",
               "And this is the third one.",
               "Is this the first document?")

# Create a document-term matrix
dtm <- create_dtm(documents)

# View the term-document matrix
print(dtm)
