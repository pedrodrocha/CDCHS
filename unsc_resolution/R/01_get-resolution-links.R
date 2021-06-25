# The packages we will need are:
library(RSelenium) # For scraping JS web pages
library(rvest) # For parsing and querying the html after JS filled the webpage
library(rstudioapi) # For send code to the terminal
library(stringr) # For string manipulation
library(tibble) # For building a tibble dataframe
library(dplyr) # For data manipulation
library(readr) # For importing and writing csv

# Source utils functions we created to help us during the scraping process
source("D:/Home/Projetos/artigos/artigo_raspagemDeDados/unsc_resolution/R/00_utils.R")


# Create a url of results by year using string manipulation
years <- seq(1946,2021,1)
base_url <- "https://digitallibrary.un.org/search?ln=en&cc=Security+Council&p=&f=&rm=&ln=en&sf=&so=d&rg=100&c=Security+Council&c=&of=hb&fti=0&fct__1=Resolutions+and+Decisions&fti=0&fct__1=Resolutions+and+Decisions&fct__3="
years_url <- paste0(base_url, as.character(years))

# Start and open  the selenium driver
terminalExecute('docker run --name r_selenium -d -p 4445:4444  selenium/standalone-chrome')

remDr <- remoteDriver(
  remoteServerAddr = 'localhost',
  port = 4445L,
  browserName = "chrome"
)
remDr$open(silent = FALSE)

# Create an empty vector for storing the resolution links
res_links <- vector()

for(i in seq_along(years_url)) {
  print(years_url[i])
  # Navigate to the link
  remDr$navigate(years_url[i])


  wait_load('css selector','.result-title a')   # Wait for JS to work and fill the page with content

  read_html(remDr$getCurrentUrl()[[1]]) %>%
    html_nodes('.result-title a') %>%
    html_attr('href') %>%
    paste0('https://digitallibrary.un.org',.) -> links

  res_links <- append(links, res_links)


  read_html(remDr$getCurrentUrl()[[1]]) %>%
    html_nodes('.searchresultsrecsfound strong') %>%
    html_text() %>%
    as.numeric() -> n_results

  if(n_results > 100) {

    el_next <-  remDr$findElement(
      using = 'css selector',
      value = '.searchresultsrecsfound img'
    )

    el_next$clickElement()

    wait_load('css selector','.result-title a') # Wait for JS to work and fill the page with content

    read_html(remDr$getCurrentUrl()[[1]]) %>%
      html_nodes('.result-title a') %>%
      html_attr('href') %>%
      paste0('https://digitallibrary.un.org',.) -> links

    res_links <- append(links, res_links)


  }

}

tibble(links = res_links) %>%
  distinct() %>%
  write_csv(.,"raw/2021-05-18_res-links.csv")


## Stop and remove the Selenium Driver
terminalExecute('docker stop r_selenium')
terminalExecute('docker container rm r_selenium')

