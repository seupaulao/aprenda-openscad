
//$fa=1;
//$fs=0.4;

module carroceria(base_height=5, top_height=10, base_width=60, top_width=30, is_move_top=true) {
      
       move_top = is_move_top ? 5:0;
       
       cube([base_width,20,base_height], center=true);
       translate([move_top,0,base_height/2 + top_height/2-0.001])
       cube([top_width,20,top_height], center=true);   
}

module carroceriaesferica(base_height, top_height){
     resize([80,25,10])
     sphere(20);
     translate([0,0,5])
     resize([40,15,20])
     sphere(20);
}

module rodasimples(posicao_roda=20,distancia_roda,largura_roda=7, raio_roda=10) {
    translate([posicao_roda,distancia_roda,0])
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);    
}

module rodasimples1(largura_roda=7, raio_roda=10) {
    rotate([90,0,0])
    cylinder(h=largura_roda, r=raio_roda, center=true);    
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

module eixo(posicao_eixo=20, distancia_eixo=35, raio_eixo=2) {
    rotate([90,0,0])
    translate([posicao_eixo,0,0])
    cylinder(h=distancia_eixo,r=raio_eixo, center=true);    
}
module eixosimples(distancia_eixo=35, raio_eixo=2) {
    rotate([90,0,0])
    cylinder(h=distancia_eixo,r=raio_eixo, center=true);    
}

module eixo_complexo(distancia=35, raio=2) {
    
    translate([0,distancia/2,0])
    children(0);
    eixosimples(distancia_eixo=distancia, raio_eixo=raio);
    translate([0,-distancia/2,0])
    children(0);
}

module rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo, posicao_eixo=20, posicao_roda=20) {
    rodasimples(-posicao_roda, -distancia_roda, largura_roda, raio_roda);
    rodasimples(-posicao_roda, distancia_roda, largura_roda, raio_roda);
    rodasimples(posicao_roda, -distancia_roda, largura_roda, raio_roda);
    rodasimples(posicao_roda, distancia_roda, largura_roda, raio_roda);
    eixo(-posicao_eixo, distancia_eixo);
    eixo(posicao_eixo, distancia_eixo);
}
module carro(raio_roda=10, distancia_eixo=35, largura_roda=7, base_height=5, top_height=10, posicao_eixo=20,base_width=60, top_width=30, is_move_top=true) {
    distancia_roda=distancia_eixo/2;
    carroceria(base_height, top_height,base_width,top_width, is_move_top);
    rodas_e_eixo(distancia_roda, largura_roda, raio_roda, distancia_eixo, posicao_eixo);
}

//carro_basico();
