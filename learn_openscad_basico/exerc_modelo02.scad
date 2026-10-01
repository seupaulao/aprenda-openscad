$fa=1;
$fs=0.4;
raio_roda=8;
distancia_eixo=30;
distancia_roda=distancia_eixo/2;
scale([1.25,1,1]) rotate([5,0,0]){
   cube([60,20,10], center=true);
   translate([0,0,10-0.001])
   cube([30,20,10], center=true);
}
translate([-20,-distancia_roda,0])
rotate([90,0,-20])
cylinder(h=3, r=raio_roda, center=true);
translate([-20,distancia_roda,0])
rotate([90,0,-20])
cylinder(h=3, r=raio_roda, center=true);
translate([20,distancia_roda,0])
rotate([90,0,0])
cylinder(h=3, r=raio_roda, center=true);
translate([20,-distancia_roda,0])
rotate([90,0,0])
cylinder(h=3, r=raio_roda, center=true);
rotate([90,0,0])
translate([-20,0,0])
cylinder(h=distancia_eixo,r=2, center=true);
rotate([90,0,0])
translate([20,0,0])
cylinder(h=distancia_eixo,r=2, center=true);