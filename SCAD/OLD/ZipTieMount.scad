//////////////////////////////////////////////////////////////////////////////////////////////////
// ZipTieMount.scad
//////////////////////////////////////////////////////////////////////////////////////////////////
// created 9/7/2018
// last update 11/3/21
//////////////////////////////////////////////////////////////////////////////////////////////////
// something to hold the zipties that support the stuff going to the hotend on the
// x carriage.
//////////////////////////////////////////////////////////////////////////////////////////////////
// 5/15/19	- Made resizable, can now use M3, M4 and M5 for the mounting
// 9/13/20	- Mde loop thicker, ablity to set quanity
// 9/12/21	- Added one that uses a zip tie to hold the wires
// 11/3/21	- Thickened the ziptie mounts
////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
include <inc/corner-tools.scad>
// https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862
// by Ewald Ikemann
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////

//Cylmount(1,screw5,15); // Quanity=1,Screw=screw5|screw4|screw3,HoleSize=10
ZTmount(1,screw5,15); // Quanity=1,Screw=screw5|screw4|screw3,HoleSize=10

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cubeX(size,Rounding) { // temp module
	cuboid(size,rounding=Rounding,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module Cylmount(Quanity=1,Screw=screw5,HoleSize=10) {
	for(x = [0 : Quanity-1]) {
		translate([x*25,0,0]) {
			clip(HoleSize);
			mount(Screw);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module ZTmount(Quanity=1,Screw=screw5,HoleSize=10) {
	for(x = [0 : Quanity-1]) {
		translate([x*25,0,0]) {
			clipV2(HoleSize);
			mount(Screw);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module mount(Screw) {
	difference() {
		translate([-10,-2,0]) color("cyan") cubeX([20,5,20],1); // base
		translate([0,4,13]) rotate([90,0,0]) color("gray") cylinder(h=10,d=Screw); // screw mounting hole
		// countersink
		translate([0,7.5,13]) rotate([90,0,0]) color("brown") cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module clip(HoleSize=10) {
	difference() {
		translate([0,HoleSize/2,0]) color("red") cylinder(h=7,d=HoleSize+5);				// outer hole
		translate([0,HoleSize/2,-1]) color("blue") cylinder(h=10,d=HoleSize);				// inner hole
		translate([0,HoleSize/2,7]) color("plum") fillet_r(1,HoleSize/2+3, 1,$fn);					// top outer
		translate([0,HoleSize/2,7]) color("plum") fillet_r(1,HoleSize/2,-1,$fn);					// top inner		
		translate([0,HoleSize/2,0]) rotate([0,180,0]) color("gold") fillet_r(1,HoleSize/2+3, 1,$fn);// lower outer
		translate([0,HoleSize/2,0]) rotate([0,180,0]) color("gold") fillet_r(1,HoleSize/2,-1,$fn);	// lower inner
		translate([-5,-10,-2]) color("black") cube([10,10,10]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module clipV2(HoleSize=10) {
	difference() {
		union() {
			translate([-10,-2,0]) color("blue") cubeX([5,9,7],1); // side
			translate([5,-2,0]) color("red") cubeX([5,9,7],1); // side
		}
		translate([-12,4,3.5]) rotate([0,90,0]) color("green") cylinder(h=25,d=3);
	}
}
//////////////// end of Zip Tie Mount.scad ///////////////////////////////////////////////
