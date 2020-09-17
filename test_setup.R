library(digest)
library(sodium)
library(rvest)
library(xml2)

add_hashcheck <- function(path, output){
  
  
  if(missing(output)){
    output <- paste0(tools::file_path_sans_ext(path),"_hash.html")
  }
  
  js <- c(
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/core.js\"></script>",
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/md5.js\"></script>",
    "<script src=\"js/check_hash.js\"></script>"
  )
  
  
  html_doc <- read_html(path)

  head <- html_doc %>% 
    html_nodes("head")
  
  scripts <- head %>% 
    html_nodes("script") %>% 
    as.character() %>% 
    c(js,.)
  
  body <- html_doc %>% 
    html_nodes("body") %>% 
    html_children() %>% 
    as.character()
  
  doc <- paste0("<head>" ,paste(scripts, collapse = "")  , "</head><body>" , paste(body,collapse = "") , "</body>")
  
  doc_digest = digest::digest(doc, serialize = FALSE, algo = "md5")
  
  meta <- paste0("<meta name=\"content-hash\" content=\"",doc_digest,"\"/>")
  
  doc <- c("<html>","<head>" , meta ,js, as.character(head) , "</head>","<body>" , body , "</body>","</html>")
  
  cat(
    doc,
    sep = "\n",
    file = output
  )
  
}
  


