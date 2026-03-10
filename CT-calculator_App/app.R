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

      # Separator
      hr(style = "border-top: 1px solid #000000;"),

      # General infos
      h5("For our detector:"),
      h5(HTML("<ul><li>pixel pitch = 100 µm &times; 100 µm</li><li>active area = 400 mm &times; 400 mm</li></ul>")),
      h5("This means that 4000", HTML("&times;"), "4000 pixels per detector field are available."),
      h5("Extensions in X (VSensor, up to 11,400 pixels) and Y (multi|scan, up to 1.25 m) are possible but they increase both the scan time and the size of the resulting 3D model substantially."),

      # Separator
      hr(style = "border-top: 1px solid #000000;"),

      # Credit
      splitLayout(cellWidths = c("50%", "50%"),
                  actionButton("GitHub", "CT-calculator",
                               icon = icon("github", lib = "font-awesome"),
                               onclick = "window.open('https://github.com/ivan-paleo/CT-calculator', '_blank')"),
                  h5("By Ivan Calandra")),

      # Version number / date - ADJUST WITH NEW VERSION / DATE
      h5("v0.1 (2026-03-10)"),
      width = 3
    ),


    # 2.3. Main panel
    mainPanel(

      # Tabs
      tabsetPanel(type = "tabs",

        # Tabs, their UIs will be rendered in the server call below
        tabPanel("FOV", fluidRow(
          h2("Calculate field-of-view for a given voxel size"),
          numericInput("voxel_input", "Voxel size [µm]", value = 75, min = 1),

          # uiOutput is necessary to render the multiply symbol correctly
          uiOutput("fov_output")
        )),

        tabPanel("Voxel size", fluidRow(
          h2("Calculate voxel size for a given field-of-view"),
          numericInput("fov_input", "Field-of-view [mm]", value = 300, min = 1),
          uiOutput("voxel_output")
        )),

        tabPanel("Number of pixels", fluidRow(
          h2("Calculate the required number of detector pixels for a given voxel size and field-of-view"),
          numericInput("voxel_input2", "Voxel size [µm]", value = 75, min = 1),
          numericInput("fov_input2", "Field-of-view [mm]", value = 300, min = 1),
          uiOutput("pxnumber_output")
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
    HTML(paste("<b>The maximum field-of-view at the given voxel size is", 400*input$voxel_input/100, "&times;", 400*input$voxel_input/100, "mm.</b><br><br> This calculation assumes that all detector pixels are active, that no binning is applied and that only one detector field is used (i.e. image size = 4000 &times; 4000 pixels)."))
  })

  # 3.2 Output for tab 'Voxel size'
  output$voxel_output <- renderUI({
    HTML(paste("<b>The smallest voxel size at the given field-of-view is", 100*input$fov_input/400, "µm.</b><br><br> This calculation assumes that all detector pixels are active, that no binning is applied and that only one detector field is used (i.e. image size = 4000 &times; 4000 pixels)."))
  })

  # 3.3 Output for tab 'Number of pixels'
  output$pxnumber_output <- renderUI({

    # Different output depending on the result
    # If NumberPixels > 11400
    if (input$fov_input2*1000/input$voxel_input2 > 11400) {
      HTML(paste("<p style='color:red;'><b>This combination of voxel size and field-of-view requires", input$fov_input2*1000/input$voxel_input2, "&times;", input$fov_input2*1000/input$voxel_input2, "pixels, more pixels than available on this detector, even with VSensor.</b><br> Please adjust.</p>"))
    } else {

      # If 4000 < NumberPixels <= 7600
      if (input$fov_input2*1000/input$voxel_input2 > 4000 & input$fov_input2*1000/input$voxel_input2 <= 7600) {
        HTML(paste("<p style='color:red;'><b>This combination of voxel size and field-of-view requires", input$fov_input2*1000/input$voxel_input2, "&times;", input$fov_input2*1000/input$voxel_input2, "pixels, meaning that VSensor must be used with 2 fields.</p>"))
      } else {

        # If 7600 < NumberPixels <= 11400
        if (input$fov_input2*1000/input$voxel_input2 > 7600 & input$fov_input2*1000/input$voxel_input2 <= 11400) {
          HTML(paste("<p style='color:red;'><b>This combination of voxel size and field-of-view requires", input$fov_input2*1000/input$voxel_input2, "&times;", input$fov_input2*1000/input$voxel_input2, "pixels, meaning that VSensor must be used with 3 fields.</p>"))
        } else {

          # If NumberPixels <= 4000
          HTML(paste("<b>", input$fov_input2*1000/input$voxel_input2, "&times;", input$fov_input2*1000/input$voxel_input2, "pixels are required to scan the given field-of-view at the given voxel size.</b>"))
        }
      }
    }
  })
}


###############################################################################################################


##########################
# 4. Run the application #
##########################

# Run the application
shinyApp(ui = ui, server = server)


# END OF CODE #
