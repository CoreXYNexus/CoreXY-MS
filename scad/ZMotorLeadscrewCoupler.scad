// nice (and horribly long) variable names for Thingiverse Customizer
// 12/17/18 (SRC) - edited to use in another scad file and added preview colors
// 					Z-Motor-Leadscrew-Coupler.scad
// 10/22/20 (SRC) - Added use of brass inserts

include <inc/brassinserts.scad>
Use3mmInsert=1;

// Height of the coupler, half for the motor shaft and half for the rod
couplerHeight = 30;
// External diameter of the coupler
couplerExternalDiameter = 20;
// Diameter of the motor shaft
//motorShaftDiameter = 5;
// Diameter of the rod
//threadedRodDiameter = 5;
// Diameter of the screw thread
screwDiameter = 3.4;
screwHeadDiameter = 7;
screwThreadLength = 10;
// Width across flats of the nut (wrench size)
nutWidth = 5.7;
nutThickness = 3;
// Gap between the two halves
halvesDistance = 0.5;

/* [Hidden] */
// end of Customizer variables
// Portion of the shaft inside the coupler
shaftLen = couplerHeight/2;
// Portion of the rod inside the coupler
rodLen = couplerHeight/2;
//shaftScrewsDistance = motorShaftDiameter+screwDiameter+1;
//rodScrewsDistance = threadedRodDiameter+screwDiameter+1;

$fa = 0.02;
$fs = 0.25;
little = 0.01; // just a little number
big = 100; // just a big number

module coupler(motorShaftDiameter = 5,threadedRodDiameter = 5)
{
	shaftScrewsDistance = motorShaftDiameter+screwDiameter+1;
	rodScrewsDistance = threadedRodDiameter+screwDiameter+1;
	difference() {
        // main body
        color("cyan") cylinder(d=couplerExternalDiameter, h=shaftLen + rodLen);
        // shaft
        translate([0,0,-little])
            color("red") cylinder(d=motorShaftDiameter, h=shaftLen+2*little);
        // rod
        translate([0,0,shaftLen])
            color("gray") cylinder(d=threadedRodDiameter, h=rodLen+little);
        // screws
        translate([0,shaftScrewsDistance/2,shaftLen/2])
            rotate([90,0,90])
                screw();
        translate([0,-shaftScrewsDistance/2,shaftLen/2])
            rotate([90,0,270])
                screw();
        translate([0,rodScrewsDistance/2,shaftLen+rodLen/2])
            rotate([90,0,90])
                screw();
        translate([0,-rodScrewsDistance/2,shaftLen+rodLen/2])
            rotate([90,0,270])
                screw();
        // cut between the two halves
        color("black") cube([halvesDistance,big,big], center=true);
    }
    
}

module screw()
{
    // thread
    color("plum") cylinder(d=screwDiameter, h=big, center=true);
    // head
    translate([0,0,(screwThreadLength-nutThickness)/2])
        color("gold") cylinder(d=screwHeadDiameter, h=big);
	if(Use3mmInsert) {
		translate([0,0,-(screwThreadLength-nutThickness)/2+3.5])
			rotate([180,0,30])
				color("gray") cylinder(d=Yes3mmInsert(Use3mmInsert), h=15);
    } else { // nut
    translate([0,0,-(screwThreadLength-nutThickness)/2])
        rotate([180,0,30])
            color("salmon") cylinder(d=nutWidth*2*tan(30), h=big, $fn=6);
	}
}

coupler();