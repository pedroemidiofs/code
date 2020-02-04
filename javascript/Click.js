class Click{
    constructor(){
        this.botao = document.querySelector("#botao");
        this.clicar();
    }
    clicar(){
        botao.addEventListener('click',()=>{
            console.log('clicou!');
        });
    };
}
