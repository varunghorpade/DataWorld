##### Project Report with Gantt Chart #####

rm(list = ls()) # Clearing the workspace

library(plotly)
library(RColorBrewer)
library(readxl)

report <- read_excel("/Applications/Gantt_Chart_R.xls")

report$`Start Date` <- as.Date(report$`Start Date`, format = "%m/%d")
report$`End Date` <- as.Date(report$`End Date`, format = "%m/%d")

project <- "ABC"

# Colors based on the Phase of the project
cols <- RColorBrewer::brewer.pal(length(unique(report$Phase)), name = "Set3")
report$color <- factor(report$Phase, labels = cols)

p <- plot_ly() # Initializing the empty plot


# Creating TRACE for each task
# Representing those TRACES with thick line
for(i in 1:(nrow(report))){
  p <- add_trace(p,
                 x = c(report$`Start Date`[i], report$`Start Date`[i] + report$Duration[i]), # X axis for Dates
                 y = c(i, i),
                 mode = "lines",
                 line = list(color = report$color[i], width = 40),
                 showlegend = F,
                 hoverinfo = "text",
                 
                 text = paste("Phase: ", report$Phase[i], "
                              ",
                              "Task: ", report$Tasks[i], "<br"
                              ,
                              "Start Date: ", report$`Start Date`[i], "
                              ",
                              "Duration: ", report$Duration[i], "days: 
                              ",
                              "Progress: ", report$Progress[i], "
                              ",
                              "End Date: ", report$`End Date`[i], "
                              ",
                              "Person Responsible: ", report$`Assigned To`[i]),
                 evaluate = T
  )
}
p

# Layout desgining
p <- layout(p,
            
            xaxis = list(showgrid = F, tickfont = list(color = "#e6e6e6")),
            yaixs = list(showgrid = F, tickfont = list(color = "#e6e6e6"),
                         tickmode = "array", tickvals = 1:nrow(report), ticktext = unique(report$Tasks),
                         domain = c(0,0.9), ylab = "Tasks"),
            
            annotations = list(
              list(xref = "paper", yref = "paper",
                   x = 0.80, y = 0.1,
                   text = paste0("Total Duration: ", sum(report$Duration), " days
                                 ",
                                 "Tasks Completed: 3/7", "
                                 ",
                                 "Tasks left: 4/7", "
                                 ",
                                 "Total Tasks: ", nrow(report), " tasks
                                 ",
                                 "Total Responsible Person: ", length(unique(report$`Assigned To`)), "
                                 "),
                   font = list(color = '#ffff66', size = 12),
                   ax = 0,
                   ay = 0,
                   align = "left"),
              
              list(xref = "paper", yref = "paper",
                   x = 0.1, y = 1, xanchor = "left", 
                   text = paste0("PROJECT TITLE: ", project),
                   font = list(color = "#f2f2f2", size = 20, family = "Times New Roman"),
                   ax = 0, ay = 0, 
                   align = "left")
              ),
            
            plot_bgcolor = "#333333",
            paper_bgcolor = "#333333")
p

