difference() {
cube(20, center = true);
translate([10,0,0]) sphere(10);
translate([-10,0,0]) sphere(10);
translate([0,10,0]) sphere(10);
translate([0,-10,0]) sphere(10);
translate([0,0,-10]) sphere(10);
translate([0,0,10]) sphere(10);
}