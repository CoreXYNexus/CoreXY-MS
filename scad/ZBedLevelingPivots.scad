/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Z-Bed_Leveling_Pivots.scad --  z-axis bed rotatable bed mounts for independent z motor bed leveling
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 10/22/20
// Last Update: 6/19/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/15/17	- Added bearing pivot style carriage & 2040 mounts for multi-motor leveling
// 1/29/17	- Added pivot version using just a M5 screw
//			  Made separate scad file for this and removed them from corexy-z-axis.scad
//			  Added roounded version of the center pivot
// 1/30/17	- Fixed M5 round version
// 2/5/17	- Added a spacer for the center_pivot to allow it to rotate in the makerslide carriage plate
// 8/19/19	- OpenSCAD 2018.06.01 for $preview, added 200x200 bed in preview
// 12/21/18	- Added to countersinks and nut holders
//			  Changed to 625Z bearings (they're what I have)
// 1/29/19	- Fixed z_pivots() so all parts are on the same z0
//			  Added z_pivot_2040_v2(), it uses less plastic, it only attaches to the end of a 2040
//			  Added screw size to extrusion slots option to z_pivot_2040()
// 2/28/19	- Added z_pivot_2040_v2x3() for three z_pivot_2040_v2()
// 3/31/19	- Added a 2020 pivot in z_pivot_2040_v3()
// 7/13/19	- Added to z_pivots() to make either 2020 end or side
// 8/14/19	- Added a z_pivot with anti-rotation sides
// 6/12/20	- Added adjustable length size for the bed pivot in ZPivotBed
// 6/27/20	- Added some comments, changed z_pivots() to be able select the flat 2020,2040 or none
//			- Added a long bed pivot mount for 2020 in ZPivot2020() and 2040 in ZPivot2040()
// 10/22/20	- Finished use of 5mm brass inserts
// 12/25/21	- Bed Leveling pivot mounts made more robust, removed unused code and renamed some modules
// 1/4/22	- Converted to BOSL2; rounded the pivots
// 5/3/22	- Renamed variables to a better description, added PivotsOverLeadScrew() to have bed pivots at the leadscrew
// 5/5/22	- Removed unused code, renamed modules lower case names with upper/lower names, removed non-bearing code
// 5/8/22	- Added rounded version of CenterPivot(), changed BasePivotOverLeadscrew() to rounded bearing section
// 6/19/22	- Got mkaerslide plate drwaing an updated the mounting holes
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://www.inventables.com/technologies/standard-wheel-carriage-plate
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
use <inc/nema17.scad>			// https://github.com/mtu-most/most-scad-libraries
include <BOSL2/std.scad>		// https://github.com/revarbat/BOSL2
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use5mmInsert=1;
LayerThickness=0.3;
//----------------------------------------------------------------
Clearance = 0.5;
Diameter625Z = 16+Clearance;	// diameter of a F625Z, not including flange
FlangeDiameter625Z = 18+Clearance;
FlangeHeight625z = 1.2;
Height625Z = 5.2;
BodyHeight625Z=4;
FlangeThickness=0.2;
//----------------------------------------------------------------
BedWidth=310;							// bed Y size
ZCarriadgeWidth=581;					// distance between the Z makerslide plates (X min side, Y max side)
ZLength=(ZCarriadgeWidth-BedWidth)/2;	// to center bed in printer along X asis
PivotLengthSide=28.5;					// Side version
PivotLengthOverLeadScrew=59.54;			// OverLeadscrew version
FrontBedMountLength=95;					// front, measured from the makerslide plate to the 2020 holding the bed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//SidePivots(3,1,0);   // arg: Quanity; arg2: CenterPivot; arg3:Square CenterPivot
//rotate([-90,0,0])
//PivotBed(2,FrontBedMountLength,PivotLengthSide);
//translate([30,80,0]) rotate([-90,0,0])
//	PivotBed(1,ZCarriadgeWidth-BedWidth-FrontBedMountLength,PivotLengthSide);

PivotsOverLeadScrew(3,1,1,0);   // arg1: Quanity; arg2:Spacer; arg3:CenterPivot; arg4:Square CenterPivot
translate([55,-20,0]) rotate([-90,0,0])
	PivotBed(2,FrontBedMountLength,PivotLengthOverLeadScrew);
FourTab();  // tabs to hold ends
translate([55,35,0]) rotate([-90,0,0])
	PivotBed(1,ZCarriadgeWidth-BedWidth-FrontBedMountLength,PivotLengthOverLeadScrew);
