/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Z-Bed_Leveling_Pivots.scad --  z-axis bed rotatable bed mounts for independent z motor bed leveling
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 1/29/2017
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Last Update: 2/28/2019
/////////////////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Requires good bridging for z_pivot_2040()
/////////////////////////////////////////////////////////////////////////////////////////////////
clearance = 0.5;
layer = 0.2;	// printed layer thickness
dia_625z = 16+clearance;	// diameter of a 625z
out_dia_625z = 18+clearance;
flange_625z = 1+layer;
ht_625z = 5+layer;
body_ht_625z=4;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//z_pivots(3,1,1);	// arg1: Quanity ; Arg2: 0 for M5 pivots, 1 for 625z bearing pivots ; Arg3: 1 for round, 0 - square
//z_pivots_v2(3,1,1);	// arg1: Quanity ; Arg2: 0 for M5 pivots, 1 for 625z bearing pivots ; Arg3: 1 for round, 0 - square
//z_pivot_carriage(0);
//center_pivot2(1);
//z_pivot_2040(1,1,screw5);
//z_pivot_2040_v2(1,1,1);
z_pivot_2040_v3(1,1,1);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivots(Qty,Bearing=0,Round=1) {
	if($preview) %translate([-40,-30,-5]) cubeX([200,200,5]);
	for(i=[0:Qty-1]){
		translate([0,i*45,15]) z_pivot_2040(Bearing,Round);
		if(Round) translate([75,i*45+20,21.6]) rotate([180,90,0]) center_pivot2(Bearing);
		else translate([45,i*45,0]) center_pivot(Bearing); // non-rounded version
		if(Bearing)	translate([80,i*45,0])z_pivot_carriage(1);
		else translate([15,i*45+10,0]) spacer_pivot();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_carriage(Spacer=0,Holes_offset=42.5) { // bearing between bolt holes
	difference() {
		color("cyan") cubeX([60,24,8+flange_625z],1);
		bearing_hole2(30,12,0,1);
		bearing_flange(30,12,-15+body_ht_625z+flange_625z);
		translate([51.5,12,-2]) color("blue") cylinder(h=20,d=screw5,$fn=100); // mounting hole
		translate([51.5,12,5.5]) rotate([0,0,90]) color("red") cylinder(h=10,d=nut5+0.5,$fn=6);
		translate([51.5-Holes_offset,12,-2]) color("white") cylinder(h=20,d=screw5,$fn=100); // mounting hole
		translate([51.5-Holes_offset,12,5.5]) rotate([0,0,90]) color("plum") cylinder(h=10,d=nut5+0.5,$fn=6);
	}
	if(Spacer) difference() { // spacer to hold bearing in place
		translate([30,-10,0]) color("gray") cylinder(h=3.5,d=out_dia_625z-1,$fn=100);
		translate([30,-10,-1]) color("plum") cylinder(h=5,d=screw5hd,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_2040(Bearing=1,RoundPivot=1,Screw=screw5) { // 3 625 bearing pivot mounts on the 2040 holding the bed
	difference() {
		translate([1.5,0,-15]) color("cyan") cubeX([29,40,20],1);
		translate([5.75,-2,-23]) color("plum") cube([20.5,45,25]);
		if(RoundPivot) 
			side_screws_2040(16.5,Screw);
		else
			side_screws_2040(20,Screw);
	}
	difference() {
		translate([-0.5,0,-15]) color("blue") cubeX([5,40,40],1);
		if(RoundPivot) 
			side_screws_2040(16.5,Screw);
		else
			side_screws_2040(20,Screw);
		roundover();
	}
	translate([16,10,2])color("red") cylinder(h=layer,d=screw5hd,$fn=100); // hole supports
	translate([16,30,2])color("blue") cylinder(h=layer,d=screw5hd,$fn=100);
	difference() {
		translate([28,0,-15]) color("red") cubeX([5,40,40],1);
		if(RoundPivot) 
			side_screws_2040(16.5,Screw);
		else
			side_screws_2040(20,Screw);
		roundover();
	}
	if(!RoundPivot) // test center_pivot, should never need to tilt this far
		if($preview) %translate([6,19.7,5.5]) rotate([45,0,0]) center_pivot(Bearing);
	else
		if($preview) %translate([6,9.7,6.5]) center_pivot2(Bearing);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_2040_v2(Quanity=1,Bearing=1,RoundPivot=1) { // 3 625 bearing pivot mounts on the 2040 holding the bed
	for(num=[0:Quanity-1]) {
		translate([0,num*50,0]) {
		difference() {
			translate([1.5,0,-15]) color("cyan") cubeX([29,40,5],1);
			translate([0,0,-15]) if(RoundPivot) 
				side_screws_2040(16.5);
			else
				side_screws_2040(20);
		}
		difference() {
			translate([-0.5,0,-15]) color("blue") cubeX([5,40,25],1);
			translate([-0.5,0,-15]) if(RoundPivot) 
				side_screws_2040(16.5);
			else
				side_screws_2040(20);
			translate([-0.5,0,-15]) roundover();
		}
		difference() {
			translate([28,0,-15]) color("red") cubeX([5,40,25],1);
			translate([-0.5,0,-15]) if(RoundPivot) 
				side_screws_2040(16.5);
			else
				side_screws_2040(20);
			translate([-0.5,0,-15]) roundover();
		}
	}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_2040_v3(Quanity=1,Bearing=1,RoundPivot=1) { // 3 625 bearing pivot mounts on the 2040 holding the bed
	for(num=[0:Quanity-1]) {
		translate([0,num*25,0]) {
		difference() {
			translate([1.5,0,-15]) color("cyan") cubeX([29,20,5],1);
			translate([0,0,-15]) if(RoundPivot) 
				side_screws_2040_2(16.5);
			else
				side_screws_2040_2(20);
		}
		difference() {
			translate([-0.5,0,-15]) color("blue") cubeX([5,20,25],1);
			translate([-0.5,0,-15]) if(RoundPivot) 
				side_screws_2040_2(16.5);
			else
				side_screws_2040_2(20);
			translate([-0.5,0,-15]) roundover2();
		}
		difference() {
			translate([28,0,-15]) color("red") cubeX([5,20,25],1);
			translate([-0.5,0,-15]) if(RoundPivot) 
				side_screws_2040_2(16.5);
			else
				side_screws_2040_2(20);
			translate([-0.5,0,-15]) roundover2();
		}
	}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module roundover() { // roundover a corner
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

module roundover2() { // roundover a corner
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module center_pivot(Bearing=0) {
	if(Bearing) {
		difference() {
			color("cyan") cubeX([dia_625z+5,dia_625z+5,dia_625z+15],1);
			translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,1);
			translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,1);
			translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
			translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		}
	} else {
		difference() {
			color("cyan") cubeX([dia_625z+5,dia_625z+5,dia_625z+15],1);
			translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2();
			translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2();
			translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
			translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		}
	}
	screw_hole_spport(dia_625z/2+2.5,dia_625z/2+2.5,dia_625z/2+17);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module center_pivot2(Bearing) {
	difference() {
		translate([0,0.5,dia_625z/2]) color("cyan") cubeX([dia_625z+5,dia_625z+4,dia_625z+5],1);
		double_bearing_mount_hole();
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
		translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		rotate([0,90,0]) bearing_flange(-10.5,11,22-flange_625z);
		rotate([0,90,0]) bearing_flange(-10.5,11,-15+flange_625z);
	}
	translate([14.8,9,9]) color("plum") rotate([0,90,0]) cylinder(h=layer,d=dia_625z+1); // bearing hole support
	double_bearing_mount(Bearing);
	//screw_hole_spport(dia_625z/2+2.5,dia_625z/2+2.5,dia_625z/2+13-layer);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module spacer_pivot(Qty=1,AdjustHeight=0) { // a little spacer to make it pivotable on the makerslide carriage plate,
	for(i=[0:Qty-1]){		 //	uses excentric hole
		translate([0,i*10,0]) difference() {
			color("blue") cylinder(h=4+AdjustHeight,d=6.8,$fn=100);
			translate([0,0,-2]) color("cyan") cylinder(h=10,d=screw5,$fn=100);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_hole_spport(X,Y,Z) { // support the bottom of the carriage side M5 hole on the center pivot
	translate([X,Y,Z]) color("pink") cylinder(h=layer,d=screw5hd);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module double_bearing_mount(Bearing) {
	difference() {
		translate([0,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0])
			color("pink") cylinder(h=dia_625z+5,d=dia_625z+5,$fn=100);
		translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,Bearing);
		translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,Bearing);
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
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

module side_screws_2040(PivotZpos=20,Screw=screw5) {
	translate([-7,10,-8]) rotate([0,90,0]) color("white") cylinder(h=50,d=Screw,$fn=100);
	translate([-9,10,-8]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw5hd,$fn=100);
	translate([31,10,-8]) rotate([0,90,0]) color("plum") cylinder(h=10,d=screw5hd,$fn=100);
	translate([-7,30,-8]) rotate([0,90,0]) color("gray") cylinder(h=50,d=Screw,$fn=100);
	translate([-9,30,-8]) rotate([0,90,0]) color("cyan") cylinder(h=10,d=screw5hd,$fn=100);
	translate([31,30,-8]) rotate([0,90,0]) color("pink") cylinder(h=10,d=screw5hd,$fn=100);
	translate([-7,20,PivotZpos]) rotate([0,90,0]) color("salmon") cylinder(h=50,d=screw5,$fn=100); // pivot
	translate([-9,20,PivotZpos]) rotate([0,90,0]) color("yellow") cylinder(h=10,d=screw5hd,$fn=100); // pivot
	translate([30,20,PivotZpos]) rotate([0,90,0]) color("lime") cylinder(h=10,d=nut5+0.5,$fn=6); // pivot
	// end screw holes
	translate([16,10,-8])color("white") cylinder(h=50,d=screw5,$fn=100);
	translate([16,10,4])color("lightgray") cylinder(h=10,d=screw5hd,$fn=100);
	translate([16,30,-8]) color("gray") cylinder(h=50,d=screw5,$fn=100);
	translate([16,30,4])color("tan") cylinder(h=10,d=screw5hd,$fn=100);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module side_screws_2040_2(PivotZpos=20,Screw=screw5) {
	translate([-7,10,PivotZpos]) rotate([0,90,0]) color("salmon") cylinder(h=50,d=screw5,$fn=100); // pivot
	translate([31,10,PivotZpos]) rotate([0,90,0]) color("lime") cylinder(h=10,d=nut5+0.5,$fn=6); // pivot
	// end screw holes
	translate([16,10,-8])color("white") cylinder(h=50,d=screw5,$fn=100);
	translate([16,10,4])color("lightgray") cylinder(h=10,d=screw5hd,$fn=100);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////