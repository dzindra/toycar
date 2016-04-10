wall = 1.2;
wallz = 1;

motorW = 12.5;
motorH = 10.5;

length = 50;

$fn = 50;

baseDia = 30;

difference() {
    union() {
        difference() {
            cube([length,motorW+wall*2,wallz*2+motorH]);
            translate([-1,wall,wallz]) cube([length+2, motorW, motorH]);
        }

        translate([length/2,(motorW+wall*2)/2,0]) difference() {
            cylinder(d=baseDia,h=wallz,$fn=$fn);
            translate([0,-11,-1]) cylinder(d=4,h=wallz+3,$fn=$fn);
            translate([0,11,-1]) cylinder(d=4,h=wallz+3,$fn=$fn);
        }
    }
    
    translate([length/2,(motorW+wall*2)/2,-1]) cylinder(d=10,h=wallz+2,$fn=$fn);
}