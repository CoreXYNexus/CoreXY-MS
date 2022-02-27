//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ZMotorLeadscrewCoupler.scad base on a scad file from Thingiverse
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Modifications of original file made by Stephen Castello:
// 12/17/18	- edited to use in another scad file and added preview colors, renamed to ZMotorLeadscrewCoupler.scad
// 10/22/20	- Added use of brass inserts
// 1/6/22	- BOSL2
// 2/10/22	- Changed outside diamter to 23mm and shifted the screw holes out 1mm on each side
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/brassinserts.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
LargeInsert=1;
couplerHeight = 30;				// Height of the coupler, half for the motor shaft and half for the rod
couplerExternalDiameter = 23;	// External diameter of the coupler
screwDiameter = 3.4;
screwHeadDiameter = 7;
screwThreadLength = 10;
nutWidth = 5.7;				// Width across flats of the nut (wrench size)
nutThickness = 3;
halvesDistance = 0.6;		// Gap between the two halves
shaftLen = couplerHeight/2;	// Portion of the shaft inside the coupler
rodLen = couplerHeight/2;	// Portion of the rod inside the coupler

$fa = 0.02;
$fs = 0.25;
little = 0.01; // just a little number
big = 100; // just a big number
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

coupler(3,8,8);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module coupler(Qty=1,motorShaftDiameter = 5,threadedRodDiameter = 8) {
	shaftScrewsDistance = motorShaftDiameter+screwDiameter+1;
	rodScrewsDistance = threadedRodDiameter+screwDiameter+1;
	for(x=[0:Qty-1]) {
		translate([x*25,0,0]) difference() {
			// main body
			translate([0,0,shaftLen]) color("cyan") cyl(d=couplerExternalDiameter, h=shaftLen + rodLen,rounding=2);
			// shaft
			translate([0,0,7])
				color("red") cyl(d=motorShaftDiameter, h=shaftLen+2*little+5);
			// rod
			translate([0,0,shaftLen+8])
				color("gray") cyl(d=threadedRodDiameter, h=rodLen+little);
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
			color("green") cube([halvesDistance,big,big], center=true);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw()
{
    // thread
    translate([1,0,0]) color("plum") cyl(d=screwDiameter, h=big);
    // head
    translate([1,0,(screwThreadLength-nutThickness)/2+big/2])
        color("gold") cyl(d=screwHeadDiameter, h=big);
	if(Use3mmInsert) {
		translate([1,0,-(screwThreadLength-nutThickness)/2+3.5-big/2])
			rotate([180,0,30])
				color("lightgray") cyl(d=Yes3mmInsert(Use3mmInsert,LargeInsert), h=big);
    } else { // nut
		translate([1,0,-(screwThreadLength-nutThickness)/2-5-big/2])
			rotate([180,0,30])
				color("salmon") cyl(d=nutWidth*2*tan(30), h=big, $fn=6);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
