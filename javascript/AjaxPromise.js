class Ajax{
  constructor(){
  }
  promiseSelect(source){
    let promObj = new Promise(function(resolve, reject) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", source, true);
        xhttp.send();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4){
                if(this.status == 200){
                    resolve(this.responseText);
                }
                else{
                    reject(this.status);
                }
            }
        };
    });
    return promObj;
  }
  promiseSelectPost(source){
    let promObj = new Promise(function(resolve, reject) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", source, true);
        xhttp.send();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4){
                if(this.status == 200){
                    resolve(this.responseText);
                }
                else{
                    reject(this.status);
                }
            }
        };
    });
    return promObj;
  }
}
