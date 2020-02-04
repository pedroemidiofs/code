window.addEventListener('load',()=>{
            window.history.replaceState('teste','Titulo de teste','/view/monitoria/front.php');
            if(this.login == ''){
                window.location.href = 'http://10.100.0.xxx/view/monitoria';
            }
        });
