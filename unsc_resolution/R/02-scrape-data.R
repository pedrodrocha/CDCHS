# The packages we will need are:
library(dplyr) # For data manipulation
library(tidyr) # For data manipulation
library(tibble) # for build a tibble dataframe
library(readr) # For importing and writing csv
library(rvest) # For web scraping
library(stringr) # For string manipulation


# Import the links we just collected in order to scrape their content
res_links <- read_csv('raw/2021-05-18_res-links.csv') %>%
  pull(links)

# Create an empty tibble for storing the data we will scrape
dat <- tibble::tibble()

# use a for loop for passing through each of the links scraping content and storing the values at the tibble dataframe
for (i in seq_along(res_links)) {
  print(paste(i,"-", res_links[i]))

  # Parse the html
  url_lido <- read_html(res_links[i])

  # Scrape the main variables available
  url_lido %>%
    html_nodes('.col-md-2') %>% # This is were they are located
    html_text() %>% # Extract the text from the result of the query
    Filter(x = ., f = function(x) {!str_detect(x,"\\$\\(document\\)") }) %>% # Filtering the result of the query so we eliminate results that contain this regex pattern, as we are not interested in it
    str_squish() -> colunas # Eliminated all white space from the results

  # Scrape the main infos. available related to the the variables we just scraped
  url_lido %>%
    html_nodes('.col-md-10') %>% # This is were they are located
    html_text() %>% # Extract the text from the result of the query
    str_squish() -> conteudo # Eliminated all white space from the results

  # Scrape the link from the pdf link related to the resolution
  url_lido %>%
    html_nodes('meta[name="citation_pdf_url"]') %>% # This is were it's located. Its easier to query by the meta tag
    html_attr('content') %>% # The content here is an attribute. So we use `html_attr`
    Filter(f = function(x){ str_detect(x, "EN")}) -> pdf_url # We filter for the documents in english, though there are other translations available


  if(length(pdf_url) == 0) { pdf_url <- NA}   # If there isn't an english version available, we are setting this value to be NA

  # Scrape the subjects related to the resolution. This variable is great for analyzing the main topics over time
  url_lido %>%
    html_nodes(".rs-list-row-inner") %>% # This is were they are located
    html_text() %>%  # Extract the text from the result of the query
    str_squish() %>% # Eliminated all white space from the results
    str_to_sentence() %>% # Decapitalize the text
    str_c(collapse = "; ") -> subjects # Collapse the results in a single string separated by "; "

  if(length(subjects) == 0) { subjects <- NA} # If there isn't subjects, we are setting this value to be NA

  # Scructure the dataset for storing the results of the queries
  dat <- tibble(
    colunas = colunas,
    conteudo = conteudo,
    Subjects = subjects,
    url = res_links[i],
    en_pdf_url = pdf_url,
  ) %>%
    pivot_wider(names_from = colunas, values_from = conteudo) %>% # Pivot to make sure that we have each variable scraped in a column of the dataset
    bind_rows(dat,.)  # Store the result at the tibble we created

}
# Save the result as csv
write_csv(dat, 'data/2021-05-19_res.csv')

