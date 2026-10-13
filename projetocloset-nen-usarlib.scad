use <libcloset.scad>;

//uma das paredes do closet modular
_vetorcaixa1 = [250,90,68]; //altura,largura,profundidade
_vetorcaixa2 = [250,40,68];
distxu1=25;
pcompu1=80;
pprofu1=40;
gcompu1=40;
gprofu1=80;
permiteMeiou1=false;
comLEu1=false;

module parede1() {
    
    translate([0,-2-_vetorcaixa1.y,0]) 
    unidadeGavetasPlacas(dx=distxu1,pcomp=pcompu1,pprof=pprofu1,
    gcomp=gcompu1,gprof=gprofu1, vetorcaixa=_vetorcaixa1, permiteMeio=permiteMeiou1, comLE=comLEu1);
    
    unidadeGavetasPlacas(dx=25,pcomp=90,pprof=60,gcomp=60,gprof=90, vetorcaixa=_vetorcaixa1, permiteMaleiro=true, pMaleiro=50, permiteMeio=true,inf=true,dist=10, n=7, la=8, v=[0,0,0,1,1,1,1], moverMeio = -20);
    
    translate([0,2+_vetorcaixa1.y,0]) unidadeGavetasPlacas(
    dx=25,pcomp=90,pprof=40,gcomp=40,gprof=90, 
    vetorcaixa=_vetorcaixa1,
    permiteMaleiro=true, 
    pMaleiro=50, permiteMeio=true); 
    
    
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