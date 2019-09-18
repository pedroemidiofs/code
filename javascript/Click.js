class Click{
    constructor(){
        this.botao = document.querySelector("#botao");
        this.clicar();
    }
    clicar(){
        botao.addEventListener('click',()=>{
            banco.ajax('#clica', 'botao.php');
        });
    };
}
