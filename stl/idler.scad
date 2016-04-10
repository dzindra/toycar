wall = 1.2;
height = 10;
innerDia = 10.8;
outerDia = 16;
wallZ = 1;
$fn=50;

difference() {
    cylinder(d=outerDia,h=wall,$fn=$fn);
    translate([0,0,-1]) cylinder(d=4,h=wall+2,$fn=$fn);
}

translate([0,0,wallZ]) difference() {
    cylinder(d=innerDia+wall*2,h=height,$fn=$fn);
    translate([0,0,-1]) cylinder(d=innerDia,h=height+2,$fn=$fn);
}
