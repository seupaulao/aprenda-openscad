//colocar a entrada do projeto um vetor []

//placa generica
module placa(altura=200, larg=50, espessura=2) {
    cube([altura, larg, espessura], center = true); 
}

//placa fundo
module placaFundo(altura, la)
{
  rotate([0,90,0]) placa(altura=altura, larg=la);  
}
//placa lateral
module placaLateral(altura, la)
{
  rotate([90,90,0]) placa(altura=altura, larg=la);  
}
//placa base ou placa topo
module placaTopo(altura, la){
  rotate([0,0,90]) placa(altura=altura, larg=la);
}

// cria o portal de uma caixa para gaveta simples, modulo ou guarda roupa
// portal eh composto por:
//   - 2 laterais(esq e direita), 
//   - 2 topos (inferior e superior)
module portal(cl, cb, la, comLE=true, comDE=true) {
    dist = 0;    
    //direita
    if (comDE) {    
        translate([dist, cb/2, 0 ]) placaLateral(altura=cl,la=la);
    }
    //esquerda
    if (comLE) {    
        translate([dist, -cb/2, 0 ]) placaLateral(altura=cl,la=la);
    }    
    //superior
    translate([dist, 0,cl/la*(la-1)/2 + 1]) placaTopo(altura=cb, la=la);
    //inferior    
    translate([dist, 0,cl/la*(1-la)/2 - 1]) placaTopo(altura=cb, la=la); 
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
        color("brown") placaFundo(altura=fba, la=fla);
    }    
//portal
    dist = la / 2;
    translate([dist,0,0]) portal(cb=cb, cl=cl, la=la, comLE=comLE, comDE=comDE)  ;  
}    

//caixa dividida no meio
//vetorcaixa [altura, base, profundidade]
//placaMeio = booleano = colocar a placa do meio ou remover
//comLE = booleano = colocar lateral esquerda ou remover
//comDE = booleano = colocar lateral direita do meio ou remover
//comFundo = booleano = colocar o fundo ou remover
module unidadeBasica(
   vetorcaixa, 
   permiteMeio=true,
   comLE=true, comDE=true, comFundo=true, 
   permiteMaleiro=false, pMaleiro) {
    caixa(fba=vetorcaixa.x, fla=vetorcaixa.y, cl=vetorcaixa.x, cb=vetorcaixa.y, la=vetorcaixa.z,comLE=comLE,comDE=comDE,comFundo=comFundo);
    if (permiteMaleiro) {
         transporte = permiteMaleiro ? vetorcaixa.x/2-pMaleiro : 0;
         translate([vetorcaixa.z/2, 0, transporte ]) 
         placaTopo(altura=vetorcaixa.y, la=vetorcaixa.z);        
    }
    if (permiteMeio) {
         transporte = permiteMaleiro ? vetorcaixa.x / 2 - pMaleiro * 3 : 0;
         translate([vetorcaixa.z/2, 0, transporte ]) 
         placaTopo(altura=vetorcaixa.y, la=vetorcaixa.z);        
    }
    
}


//frente = altura, comprimento, espessura
//fundo e laterais = altura, comprimento, altura, altura_freso
//base = larg, comp, espessura 
module gavetaPadrao() { }

//gaveta simples tamanho padrão - baseado na caixa
// gcomp = comprimento da gaveta
// gprof = lagura da gaveta
// comFundo = coloca do fundo(tampo) da gaveta
// la = largura do portal (profundidade)
module gavetaS(gcomp,gprof,comFundo=true,la=8){
  rotate([0,270,0])
  caixa(fba=gcomp, fla=gprof, cl=gcomp, 
        cb=gprof, la=la,
        comLE=true,comDE=true,comFundo=comFundo);  
}

module _placasSuperior(dx,dz,gcomp, gprof, dist = 20, n = 4){
        for(i=[1:1:n]) {
            translate([dx, 0, dz + i * dist]) 
            placaTopo(gcomp, gprof); } 
}
module _placasInferior(dx,dz,gcomp, gprof, dist = 20, n = 3){
        for(i=[1:1:n]) {
           translate([dx, 0, dz - i * dist]) 
           placaTopo(gcomp, gprof);            
        }
}

module _gavetasSuperior(dx,dz,comFundoUltimaGaveta,gcomp,gprof, dist = 20, n = 3) {
        for (i=[0:1:n-1]) {
            translate([dx, 0, dz+i*dist]) gavetaS(gcomp,gprof);
        }
}

