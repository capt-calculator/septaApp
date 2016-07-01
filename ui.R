library(shiny)


pageWithSidebar(
    headerPanel('SEPTA Regional Rail Performance'),
    sidebarPanel(
        selectInput("trainSelect",
                    label="Choose train:",
                    choices=sort(as.numeric(unique(runTimes$train_id)))
        ),
        htmlOutput('source'),
        htmlOutput('destination'),
        htmlOutput('service'),
        htmlOutput('meanRunTime'),
        htmlOutput('meanDelay'),
        htmlOutput('otp'),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        HTML('<font face="Consolas"><p align="center">Created by Troy Walters | 
             <a href=http://www.troywalters.com>troywalters.com</a> | 
             Code available on <a href=http://github.com/capt-calculator/septaApp</a>
             </p></font>')
        
    ), 
    mainPanel(
        plotOutput("plot"),
        br(),
        leafletOutput('trainMap', height=450)
        

    )
)