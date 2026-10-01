$fa=1.0;
$fs=0.6;
difference() {
cube(20, center = true);
translate([15,0,0]) sphere(10);
translate([-15,0,0]) sphere(10);
translate([0,15,0]) sphere(10);
translate([0,-15,0]) sphere(10);
translate([0,0,-15]) sphere(10);
translate([0,0,15]) sphere(10);
}