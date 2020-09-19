library(digest)
library(sodium)
library(jsonlite)

add_hashcheck <- function(path, output){
  
  if(missing(output)){
    output <- paste0(tools::file_path_sans_ext(path),"_hash.html")
  }
  
  js <- c(
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/core.js\"></script>",
    "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/md5.js\"></script>",
    "<script src=\"js/check_hash.js\"></script>",
    "<style>\n.iframe-container {\noverflow: hidden;\nheight: 100%;\nwidth: 100%;\nposition: relative;\n}\n\n.iframe-container iframe {\nborder: 0;\nheight: 100%;\nleft: 0;\nposition: absolute;\ntop: 0;\n width: 100%;\n}\n</style>"
  )
  
  
  html_file <- read_html(path)
  
  html_file
  
  html_doc <- trimws(readLines(path,warn = FALSE))
  
  doc_base64 <- paste0("data:text/html;base64," , base64_enc(paste(html_doc, collapse="")))

  doc_digest = digest::digest(
    gsub("\\n","%0A",doc_base64), ## escape nulls (\n)
    serialize = FALSE, algo = "md5")
  
  meta <- c(
    paste0("<meta name=\"content-hash\" content=\"",doc_digest,"\"/>"),
    paste0("<meta name=\"content-pubkey\" content=\"",doc_digest,"\"/>")
  )
  
  doc <- c("<html>","<head>", meta ,js,"</head>","<body style='margin:0px'>",
           paste0("<div class='iframe-container'><iframe class = 'doc-content' src=\"",doc_base64, "\"></iframe></div>"),
           "</body>","</html>")
  
  cat(
    doc,
    sep = "\n",
    file = output
  )
  
}
  


