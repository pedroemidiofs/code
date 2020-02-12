class SessionExpired{
    constructor(){
        this.timeOut();
        this.restartTimeout();
    };
    timeOut(){
        this.timer = setTimeout(()=>{this.redirect()},600000);
    }
    redirect(){
        window.location.href = 'http://10.100.0.192/login';
    }
    restartTimeout(){
        window.addEventListener('mousemove',()=>{
            clearInterval(this.timer);
            this.timeOut();
        });
    }
}
