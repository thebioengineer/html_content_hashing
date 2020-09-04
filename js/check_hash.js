var hash = "";
var key = "";
var actual_hash;

// exectute once the document dom is ready

window.onload = function() {
  var head = "";
  var body = "";
    
    // exectute before any other scripts are run. get meta and scripts info
  document.head.childNodes.forEach(function(header_element){
        
        if(header_element.nodeName === "SCRIPT"){
          head = head + header_element.outerHTML;
        }
        
        if(header_element.nodeName === "META"){
          if(header_element.name === "content-hash"){
            hash = header_element.content;
          }
        }
        
  });
    
  var i;
  var body_el_list = document.body.children;
  for( i = 0 ; i < body_el_list.length; i++){
    body = body + body_el_list[i].outerHTML.trim();
  }
  
  var doc_contents = "<head>" + head + "</head><body>" + body + "</body>";
  
  actual_hash = CryptoJS.MD5(doc_contents).toString();
    
};


// determine if the hash matches
$( document ).ready( function(){
  
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