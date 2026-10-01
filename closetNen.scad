//placa generica
module placa(comp=200, larg=50, espessura=2) {
    cube([comp, larg, espessura], center = true); 
}

//placa fundo
module placaFundo(co, la)
{
  rotate([0,90,0]) placa(comp=co, larg=la);  
}
//placa lateral
module placaLateral(co, la)
{
  rotate([90,90,0]) placa(comp=co, larg=la);  
}
//placa base ou placa topo
module placaTopo(co, la){
  rotate([0,0,90]) placa(comp=co, larg=la);
}

// cria o portal de uma caixa para gaveta simples, modulo ou guarda roupa
// portal eh composto por:
//   - 2 laterais(esq e direita), 
//   - 2 topos (inferior e superior)
module portal(cl, cb, la, comLE=true, comDE=true) {
    dist = 0;    
    //direita
    if (comDE) {    
        translate([dist, cb/2, 0 ]) placaLateral(co=cl,la=la);
    }
    //esquerda
    if (comLE) {    
        translate([dist, -cb/2, 0 ]) placaLateral(co=cl,la=la);
    }    
    //superior
    translate([dist, 0,cl/la*(la-1)/2 + 1]) placaTopo(co=cb, la=la);
    //inferior    
    translate([dist, 0,cl/la*(1-la)/2 - 1]) placaTopo(co=cb, la=la); 
}

// caixa 
// fba e fla = base e largura do fundo, 
// cl = comprimento lateral
// cb = comprimento base
// la = largura do portal (profundidade)
// comLE = com lateral esquerda (valor default = true)
module caixa(fba=200, fla=100, cl=200, cb=200, la=100, comLE=true, comDE=true, comFundo=true) {
//fundo
    if (comFundo) { 
        color("brown") placaFundo(co=fba, la=fla);
    }    
//portal
    dist = la / 2;
    translate([dist,0,0]) portal(cb=cb, cl=cl, la=la, comLE=comLE, comDE=comDE)  ;  
}    

//caixa dividida no meio
//TODO parametrizar melhor esse metodo
module unidadeBasica() {
    caixa(fba=200, fla=100, cl=200, cb=100, la=50);
    translate([25, 0, 0 ]) placaTopo(co=100, la=50);
}


// TODO refazer gaveta simples = ela não é caixa,
// 2 laterais, costas e frente, a parte de baixo - fundo - 
// esta ha alguns mm longe do final da caixa
// modelar o freso da caixa : laterais e costas
//gaveta simples tamanho padrão
//TODO parametrizar melhor esse metodo
module gavetaS(comFundo=true){
  rotate([0,270,0])
  caixa(fba=40, fla=100, cl=40, cb=100, la=18,comLE=true,comDE=true,comFundo=comFundo);  
}

//TODO parametrizar melhor esse metodo
module unidadePlacas(gcomp, gprof, sup=true, inf=true){
    unidadeBasica();
    if (sup) {
        translate([25,0, 20]) placaTopo(gcomp, gprof);
        translate([25,0, 40]) placaTopo(gcomp, gprof);
        translate([25,0, 60]) placaTopo(gcomp, gprof);
        translate([25,0, 80]) placaTopo(gcomp, gprof);
        //translate([25,0, 100]) placaTopo(gcomp, gprof);
    }    
    if (inf) {
        translate([25,0,-20]) placaTopo(gcomp, gprof);
        translate([25,0,-40]) placaTopo(gcomp, gprof);
        translate([25,0,-60]) placaTopo(gcomp, gprof);
        translate([25,0,-80]) placaTopo(gcomp, gprof);
       // translate([25,0,-100]) placaTopo(gcomp, gprof);
    }    
} 

//TODO parametrizar melhor esse metodo
//guarda roupa 5 gavetas
module unidadeGavetas(comFundoUltimaGaveta=false, inf=true, sup=true) {
    unidadeBasica();
    
    if (sup) {
        translate([25,0, 0]) gavetaS();
        translate([25,0, 20]) gavetaS();
        translate([25,0, 40]) gavetaS();
        translate([25,0, 60]) gavetaS();
        translate([25,0, 80]) gavetaS();
    }    
    if (inf) {
        translate([25,0,-20]) gavetaS();
        translate([25,0,-40]) gavetaS();
        translate([25,0,-60]) gavetaS();
        translate([25,0,-80]) gavetaS();
        translate([25,0,-100]) gavetaS(comFundo=comFundoUltimaGaveta);
    }    
}

module parede1() {
    translate([0,-101,0]) 
    caixa(fba=200, fla=100, cl=200, cb=100, la=50, comLE=false);
    unidadeBasica();
    translate([0,101,0]) unidadePlacas(gcomp=100,gprof=40,inf=true, sup=false);
    translate([0,201,0]) unidadeGavetas();    
}

parede1();

