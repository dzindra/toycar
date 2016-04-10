wallZ = 1.2;
wall = 1.2;
width=52;
height=90;
corner=5;
$fn=50;

bottomHoleOffset=60;
bottomHoleOffset2=15;

frontBump=[37,40,35];


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

module pcbHolder(outerWidth=49.6, innerWidth=37, wall=1.2, pcbThickness=2.5, height=20) {
    w=(outerWidth-innerWidth)/2;
    cube([w,wall,height]);
    translate([0,wall+pcbThickness,0]) cube([w,wall,height]);
    translate([w+innerWidth,0,0]) cube([w,wall,height]);
    translate([w+innerWidth,wall+pcbThickness,0]) cube([w,wall,height]);
    
    translate([0,wall,0]) cube([w-2.5,pcbThickness,5]);
    translate([w+innerWidth+2.5,wall,0]) cube([w-2.5,pcbThickness,5]);
}

module ledHolder(size=[7.5,30,7.5],ledDia=5.8,ledBarrel=6,ledRim=7,right=1,hollow=1,wall=1.2) {
    d = (ledRim-ledDia)/2;
    difference() {
        cube([size[0]+wall,size[1],size[2]]);
        
        if (hollow) {
        if (right) {
            translate([-ledDia/2+size[0]-d,-1,ledDia/2+d]) rotate([-90,0,0]) cylinder(d=ledDia,h=ledBarrel+2,$fn=$fn);
            translate([-ledRim/2+size[0],ledBarrel,ledRim/2]) rotate([-90,0,0]) cylinder(d=ledRim,h=size[1]-ledBarrel+1,$fn=$fn);
        } else {
            translate([ledDia/2+d+wall,-1,ledDia/2+d]) rotate([-90,0,0]) cylinder(d=ledDia,h=ledBarrel+2,$fn=$fn);
            translate([ledRim/2+wall,ledBarrel,ledRim/2]) rotate([-90,0,0]) cylinder(d=ledRim,h=size[1]-ledBarrel+1,$fn=$fn);
        }
        }
    }

}

difference() {
    roundRect([width,height,wallZ]);

    translate([width/2, bottomHoleOffset, -1]) union() {
        cylinder(d=10,h=wallZ+2,$fn=$fn);
        translate([0,-11,0]) cylinder(d=4,h=wallZ+2,$fn=$fn);
        translate([0,11,0]) cylinder(d=4,h=wallZ+2,$fn=$fn);
    }
    translate([width/2, bottomHoleOffset2, -1]) cylinder(d=4,h=wallZ+2,$fn=$fn);
}


translate([width/2,height]) difference() {
    cylinder(d=12,h=wallZ,$fn=$fn);
    translate([0,3,-1]) cylinder(d=4,h=wallZ+2,$fn=$fn);
}

translate([0,0,wallZ]) {
    
     difference() {
        translate([(width-frontBump[0])/2,0,0]) roundRectHollow([frontBump[0],height,frontBump[2]], wall=wall);
        translate([0,frontBump[1],-1]) roundRect([width,height-frontBump[1],frontBump[2]+2]);
    }
    difference() {
        translate([0,frontBump[1],0])  roundRectHollow([width,height-frontBump[1],frontBump[2]],wall=wall);
        translate([(width-frontBump[0]+wall*2)/2,frontBump[1]-1,-1])
            cube([frontBump[0]-wall*2,wall+2,frontBump[2]+2]);
        
        translate([0,15,0]) ledHolder(hollow=0);
        translate([frontBump[0]+7.5-wall,15,0]) ledHolder(hollow=0,right=0);
    }
    translate([10,bottomHoleOffset+4,0]) cube([5,wall*2,10]);
    translate([width-15,bottomHoleOffset+4,0]) cube([5,wall*2,10]);
    
    translate([0,15,0]) ledHolder();
    translate([frontBump[0]+7.5-wall,15,0]) ledHolder(right=0);    
   
    translate([wall,height-8-2.5-wall*2,0]) pcbHolder(wall=wall);
}

