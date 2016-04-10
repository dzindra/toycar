wall = 1.5;
width=52;
height=90;
corner=5;
$fn=50;

frontBump=[37,40,3];


module roundRect(size,corner=5) {
    translate([corner,corner,0]) hull() {
        cube([size[0]-corner*2,size[1]-corner*2,size[2]]);
        cylinder(h=size[2],r=corner,$fn=$fn);
        translate([size[0]-corner*2,0,0]) cylinder(h=size[2],r=corner,$fn=$fn);
        translate([size[0]-corner*2,size[1]-corner*2,0]) cylinder(h=size[2],r=corner,$fn=$fn);
        translate([0,size[1]-corner*2,0]) cylinder(h=size[2],r=corner,$fn=$fn);
    }
}

module roundRectHollow(size,corner=5,wall=1) {
    difference() {
        roundRect(size);
        translate([wall,wall,-1]) roundRect([size[0]-wall*2,size[1]-wall*2,size[2]+2]);
    }
}

difference() {union(){
translate([(width-frontBump[0])/2,0,0]) roundRect([frontBump[0],height,1], wall=wall);
translate([0,frontBump[1],0])  roundRect([width,height-frontBump[1],1],wall=wall);



translate([0,0,1]) {

difference() {
        translate([(width-frontBump[0]+wall*2)/2,wall,0]) roundRectHollow([frontBump[0]-wall*2,height-wall*2,frontBump[2]], wall=wall);
        translate([0,frontBump[1]+wall,-1]) roundRect([width,height-frontBump[1],frontBump[2]+2]);
}

difference() {
        translate([wall,frontBump[1]+wall,0])  roundRectHollow([width-wall*2,height-frontBump[1]-wall*2,frontBump[2]],wall=wall);
        translate([(width-frontBump[0]+wall*4)/2,frontBump[1]+wall-1,-1])
            cube([frontBump[0]-wall*4,wall+2,frontBump[2]+2]);
        
}

}
}


translate([width-((width-frontBump[0]+wall*2)/2),frontBump[1]+wall+6.5,-1]) cube([6.8,13,40]);
}