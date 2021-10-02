library(rvest)

url <- "https://en.wikipedia.org/wiki/Living_in_Darkness"

# the xpath to the table we are interested in
tracklist_xpath <- "//*[@id=\"mw-content-text\"]/div[1]/table[6]/tbody"

living_in_darkness <- read_html(url) %>%
  html_elements(xpath = tracklist_xpath) %>%
  html_table(header = TRUE, trim = TRUE, convert = FALSE)

living_in_darkness <- living_in_darkness[[1]]