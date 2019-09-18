class Ajax{
  constructor(){
  }
  ajax(element, source){
    var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.querySelector(element).innerHTML = this.responseText;
        }
      };
    xhttp.open("GET", source, true);
    xhttp.send();
  }
}
