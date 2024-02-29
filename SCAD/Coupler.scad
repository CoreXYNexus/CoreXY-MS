//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Coupler.scad base on a scad file from Thingiverse: www.thingiverse.com/thing:4210821
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// last update: 5/6/23
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/5/23	-  Modifications of original file made by Stephen Castello to use brass inserts, BOSL and my screwsize.scad
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad> // https://github.com/revarbat/BOSL2/wiki
include <inc/brassinserts.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use3mmInsert=1;
Height = 30;		// overall height
Diameter = 23;		// outer-diameter
HoleAdjust= 2.5;	// adjust screw hole position
Clearance=0.5;		// clearance for the leadscrew/motor
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ooupler(8,8);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ooupler(TopInnerDiameter=5,BottomInnerDiameter=8) {
	difference() {
		union() {
			translate([0, 0, (Height)/2]) color("red") cyl(d=Diameter, h=Height, rounding=3); // cylinder
			
			translate([max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/2+HoleAdjust, -2.5, Height/4*3])
				rotate([90, 0, 0]) color("blue") cyl(d=6.5, h=5, center=true);
			translate([max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/2+HoleAdjust, -2.5, Height/4])
				rotate([90, 0, 0]) color("pink") cyl(d=6.5, h=5, center=true);
			
			translate([max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/2+HoleAdjust, 2.5, Height/4*3])
				rotate([90, 0, 0]) color("white") cyl(d=Yes3mmInsert(Use3mmInsert), h=5, center=true);     // insert
			translate([max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/2+HoleAdjust, 2.5, Height/4])
				rotate([90, 0, 0]) color("green") color("purple")
					cyl(d=Yes3mmInsert(Use3mmInsert), h=5, center=true); // insert
		}
    
		translate([0,0 , Height/2]) color("gray") cylinder(d=TopInnerDiameter+Clearance, h=Height/2+10);    // upper id
		translate([0,0,-1]) color("khaki") cylinder(d=BottomInnerDiameter+Clearance, h=Height/2+2, $fn=32); // lower id
    
		ScrewAssembly(TopInnerDiameter+Clearance,BottomInnerDiameter+Clearance,Height/4*3); // top screw
		ScrewAssembly(TopInnerDiameter+Clearance,BottomInnerDiameter+Clearance,Height/4);   // bottom screw
		
		translate([-Diameter/4-max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/4, 0, -2])
			color("blue") cylinder(d=2.5, h=Height+5); // hinge hole
		translate([-Diameter/4-max(TopInnerDiameter+Clearance, BottomInnerDiameter+Clearance)/4, -0.75, -2])
			cube([Diameter, 1.5, Height+5]); // slot
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewAssembly(TopInnerDia,BottomInnerDia,h) {
    translate([max(TopInnerDia, BottomInnerDia)/2+HoleAdjust, -10, h]) rotate([90, 0, 0]) color("gold")
		cylinder(d=screw3, h=Diameter, center=true);
    translate([max(TopInnerDia, BottomInnerDia)/2+HoleAdjust,-5, h]) rotate([90, 0, 0]) color("cyan")
		cylinder(d=screw3hd, h=Diameter/2);
    translate([max(TopInnerDia, BottomInnerDia)/2+HoleAdjust, 10+Diameter/2, h]) rotate([90, 0, 0])
		color("lightgray") cylinder(d=Yes3mmInsert(Use3mmInsert), h=Diameter);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////