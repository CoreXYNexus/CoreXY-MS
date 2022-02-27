/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Z-Bed_Leveling_Pivots.scad --  z-axis bed rotatable bed mounts for independent z motor bed leveling
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 10/22/20
// Last Update: 1/4/22
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
////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
include <inc/brassinserts.scad>
include <BOSL2/std.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////
Use5mmInsert=1;
LayerThickness=0.3;
//-----------------------------------------------------
clearance = 0.5;
dia_625z = 16+clearance;	// diameter of a 625z
out_dia_625z = 18+clearance;
flange_625z = 1.2;
ht_625z = 5.2;
body_ht_625z=4;
FlangeThickness=0.2;
//---------------------
BedWidth=310;
ZCarriadgeWidth=581;
ZLength=(ZCarriadgeWidth-BedWidth)/2;
CenterPivotLength=100;
ZPivotLength=28.5;
//----------------------------------------------------------------
LengthAdjust=0;
BedMountLength=80;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//Pivots(3,1);// arg1: Quanity;Arg2: 0 for M5 pivots, 1 for 625z bearing pivots;Arg3: 0 for none, 1 for 2020, 2 for 2040
// Length is between the mackerslide carriage plate and the bed frame
PivotBed(2,BedMountLength+LengthAdjust);		// equal length long bed pivots for 2020
translate([50,0,0]) 
	PivotBed(1,ZCarriadgeWidth-BedWidth-BedMountLength+LengthAdjust); // equal length long bed pivots for 2020

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Pivots(Qty,Bearing=0,Extrusion=0) {
	//if($preview) %translate([-40,-30,-5]) cuboid([200,200,5]);
	for(i=[0:Qty-1]){
		translate([0,i*25+23,21.6]) rotate([180,90,0]) CenterPivot(Bearing);
		if(Bearing)	translate([5,i*25,0])PivotCarriage(1);
		else translate([15,i*25+10,0]) SpacerPivot();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotCarriage(Spacer=0,Holes_offset=42.5) { // bearing between bolt holes
	difference() {
		color("cyan") cuboid([60,24,8+flange_625z],rounding=2,p1=[0,0]);
		bearing_hole2(30,12,0,1);
		bearing_flange(30,12,-15+body_ht_625z+flange_625z);
		translate([51.5,12,-2]) color("blue") cylinder(h=20,d=Yes5mmInsert(Use5mmInsert),$fn=100); // mounting hole
		if(!Use5mmInsert) {
			translate([51.5,12,5.5]) rotate([0,0,90]) color("red") cylinder(h=10,d=nut5+0.5,$fn=6);
			translate([51.5,12,-2]) color("blue") cylinder(h=20,d=screw5,$fn=100); // mounting hole
		}
		translate([51.5-Holes_offset,12,-2]) color("white")
			cylinder(h=20,d=Yes5mmInsert(Use5mmInsert),$fn=100); // mounting hole
		if(!Use5mmInsert) {
			translate([51.5-Holes_offset,12,5.5]) rotate([0,0,90]) color("plum") cylinder(h=10,d=nut5+0.5,$fn=6);
			translate([51.5-Holes_offset,12,-2]) color("white") cylinder(h=20,d=screw5,$fn=100); // mounting hole
		}
	}
	translate([out_dia_625z+2,2,flange_625z+4]) color("plum") cube([out_dia_625z+1,out_dia_625z+1,LayerThickness]);
	if(Spacer) translate([70,12,0]) difference() { // spacer to hold bearing in place
		translate([0,0,3.5/2]) color("gray") cyl(h=3.5,d=out_dia_625z-1,rounding=1);
		translate([0,0,-1]) color("plum") cylinder(h=5,d=screw5hd,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Notch20mm(Width=29,X=0,Y=0,Z=0) {
	translate([X,Y,Z]) difference() {
		translate([2,13,0]) color("pink") cuboid([Width,7,20],rounding=1,p1=[0,0]);
		translate([5.725,0,-2]) color("gray") cuboid([20.5,25,25],rounding=1,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module roundover() { // round the corner
	translate([-5,-10,15]) {
		difference() {
			color("white") cube([20,20,20]);
			translate([-5,20,0]) rotate([0,90,0]) color("gray") cylinder(h=30,d=20,$fn=100);
		}
	}
	translate([15,-10,15]) {
		difference() {
			color("plum") cube([20,20,20]);
			translate([-5,20,0]) rotate([0,90,0]) color("lightgray") cylinder(h=30,d=20,$fn=100);
		}
	}
	translate([25,40,0]) rotate([0,0,180]) {
		translate([-10,-10,15]) {
			difference() {
				color("pink") cube([20,20,20]);
				translate([-5,20,0]) rotate([0,90,0]) color("black") cylinder(h=30,d=20,$fn=100);
			}
		}
		translate([10,-10,15]) {
			difference() {
				color("gold") cube([20,20,20]);
				translate([-5,20,0]) rotate([0,90,0]) color("white") cylinder(h=30,d=20,$fn=100);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module roundover2() { // round a corner
	translate([-5,-10,15]) {
		difference() {
			color("white") cube([20,40,20]);
			translate([-5,20,0]) rotate([0,90,0]) color("gray") cylinder(h=30,d=20,$fn=100);
		}
	}
	translate([15,-10,15]) {
		difference() {
			color("plum") cube([20,40,20]);
			translate([-5,20,0]) rotate([0,90,0]) color("lightgray") cylinder(h=30,d=20,$fn=100);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CenterPivot(Bearing) { // middle pivot
	difference() {
		translate([0,0.5,dia_625z/2]) color("cyan") cuboid([dia_625z+5,dia_625z+4,dia_625z+5],rounding=2,p1=[0,0]);
		double_bearing_mount_hole();
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=Yes5mmInsert(Use5mmInsert));
		if(!Use5mmInsert) {
			translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
			translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		}
		rotate([0,90,0]) bearing_flange(-10.5,11,22-flange_625z);
		rotate([0,90,0]) bearing_flange(-10.5,11,-15+flange_625z);
	}
	translate([20.5,11,10]) color("white") rotate([0,90,0]) cylinder(h=LayerThickness,d=out_dia_625z+1);
	translate([14.7,10.5,10.5]) color("plum") rotate([0,90,0]) cylinder(h=LayerThickness,d=dia_625z); // bearing hole support
	double_bearing_mount(Bearing);
	screw_hole_support(dia_625z/2+2.5,dia_625z/2+2.5,dia_625z/2+13-FlangeThickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpacerPivot(Qty=1,AdjustHeight=0) { // a little spacer to make it pivotable on the makerslide carriage plate,
	for(i=[0:Qty-1]){		 //	uses excentric hole
		translate([0,i*10,0]) difference() {
			color("blue") cylinder(h=4+AdjustHeight,d=6.8,$fn=100);
			translate([0,0,-2]) color("cyan") cylinder(h=10,d=screw5,$fn=100);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_hole_support(X,Y,Z) { // support the bottom of the carriage side M5 hole on the center pivot
	translate([X,Y,Z]) color("pink") cylinder(h=FlangeThickness,d=screw5hd);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module double_bearing_mount(Bearing) {
	difference() {
		translate([10.5,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0])
			color("pink") cyl(h=dia_625z+5,d=dia_625z+5,rounding=1);
		translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,Bearing);
		translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,Bearing);
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow")
			cylinder(h=40,d=Yes5mmInsert(Use5mmInsert),$fn=100);
		if(!Use5mmInsert) translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3])
				color("yellow") cylinder(h=40,d=screw5,$fn=100);
		rotate([0,90,0]) bearing_flange(-10.5,11,22-flange_625z);
		rotate([0,90,0]) bearing_flange(-10.5,11,-15+flange_625z);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module double_bearing_mount_hole() {
	translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,1);
	translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole2(Xpos=0,Ypos=0,Zpos=0,Bearing=0) {
	if(Bearing) {
		translate([Xpos,Ypos,Zpos]) color("white") cylinder(h=15,d=dia_625z,$fn=100);
		translate([Xpos,Ypos,-2]) color("black") cylinder(h=30,d=screw5hd,$fn=100);
	} else {
		translate([Xpos,Ypos,-2]) color("black") cylinder(h=30,d=screw5,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_flange(Xpos,Ypos,Zpos) {
	translate([Xpos,Ypos,Zpos]) color("red") cylinder(h=15,d=out_dia_625z,$fn=100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotBed(Quanity=1,Length=ZLength,Adjust=0) { // pivot mounts on the makerslide carriage plate to hold the bed
	for(num=[0:Quanity-1]) {
		translate([0,num*30,0]) {
				%translate([12.5,10,Length-ZPivotLength+Adjust]) rotate([0,90,0]) { // test fit pivot
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
					translate([24.5,0,20]) color("green") rotate([90,0,0]) cyl(h=50,d=screw5); // for 2020 bottom support
					if(Length>80) translate([24.5,0,Length-60]) color("gold") rotate([90,0,0]) cyl(h=50,d=screw5);
				}
				translate([14,10,-4]) color("red") cylinder(h=30,d=screw5);   // 2020 mount holes
				translate([14,10,4]) color("green") cylinder(h=5,d=screw5hd);
				translate([34,10,-4]) color("green") cylinder(h=30,d=screw5);
				translate([34,10,4]) color("red") cylinder(h=5,d=screw5hd);
			}
			difference() { // for 2020 bottom support
				translate([24.5,10,20]) color("red") rotate([90,0,0]) cyl(h=20,d=screw5hd,rounding=2);
				translate([24.5,0,20]) color("blue") rotate([90,0,0]) cyl(h=50,d=screw5);
			}
			if(Length>80) { // for 2020 bottom support
				translate([24,10,Length/2-20]) color("red") cuboid([33,20,6],rounding=2);
				difference() {
					translate([24.5,10,Length-60]) color("blue") rotate([90,0,0]) cyl(h=20,d=screw5hd,rounding=2);
					translate([24.5,0,Length-60]) color("red") rotate([90,0,0]) cyl(h=50,d=screw5);
				}
			}
			translate([36,10,Length-ZPivotLength+Adjust]) color("red") rotate([0,-90,0]) BuiltInWasher();
			translate([12.5,10,Length-ZPivotLength+Adjust]) color("blue") rotate([0,90,0])
				BuiltInWasher(Yes5mmInsert(Use5mmInsert));
			translate([49/2,2.5,5]) color("red") sphere(1); // centerpoint
			difference() {
				translate([29/4+0.25,0,Length-ZPivotLength-16]) { // top pivot
					//%translate([29/4+5,5,Length-ZPivotLength-out_dia_625z*2-5+6]) cube([23.5,5,5]);
					translate([0,0,0]) color("green") cuboid([5,20,25+Adjust],rounding=1,p1=[0,0]);
					translate([23.5+5,0,0]) color("red") cuboid([5,20,25+Adjust],rounding=1,p1=[0,0]);
				}
				translate([25,10,Length-ZPivotLength+Adjust]) color("plum") rotate([0,90,0])
					cylinder(h=20,d=screw5); // pivot hd
				translate([40,10,Length-ZPivotLength+Adjust]) color("white") rotate([0,90,0]) // pivot head
					cylinder(h=5,d=screw5hd);
				translate([0,10,Length-ZPivotLength+Adjust]) color("gray") rotate([0,90,0]) // pivot
					cylinder(h=20,d=Yes5mmInsert(Use5mmInsert));
				if(Length<50) {
					translate([14,10,Length-ZPivotLength-1]) color("green") cyl(h=23,d=screw5hd,rounding=2); // mount access
					translate([34,10,Length-ZPivotLength-1]) color("white") cyl(h=23,d=screw5hd,rounding=2);
				}
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



///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZPivotSupportCenter(Length) {
		translate([6.9,15.5,0]) {
			color("green") hull() {
				cylinder(h=Length-ZPivotLength-out_dia_625z*2+5,d=screw5);
				translate([19,0,0]) cylinder(h=Length-ZPivotLength-out_dia_625z*2+5,d=screw5);
			}
		}
		translate([7.5,24.5,0]) {
			color("pink") hull() {
				cylinder(h=Length-ZPivotLength-out_dia_625z*2+5,d=screw5);
				translate([17.5,0,0]) cylinder(h=Length-ZPivotLength-out_dia_625z*2+5,d=screw5);
			}
		}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PivotScrewHole(Screw=screw5,Length) {
	translate([-8,20,Length-ZPivotLength-out_dia_625z]) rotate([0,90,0]) cylinder(h=50,d=Screw);
	if(!Use5mmInsert) {
		translate([31.5,20,Length-ZPivotLength-out_dia_625z]) rotate([0,90,0]) color("lime")
			cylinder(h=10,d=nut5,$fn=6); // pivot
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////