module _gavetasInferior(dx,dz,comFundoUltimaGaveta,gcomp,gprof,dist=20, n = 3) {
        for (i=[1:1:n]) {
            translate([dx, 0, dz-i*dist]) gavetaS(gcomp,gprof,comFundo=(i>=n));
        }
}

module _colocarPlacaGaveta(dx,dz,pcomp,pprof,gcomp,gprof,orientacao,dist,n,v,la) {
    for ( i = [1:1:n] ) {
           f = (orientacao == "S") ? dz - i * dist : dz + i * dist;
       if (v[i-1] == 0) {
           //placa
           translate([dx+5, 0, f]) 
           placaTopo(pcomp, pprof); 
       } else {
           //gaveta
           translate([dx+5, 0, f]) 
           gavetaS(gcomp,gprof,la=la);
       }
       
    }        
    
}

module unidadeGavetasPlacas(
   permiteMeio=true,
   sup=false, inf=false, 
   comFundoUltimaGaveta=false,dx=25,
   pcomp,pprof,gcomp,gprof,vetorcaixa, comLE=true, comDE=true, comFundo=true,permiteMaleiro,pMaleiro,dist,n,la,v
) {
        unidadeBasica(vetorcaixa, permiteMeio, comLE=comLE, comDE=comDE, comFundo=comFundo,permiteMaleiro=permiteMaleiro,pMaleiro=pMaleiro);
    
        dz =  !permiteMaleiro ? 0 : -1 * (vetorcaixa.x - pMaleiro) / 2 / 4;
    
    if (sup) {
    _colocarPlacaGaveta(dx,dz,pcomp,pprof,gcomp,gprof,orientacao="N",dist=dist,n=n,la=la,v=v);        
    }
    if (inf) {
    _colocarPlacaGaveta(dx,dz,pcomp,pprof,gcomp,gprof,orientacao="S",dist=dist,n=n,la=la,v=v);        
    }
    
   //     if (supP) {
   //         _placasSuperior(dx,dz,pcomp, pprof, 
   //         dist=distp, n=np );
   //     }     
   //     if (infP) {
   //         _placasInferior(dx,dz,pcomp, pprof, 
   //         dist=distp, n=np );
   //     }
   //     if (supG) {
   //         _gavetasSuperior(dx,dz,gcomp,gprof, 
   //         dist=distg, n=ng );
   //     }    
   //     if (infG) {
   //         _gavetasInferior(dx,dz,comFundoUltimaGaveta,
   //         gcomp,gprof, dist=distg, n=ng );
   //     }    
        
}

module parede1() {
    _vetorcaixa1 = [250,90,68]; //altura,largura,profundidade
    
    translate([0,-2-_vetorcaixa1.y,0]) 
    unidadeGavetasPlacas(dx=25,pcomp=80,pprof=40,gcomp=40,gprof=80, vetorcaixa=_vetorcaixa1, permiteMeio=false, comLE=false);
    
    unidadeGavetasPlacas(dx=25,pcomp=90,pprof=60,gcomp=60,gprof=90, vetorcaixa=_vetorcaixa1, permiteMaleiro=true, pMaleiro=50, permiteMeio=true,inf=true,dist=10, n=10, la=8, v=[0,0,0,1,1,1,1,1,1,1]);
    
    translate([0,2+_vetorcaixa1.y,0]) unidadeGavetasPlacas(
    dx=25,pcomp=90,pprof=40,gcomp=40,gprof=90, 
    vetorcaixa=_vetorcaixa1,
    permiteMaleiro=true, 
    pMaleiro=50, permiteMeio=true); 
    
    _vetorcaixa2 = [250,40,68];
    
    translate([0,2+_vetorcaixa1.y*2-24,0]) 
    unidadeGavetasPlacas(dx=25,pcomp=40,pprof=40,
    gcomp=40,gprof=40,vetorcaixa=_vetorcaixa2, 
    permiteMaleiro=true, pMaleiro=50, permiteMeio=true);  

    translate([0,2+_vetorcaixa1.y*3-72,0]) 
    unidadeGavetasPlacas(dx=25,pcomp=40,pprof=40,
    gcomp=40,gprof=40,vetorcaixa=_vetorcaixa2, 
    permiteMaleiro=true, pMaleiro=50, permiteMeio=true);  
    
}

parede1();


//permiteMaleiro = 50cm do teto
//permiteMeio nas 3 ultimas
//distancia entre tabuas e gavetas : deve ser parametrizado
//numero de tabuas e gavetas       : deve ser parametrizado
