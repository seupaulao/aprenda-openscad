
$fa=1;
$fs=0.4;

module carroceria(base_height, top_height) {
       cube([60,20,base_height], center=true);
       translate([5,0,base_height/2 + top_height/2-0.001])
       cube([30,20,top_height], center=true);   
}

module rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo) {
    translate([-20,-distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);
    translate([-20,distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);
    translate([20,distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);
    translate([20,-distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);
    rotate([90,0,0])
    translate([-20,0,0])
    cylinder(h=distancia_eixo,r=2, center=true);
    rotate([90,0,0])
    translate([20,0,0])
    cylinder(h=distancia_eixo,r=2, center=true);    
}
module carro_basico() {
    raio_roda=8;
    distancia_eixo=35;
    distancia_roda=distancia_eixo/2;
    largura_roda=7;
    base_height=5;
    top_height=10;
    
    carroceria(base_height, top_height);
    rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo);
}

carro_basico();