TwoTab();  // tabs to hold ends
//MakerSlidePlateHoles();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MakerSlidePlateHoles(Height=20,Screw=screw5,All=0) {
	if(All) {
		translate([10,12.7,0]) cyl(h=Height,d=Screw);
		translate([10,35,0]) cyl(h=Height,d=Screw);
		translate([10,45,0]) cyl(h=Height,d=Screw);
		translate([10,55,0]) cyl(h=Height,d=Screw);	
		translate([10,77.3,0]) cyl(h=Height,d=Screw);
		translate([30,12.7,0]) cyl(h=Height,d=Screw);
		translate([30,77.3,0]) cyl(h=Height,d=Screw);
		
		translate([47.7,12.7,0]) cyl(h=Height,d=Screw);
		translate([47.7,45,0]) cyl(h=Height,d=Screw);
		translate([47.7,77.3,0]) cyl(h=Height,d=Screw);
	}
	translate([60,35,0]) cyl(h=Height,d=Screw);
	translate([60,55,0]) cyl(h=Height,d=Screw);

	translate([70,12.7,0]) cyl(h=Height,d=Screw);
	if(All) translate([70,45,0]) cyl(h=Height,d=Screw);
	translate([70,77.3,0]) cyl(h=Height,d=Screw);
	if(All) {
		translate([80,12.7,0]) cyl(h=Height,d=Screw);
		translate([80,35,0]) cyl(h=Height,d=Screw);
		translate([80,45,0]) cyl(h=Height,d=Screw);
		translate([80,55,0]) cyl(h=Height,d=Screw);	
		translate([80,77.3,0]) cyl(h=Height,d=Screw);
	}
	translate([90,12.7,0]) cyl(h=Height,d=Screw);
	if(All) translate([90,45,0]) cyl(h=Height,d=Screw);
	translate([90,77.3,0]) cyl(h=Height,d=Screw);

	translate([100,35,0]) cyl(h=Height,d=Screw);
	translate([100,55,0]) cyl(h=Height,d=Screw);
	if(All) {
		translate([112.3,12.7,0]) cyl(h=Height,d=Screw);
		translate([112.3,77.3,0]) cyl(h=Height,d=Screw);
	
		translate([130,12.7,0]) cyl(h=Height,d=Screw);
		translate([130,77.3,0]) cyl(h=Height,d=Screw);

		translate([150,12.7,0]) cyl(h=Height,d=Screw);
		translate([150,35,0]) cyl(h=Height,d=Screw);
		translate([150,45,0]) cyl(h=Height,d=Screw);
		translate([150,55,0]) cyl(h=Height,d=Screw);	
		translate([150,77.3,0]) cyl(h=Height,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FourTab() {
	translate([64.5,23,-19.85]) color("gray") cyl(h=LayerThickness,d=10); 
	translate([93.5,23,-19.85]) color("lightgray") cyl(h=LayerThickness,d=10); 
	translate([117.5,23,-19.85]) color("blue") cyl(h=LayerThickness,d=10); 
	translate([145.5,23,-19.85]) color("cyan") cyl(h=LayerThickness,d=10); 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TwoTab() {
	translate([65,159,-19.85]) color("gray") cyl(h=LayerThickness,d=10); 
	translate([94,159,-19.85]) color("lightgray") cyl(h=LayerThickness,d=10); 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SidePivots(Qty,Center=1,Square=0) { // mounts on the side of the makerslide plate
	for(i=[0:Qty-1]){
		if(Center) translate([0,i*25+23,21.6]) rotate([180,90,0]) CenterPivot(Square);
		translate([5,i*25,0]) PivotCarriage(1);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotsOverLeadScrew(Qty=1,Spacer=1,Center=1,Square=0) {  // mounts above the leadscrew nut mount
	for(i=[0:Qty-1]) translate([0,i*55,0]) BasePivotOverLeadscrew(Spacer,Center,Square);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotCarriage(Spacer=0,Holes_offset=42.5) {  // mounts on the side of the makerslide plate
	difference() {
		color("cyan") cuboid([60,24,8+FlangeHeight625z],rounding=2,p1=[0,0]);
		translate([30,12,0]) BearingHole();
		translate([30,12,-15+BodyHeight625Z+FlangeHeight625z]) BearingFlange();
		translate([51.5,12,-2]) color("blue") cylinder(h=20,d=Yes5mmInsert(Use5mmInsert)); // mounting hole
		translate([51.5-Holes_offset,12,-2]) color("white")
			cylinder(h=20,d=Yes5mmInsert(Use5mmInsert)); // mounting hole
	}
	translate([FlangeDiameter625Z+2,2,FlangeHeight625z+4]) color("plum")
		cube([FlangeDiameter625Z+1,FlangeDiameter625Z+1,LayerThickness]);
	if(Spacer) { // spacer to hold bearing in place
		translate([70,12,3.5/2])  difference() {
			color("gray") cyl(h=3.5,d=FlangeDiameter625Z-1,rounding=1);
			color("plum") cyl(h=5,d=screw5hd);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BasePivotOverLeadscrew(Spacer=1,Center=1,Square=0,HoleOffset=41.5) {  // mounts above the leadscrew nut mount
	difference() {
		union() {
			color("cyan") hull() {  // base
				hull() color("cyan") {
					translate([-20,0,0]) cyl(h=40,d=24,rounding=2);
					translate([20,0,0]) cyl(h=40,d=24,rounding=2);
				}
				translate([-13,-25,-17.6]) hull() {
					cyl(h=5,d=5,rounding=2);
					translate([25,0,0]) cyl(h=5,d=4,rounding=2);
				}
			}
		}
		translate([0,0,10]) BearingHole();  // pivot bearing
		translate([0,0,-17.5-Height625Z])  BearingFlange(Clearance); // space for bearing flange
		translate([-80,-35,-15]) MakerSlidePlateHoles();
		translate([0,0,5]) rotate([90,0,0]) color("khaki") cyl(h=50,d=11); // leadscrew hole
	}
	if(Spacer) translate([42,0,-5/2]) difference() { // spacer for holding bearing in place
		color("gray") cyl(h=40-5,d=FlangeDiameter625Z-1-Clearance,rounding=1);
		color("plum") cyl(h=50,d=screw5hd);
		translate([0,0,7]) rotate([90,0,0]) color("khaki") cyl(h=50,d=11); // leadscrew hole
	}
	if(Center) translate([-37,10,1.5]) rotate([180,90,0]) CenterPivot(Square);
	translate([0,0,22.65-Height625Z]) color("green") cyl(h=LayerThickness,d=FlangeDiameter625Z); // flange hole support
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CenterPivot(Square=0) { // middle pivot
	difference() {
		union() {
			if(Square) {
				translate([0,0.5,Diameter625Z/2]) color("cyan")
					cuboid([Diameter625Z+5,Diameter625Z+4,Diameter625Z+5],rounding=2,p1=[0,0]);
			} else {
				translate([10.75,10.5,Diameter625Z+3]) color("cyan")
					cyl(h=Diameter625Z+5,d=Diameter625Z+5,rounding=2);
			}
			translate([0.25,0,0]) DoubleBearingMount();
		}
		translate([18,0,0]) DoubleBearingMountHole();
		translate([Diameter625Z/2+2.5,Diameter625Z/2+2.5,Diameter625Z-3]) color("green")
			cylinder(h=40,d=Yes5mmInsert(Use5mmInsert));
		translate([21.5-FlangeHeight625z,11,9+FlangeHeight625z]) rotate([0,90,0]) BearingFlange(); 
		translate([-40+FlangeHeight625z,11,9+FlangeHeight625z]) rotate([0,90,0]) BearingFlange();
	}
	translate([20,11,10]) color("green") rotate([0,90,0]) cylinder(h=LayerThickness,d=FlangeDiameter625Z+1);
	translate([21.2,11,31]) color("gray") rotate([0,90,0]) cylinder(h=LayerThickness,d=FlangeDiameter625Z+1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoubleBearingMount() {
	difference() {
		translate([10.5,Diameter625Z/2+2.5,Diameter625Z/2+2]) rotate([0,90,0])
			color("pink") cyl(h=Diameter625Z+5,d=Diameter625Z+5,rounding=1);
		translate([10,Diameter625Z/2+2.5,Diameter625Z/2+2]) rotate([0,90,0]) BearingHole();
		//translate([Diameter625Z/2+2.5,Diameter625Z/2+2.7,Diameter625Z-3]) color("yellow")
		//	cylinder(h=40,d=Yes5mmInsert(Use5mmInsert));
		translate([21.3-FlangeHeight625z,11,9+FlangeHeight625z]) rotate([0,90,0]) BearingFlange(); 
		translate([-40.3+FlangeHeight625z,11,9+FlangeHeight625z]) rotate([0,90,0]) BearingFlange();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoubleBearingMountHole() {
	translate([-10,Diameter625Z/2+2.5,Diameter625Z/2+2]) rotate([0,90,0]) BearingHole();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole() {
	color("white") cyl(h=40,d=Diameter625Z);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingFlange(AdditionalClearance=0) {
	color("red") cylinder(h=40,d=FlangeDiameter625Z+Clearance+AdditionalClearance);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotBed(Quanity=1,Length=ZLength,ZPivotLength=PivotLengthOverLeadScrew) { // pivot mounts on the bed
	for(num=[0:Quanity-1]) {
		translate([num*52,,00]) {
				%translate([12.5,10,Length-ZPivotLength]) rotate([0,90,0]) { // test fit pivot
				difference() {
					cylinder(h=23.5,d=22);
					translate([0,0,-3]) cylinder(h=40,d=screw5);
				}
			}
			difference() {
				union() {
					color("cyan") hull() {
						cuboid([49,20,5],rounding=2,p1=[0,0]); //bottom
						translate([29/4,0,Length-ZPivotLength-18]) cuboid([34,20,5],rounding=2,p1=[0,0]); // top
					}
				}
				if(Length>50) { // weight reduction
					translate([5,-5,5]) color("blue") hull() {
						translate([1.5,0,0]) cuboid([16,21,5],rounding=2,p1=[0,0]);
						translate([29/4,0,Length-ZPivotLength-27]) cuboid([10,21,5],rounding=2,p1=[0,0]);
					}
					translate([5,-5,5]) color("white") hull() {
						translate([21.5,0,0]) cuboid([16,21,5],rounding=2,p1=[0,0]);
						translate([29/4+14,0,Length-ZPivotLength-27]) cuboid([10,21,5],rounding=2,p1=[0,0]);
					}
					if(Length>120) {
						translate([24.5,0,Length/2]) color("green") rotate([90,0,0])
							cyl(h=50,d=screw5); // for 2020 bottom support
						translate([24.5,0,Length/8]) color("gold") rotate([90,0,0]) cyl(h=50,d=screw5);
					}
				}
				translate([14,10,-4]) color("red") cylinder(h=30,d=screw5);   // 2020 mount holes
				translate([14,10,4]) color("green") cylinder(h=5,d=screw5hd);
				translate([34,10,-4]) color("green") cylinder(h=30,d=screw5);
				translate([34,10,4]) color("red") cylinder(h=5,d=screw5hd);
			}
			if(Length>120) { // for 2020 bottom support
				translate([24.5,10,Length/3.5]) color("red") cuboid([35,20,6],rounding=2); // center divider
				difference() { // bottom screw hole for 2020 bottom support
					translate([24.5,10,Length/8]) color("purple") rotate([90,0,0])
						cyl(h=20,d1=screw5+1,d2=screw5hd,rounding2=2);
					translate([24.5,0,Length/8]) color("red") rotate([90,0,0]) cyl(h=50,d=screw5);
				}
				difference() { // top screw hole for 2020 bottom support
					translate([24.5,10,Length/2]) color("red") rotate([90,0,0]) cyl(h=20,d1=screw5+1,d2=screw5hd,rounding2=2);
					translate([24.5,0,Length/2]) color("blue") rotate([90,0,0]) cyl(h=50,d=screw5);
				}
			}
			translate([36,10,Length-ZPivotLength]) color("red") rotate([0,-90,0]) BuiltInWasher();
			translate([12.5,10,Length-ZPivotLength]) color("blue") rotate([0,90,0])
				BuiltInWasher(Yes5mmInsert(Use5mmInsert));
			translate([7.5,10,Length-ZPivotLength]) color("pink") rotate([180,90,0])
				BuiltInWasher(Yes5mmInsert(Use5mmInsert)); // mkake thick enough for the 6mm length insert
			translate([49/2,2.5,5]) color("red") sphere(1); // mark centerpoint
			difference() {
				translate([29/4+0.25,0,Length-ZPivotLength-16]) { // top pivot
					color("green") cuboid([5,20,25],rounding=1,p1=[0,0]);
					translate([23.5+5,0,0]) color("red") cuboid([5,20,25],rounding=1,p1=[0,0]);
				}
				translate([25,10,Length-ZPivotLength]) color("plum") rotate([0,90,0])
					cylinder(h=20,d=screw5); // pivot hd
				translate([40,10,Length-ZPivotLength]) color("white") rotate([0,90,0]) // pivot head
					cylinder(h=5,d=screw5hd);
				translate([0,10,Length-ZPivotLength]) color("gray") rotate([0,90,0]) // pivot
					cylinder(h=20,d=Yes5mmInsert(Use5mmInsert));
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BuiltInWasher(Screw=screw5) {
	difference() {
		hull() {
			cylinder(h=0.5,d=Screw+2);
			translate([0,0,-3]) cylinder(h=0.5,d=Screw+6);
		}
		translate([0,0,-10]) cylinder(h=20,d=Screw);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////