### sensory.R: set up the sensory data set
### $Id: sensory.R 2 2005-03-29 14:31:42Z  $

sensory <- data.frame(Quality = I(as.matrix(read.table("quality"))),
                      Panel = I(as.matrix(read.table("panel"))))
