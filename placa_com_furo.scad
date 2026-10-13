placa = [100,50,3];
furo = 3;
margem = 8;

module magica() {
difference() {
    
    cube(placa);

    abs_margem = margem + furo  / 2;
    xvalues = [abs_margem, placa.x - abs_margem];
    yvalues = [abs_margem, placa.y - abs_margem];

    
    for( x = xvalues, y = yvalues) {
        color("red")
        translate([ x, y, -1 ]) 
        cylinder(placa.z + 3, furo, furo);
    }
}
}

magica();


 