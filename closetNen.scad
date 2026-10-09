//colocar a entrada do projeto um vetor []

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


//frente = altura, comprimento, espessura
//fundo e laterais = altura, comprimento, altura, altura_freso
//base = larg, comp, espessura 
module gavetaPadrao() { }

//gaveta simples tamanho padrão - baseado na caixa
// fba = comprimento do fundo (base) 
// fla = largura do fundo (base)
// cl = comprimento lateral
// cb = comprimento base
// la = largura do portal (profundidade)
module gavetaS(fba=40, fla=100, cl=40, cb=100, la=18, comFundo=true){
  rotate([0,270,0])
  caixa(fba=fba, fla=fla, cl=cl, 
        cb=cb, la=la,
        comLE=true,comDE=true,comFundo=comFundo);  
}

module _placasSuperior(gcomp, gprof,dx,dz){
        translate([dx, 0, dz+20]) placaTopo(gcomp, gprof);
        translate([dx, 0, dz+40]) placaTopo(gcomp, gprof);
        translate([dx, 0, dz+60]) placaTopo(gcomp, gprof);
        translate([dx, 0, dz+80]) placaTopo(gcomp, gprof);
}
module _placasInferior(gcomp, gprof,dx,dz){
        translate([dx, 0,dz-20]) placaTopo(gcomp, gprof);
        translate([dx, 0,dz-40]) placaTopo(gcomp, gprof);
        translate([dx, 0,dz-60]) placaTopo(gcomp, gprof);
        translate([dx, 0,dz-80]) placaTopo(gcomp, gprof);
}

module _gavetasSuperior(dx,dz,comFundoUltimaGaveta) {
        translate([dx, 0, dz]) gavetaS();
        translate([dx, 0, dz+20]) gavetaS();
        translate([dx, 0, dz+40]) gavetaS();
        translate([dx, 0, dz+60]) gavetaS();
        translate([dx, 0, dz+80]) gavetaS();
}

module _gavetasInferior(dx,dz,comFundoUltimaGaveta) {
        translate([dx, 0, dz-20]) gavetaS();
        translate([dx, 0, dz-40]) gavetaS();
        translate([dx, 0, dz-60]) gavetaS();
        translate([dx, 0, dz-80]) gavetaS();
        translate([dx, 0, dz-100]) gavetaS(comFundo=comFundoUltimaGaveta);    
}


module unidadePlacas(gcomp, gprof, sup=true, inf=true, dx=25, dz=0){
    unidadeBasica();
    if (sup) {
        _placasSuperior(gcomp, gprof,dx,dz);
    }    
    if (inf) {
        _placasInferior(gcomp, gprof,dx,dz);
    }    
} 

//guarda roupa 5 gavetas
module unidadeGavetas(comFundoUltimaGaveta=false, inf=true, sup=true,
    dx=25) {
    unidadeBasica();
    dz = 0;
    if (sup) {
        _gavetasSuperior(dx,dz);
    }    
    if (inf) {
        _gavetasInferior(dx,dz,comFundoUltimaGaveta);
    }    
}

module unidadeGavetasPlacas(
   supP=false, infP=false, 
   supG=false, infG=false, comFundoUltimaGaveta=false
) {
        unidadeBasica();
        dz = 0;
        if (supP) {
            _placasSuperior(gcomp, gprof,dx,dz);
        }     
        if (infP) {
            _placasInferior(gcomp, gprof,dx,dz);
        }
        if (supG) {
            _gavetasSuperior(dx,dz);
        }    
        if (infG) {
            _gavetasInferior(dx,dz,comFundoUltimaGaveta);
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
