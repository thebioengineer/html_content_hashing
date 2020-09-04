var hash = "";
var key = "";
var doc_contents;



var head = "";

// exectute before any other scripts are run. get meta and scripts info
document.head.childNodes.forEach(function(header_element){
      
      if(header_element.nodeName === "SCRIPT" |
      header_element.nodeName === "STYLE"){
        head = head + header_element.outerHTML;
      }
      
      if(header_element.nodeName === "META"){
        if(header_element.name === "content-hash"){
          hash = header_element.content;
        }
      }
      
});

// exectute once the document dom is ready

window.onload = function() {
    var body = "";
    
    var i;
    var body_el_list = document.body.children;
    for( i = 0 ; i < body_el_list.length; i++){
      body = body + body_el_list[i].outerHTML.trim();
    }
    
    doc_contents = "<head>" + head + "</head><body>" + body + "</body>";
    
};


// determine if the hash matches
$( document ).ready( function(){
  
  actual_hash = CryptoJS.MD5(doc_contents).toString();
  
  if(hash  === ""){
    $.notify("No md5 Hash Documented.",
             {autoHide: false, className: "warning"});
  }else if(hash === actual_hash){
    $.notify("Content md5 Hash as expected. Contents are unchanged.", "success");
  }else{
    $.notify(
      "Content md5 Hash does not match. Contents may have been changed.",
      {autoHide: false, className: "error"});
  }
  
});