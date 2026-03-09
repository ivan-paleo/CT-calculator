# Shiny app to calculate voxel size, FOV and number of pixels for CT scans at the IMPALA/VOXEL lab
# Written by Ivan Calandra

###############################################################################################################


#####################
# 1. Load libraries #
#####################

library(shiny)


###############################################################################################################


################
# 2. Define UI #
################

ui <- fluidPage(

  # 2.1. Application title
  titlePanel("Calculate FOV, voxel size and number of pixels for CT scans at the IMPALA / VOXEL"),

  sidebarLayout(


    # 2.2. Sidebar
    sidebarPanel(

      # LEIZA logo
      img(src = "Leiza_Logo_Deskriptor_CMYK_rot_LEIZA.png", height = 150),

      # Credit
      splitLayout(cellWidths = c("50%", "50%"),
                  h5("By Ivan Calandra"),
                  actionButton("GitHub", "CT-calculator",
                               icon = icon("github", lib = "font-awesome"),
                               onclick = "window.open('hhttps://github.com/ivan-paleo/CT-voxel-FOV-calculator', '_blank')")),

      # Version number / date - ADJUST WITH NEW VERSION / DATE
      h5("v0.1 (2026-03-09)"),
      width = 3
    ),


    # 2.3. Main panel
    mainPanel(

      # Tabs
      tabsetPanel(type = "tabs",

        # Tabs, their UIs will be rendered in the server call below
        tabPanel("FOV", fluidRow(
          h2("Calculate field-of-view for a given voxel size"),
          h5("For our detector, pixel size = 100 µm and active area = 400 mm ", HTML("&times;"), "400 mm."),
          numericInput("voxel_input", "Voxel size [µm]", value = 75),

          # uiOutput is necessary to render the multiply symbol correctly
          uiOutput("fov_output")
        )),

        tabPanel("Voxel size", fluidRow(
          h2("Calculate voxel size for a given field-of-view"),
          h5("For our detector, pixel size = 100 µm and active area = 400 mm ", HTML("&times;"), "400 mm."),
          numericInput("fov_input", "Field-of-view [mm]", value = 300),
          textOutput("voxel_output")
        )),

        tabPanel("Number of pixels", fluidRow(
          h2("Calculate the required number of detector pixels for a given voxel size and field-of-view"),
          h5("For our detector, pixel size = 100 µm and active area = 400 mm ", HTML("&times;"), "400 mm, meaning that 4000", HTML("&times;"), "4000 pixels are available."),
          numericInput("voxel_input", "Voxel size [µm]", value = 75),
          numericInput("fov_input", "Field-of-view [mm]", value = 300),
          textOutput("pxnumber_output")
        ))
      )
    )
  )
)


###############################################################################################################


##########################
# 3. Define server logic #
##########################

server <- function(input, output) {

  # 3.1 Output for tab 'FOV'
  # renderUI is necessary to render the multiply symbol correctly
  output$fov_output <- renderUI({
    HTML(paste("The field-of-view at the given voxel size is", 400/(0.1*1000/input$voxel_input), "&times;", 400/(0.1*1000/input$voxel_input), "mm."))
  })

  # 3.2 Output for tab 'Voxel size'
  output$voxel_output <- renderText({
    paste("The voxel size at the given field-of-view is", 0.1*1000/(400/input$fov_input), "µm.")
  })

  # 3.3 Output for tab 'Number of pixels'
  output$pxnumber_output <- renderText({
    paste((input$fov_input*(0.1*1000/input$voxel_input))/0.1, "pixels are required to scan the given field-of-view at the given voxel size.")
  })
}


###############################################################################################################


##########################
# 4. Run the application #
##########################

# Run the application
shinyApp(ui = ui, server = server)


# END OF CODE #
