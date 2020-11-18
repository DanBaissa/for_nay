library(rvest)
library(tidyverse)


artists <- c("eminem", "run_dmc")

artist_urls <- paste0("https://www.allthelyrics.com/lyrics/", artists)

finaldata <- c() #setting up an empty dataset for the end


for (j in 1:length(artist_urls)) {
  
  all <- read_html(artist_urls[j])
  
  raps <- all %>%
    html_nodes(".lyrics-list-item") %>%
    # html_attr("href")
    html_text()
  
  raps # Here are the raps
  
  
  urls <- all %>%
    html_nodes("a") %>%
    html_attr("href")
  
  urls.d <- data.frame(webpage = urls, line = 1:length(urls))
  raps.d <- data.frame(titles = raps, artist = "Eminem")
  
  
  lyric_data <- urls.d %>%
    slice(-(1:38)) %>%
    head(-13) %>%
    mutate(Artist = artists[j]) %>%
    mutate(titles = raps) %>%
    mutate(line = NULL) %>%
    mutate(webpage = paste0("https://www.allthelyrics.com", webpage))
  
  lyrics <- c()
  
  for(i in 1:length(lyric_data$webpage)){ 
    
    words <- read_html(lyric_data$webpage[i])
    lyrics[i] <- words %>%
      html_nodes(".content-text-inner") %>%
      html_text()
    
  }
  
  lyric_data_words <- lyric_data %>%
    mutate(words = lyrics)
  
  finaldata <- rbind(finaldata, lyric_data_words)
  
  
}

View(finaldata)

write.csv(finaldata, "finaldata.csv")
