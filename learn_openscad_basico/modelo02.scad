
//$fa=1;
//$fs=0.4;

module carroceria(base_height, top_height) {
       cube([60,20,base_height], center=true);
       translate([5,0,base_height/2 + top_height/2-0.001])
       cube([30,20,top_height], center=true);   
}

module carroceriaesferica(base_height, top_height){
     resize([80,25,10])
     sphere(20);
     translate([0,0,5])
     resize([40,15,20])
     sphere(20);
}

module rodaesferica(posicao_roda, distancia_roda, largura_roda, raio_roda) {
    translate([posicao_roda,distancia_roda,0])
    difference() {
    sphere(raio_roda);
        translate([0,raio_roda,0])
    sphere(raio_roda);
        translate([0,-raio_roda,0])
    sphere(raio_roda);
    rotate([90,0,0])
    translate([0,5,0])
    cylinder(40,2,2, center=true);
    rotate([90,0,0])
    translate([0,-5,0])
    cylinder(40,2,2, center=true);
    rotate([90,0,0])
    translate([-5,0,0])
    cylinder(40,2,2, center=true);
    rotate([90,0,0])
    translate([5,0,0])
    cylinder(40,2,2, center=true);
    }
}

module rodasimples(posicao_roda, distancia_roda, largura_roda, raio_roda) {
    translate([posicao_roda,distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);    
}

module eixo(posicao_eixo, distancia_eixo) {
    rotate([90,0,0])
    translate([posicao_eixo,0,0])
    cylinder(h=distancia_eixo,r=2, center=true);    
}

module rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo) {
    rodaesferica(-20, -distancia_roda, largura_roda, raio_roda);
    rodaesferica(-20, distancia_roda, largura_roda, raio_roda);
    rodaesferica(20, -distancia_roda, largura_roda, raio_roda);
    rodaesferica(20, distancia_roda, largura_roda, raio_roda);
    eixo(-20, distancia_eixo);
    eixo(20, distancia_eixo);
}
module carro_basico() {
    raio_roda=10;
    distancia_eixo=35;
    distancia_roda=distancia_eixo/2;
    largura_roda=7;
    base_height=5;
    top_height=10;
    
    carroceriaesferica(base_height, top_height);
    rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo);
}

carro_basico();
