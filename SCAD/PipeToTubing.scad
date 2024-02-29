///////////////////////////////////////////////////////////////////////////////////////////////////
// PipeToTubing.scad -- mount a silencer on the brad air pump inlet
//////////////////////////////////////////////////////////////////////////////////////////////////
// C:4/18/21
// L:6/11/22
/////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/5/22	- Added 90 degree 6mm elbow
// 6/11/22	- Vars for hose and inner diameters
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
LayerThickness=0.3;
HoseDiameter=6;
InnerDiameter=4.5;
//////////////////////////////////////////////////////////////////////////////////////////////////////

PipeToTubing(3/8,HoseDiameter,0); // 3/8" pipe thread
translate([25,-20,-10])
	HoseUTurn(HoseDiameter);
//Hose90(HoseDiameter);

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module PipeToTubing(Size=3/8,Hose=HoseDiameter,ShowCrossSection=0) {
	difference() {
		NutBase(Hose);
		if(ShowCrossSection) translate([-12,0,-12]) color("gray") cube([25,25,25]);   // to see cross section
		translate([0,0,-3]) color("cyan") npt_threaded_rod(size=Size,$fn=72);
	}
	translate([0,0,4.6276]) color("white") cylinder(h=LayerThickness,d=18);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NutBase(Hose=HoseDiameter) {
	difference() {
		union() {
			translate([0,0,0]) color("blue") cyl(h=20,d=25,chamfer=2,$fn=6);
			color("plum") cylinder(h=25,d=Hose,$fn=100);
			translate([0,0,-9.85]) color("gray") cyl(h=LayerThickness,d=35);
		}
		translate([0,0,-11]) cylinder(h=10,r1=10,r2=3,$fn=100); // bevel thread start
		translate([0,0,0]) color("red") cylinder(h=30,d=InnerDiameter,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HoseUTurn(Hose=HoseDiameter) {
	difference() {
		union() {
			color("cyan") cylinder(h=15,d=Hose);
			color("gray") cylinder(h=LayerThickness,d=15);
		}
		translate([0,0,-5]) color("red") cylinder(h=20,d=InnerDiameter);
		translate([-5,3,8]) color("gray") rotate([45,0,0]) cube([10,10,10]);
	}
	translate([0,43,0]) difference() {
		union() {
			color("blue") cylinder(h=15,d=Hose);
			color("lightgray") cylinder(h=LayerThickness,d=15);
		}
		translate([0,0,-5]) color("gray") cylinder(h=20,d=InnerDiameter);
		translate([-5,-3,8]) color("red") rotate([45,0,0]) cube([10,10,10]);
	}
	translate([0,0,11]) rotate([90,0,0]) difference() {
		translate([0,0,-50])color("green") cylinder(h=55,d=Hose);
		translate([0,0,-55]) color("pink") cylinder(h=65,d=InnerDiameter);
		translate([-5,-3,-3]) color("gray") rotate([45,0,0]) cube([10,15,10]);
		translate([-5,-10.15,-47]) color("lightgray") rotate([-45,0,0]) cube([10,15,10]);
	}
	translate([-(HoseDiameter-2)/2,20,0]) color("red") cube([HoseDiameter-2,LayerThickness*2,9]); // center support
	translate([-(HoseDiameter-2)/2+2,20,0.15]) color("lightblue") cyl(h=LayerThickness,d=10); // center support
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Hose6mm90(Hose=HoseDiameter) {
	rotate([0,90,0]) {
		difference() {
			color("cyan") cylinder(h=15,d=Hose);
			translate([0,0,-5]) color("red") cylinder(h=20,d=InnerDiameter);
			translate([-5,3,8]) color("gray") rotate([45,0,0]) cube([10,10,10]);
		}
		translate([0,0,11]) rotate([90,0,0]) difference() {
			translate([0,0,-50])color("green") cylinder(h=55,d=Hose);
			translate([0,0,-55]) color("pink") cylinder(h=65,d=InnerDiameter);
			translate([-5,-3,-3]) color("gray") rotate([45,0,0]) cube([10,15,10]);
			translate([-20,-10,-65]) color("white") cube([50,50,50]);
		}
	}
	translate([8,4,-2.85]) color("gray") cyl(h=LayerThickness,d=35);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
