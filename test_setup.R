library(htmltools)
library(digest)
library(sodium)
library(rvest)
library(xml2)

test <- read_html("test_hash.html")

head <- test %>% 
  html_nodes("head") %>% 
  html_nodes("script") %>% 
  as.character() %>% 
  paste(collapse = "")

body <- test %>% 
  html_nodes("body") %>% 
  html_children() %>% 
  as.character() %>% 
  paste(collapse = "")

doc <- paste0("<head>" , head , "</head><body>" , body , "</body>")

doc_digest = digest::digest(doc, serialize = FALSE, algo = "md5")


add_hashcheck <- function(path, output){
  
  
  if(missing(output)){
    output <- paste0(tools::file_path_sans_ext(path),"_hash.html")
  }
  
  js <- c(
    "<script src=\"https://code.jquery.com/jquery-3.5.1.min.js\" integrity=\"sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=\" crossorigin=\"anonymous\"></script>",
    "<script src=\"js/check_hash.js\"></script>",
    "<script src=\"js/notify.js\"></script>",
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/core.js\"></script>",
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/md5.js\"></script>"
  )
  
  
  html_doc <- read_html(path)

  head <- html_doc %>% 
    html_nodes("head") %>% 
    html_nodes("script") %>% 
    as.character() %>% 
    paste(c(js,.), collapse = "")
  
  body <- html_doc %>% 
    html_nodes("body") %>% 
    html_children() %>% 
    as.character() %>% 
    paste(collapse = "")
  
  
  doc <- paste0("<head>" , head , "</head><body>" , body , "</body>")
  
  doc_digest = digest::digest(doc, serialize = FALSE, algo = "md5")
  
  meta <- paste0("<meta name=\"content-hash\" content=\"",doc_digest,"\"/>")
  
  
  html_list <- as_list(html_doc)
  
  sections <- names(html_list$html)
  
  if("head" %in% sections){
    html_list$html$head <- c(
      as_list(read_html(paste0(js, collapse=""))),
      html_list$html$head
    )
  }else{
    html_list$html$head <- as_list(read_html(paste0(c("<head>" , js , "</head>"), collapse="\n")))$html$head
    html_list$html <- html_list$html[c(2,1)]
  }
  
  write_html(
    as_xml_document(html_list),
    file = output
  )
  
}
  

