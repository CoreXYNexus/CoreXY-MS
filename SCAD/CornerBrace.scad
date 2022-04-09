////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CornerBrace.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/27/2020
// last update 3/31/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11/30/21	- Added corner brace, changed over to BOSL2
// 1/9/22	- Changed to solid
// 3/31/22	- CornerBrace2() cahnaged rounding to 3, Thickness is now an args for the modules it's used in
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <BOSL2/rounding.scad>
include <inc/screwsizes.scad>
$fn=100;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//CornerBrace(1,4);
CornerBrace2(1,6);
//Corner();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Corner() {
	difference() {
		color("cyan") hull() {
			cuboid([20,20,5],rounding=2);
			translate([0,7.5,15]) cuboid([20,5,5],rounding=2);
		}
		translate([0,0,0]) color("red") cyl(h=50,d=screw5);
		translate([0,0,9]) color("blue") cyl(h=20,d=screw5hd);
		translate([0,0,8]) color("blue") rotate([90,0,0]) cyl(h=50,d=screw5);
		translate([0,-1.5,8]) color("red") rotate([90,0,0]) cyl(h=20,d=screw5hd);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerBrace2(Qty=1,Thickness=6) {
	for(x=[0:Qty-1]) {
		translate([0,x*25,0]) difference() {
			color("red") hull() {
				cuboid([80,20,Thickness],rounding=3);
				translate([-40,0,75]) cuboid([Thickness,20,Thickness],rounding=2);
			}
			translate([5,20.1,5.5]) BraceHollow2();
			translate([-40,-11,0]) ScrewMount(Thickness);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BraceHollow2() {
	translate([-22.5,-20.1,15.5]) color("cyan") rotate([90,0,0]) cyl(h=20.2,d=35,rounding=-3);
	translate([6,-20.1,6]) color("blue") rotate([90,0,0]) cyl(h=20.1,d=15,rounding=-3);
	translate([-33,-20.1,43.5]) color("green") rotate([90,0,0]) cyl(h=20.1,d=15,rounding=-3);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerBrace(Qty=1,Thickness=4) {
	for(i = [0:Qty-1]) {
		translate([0,25*i,0]) difference() {
			color("red") hull() {
				cuboid([80,20,Thickness],rounding=2,p1=[0,0]);
				translate([0,0,75]) cuboid([Thickness,20,Thickness],rounding=2,p1=[0,0]);
			}
			translate([5,20.1,5.5]) BraceHollow();
			ScrewMount(Thickness);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BraceHollow() {
	$fa=1;$fs=0.3;
	triangle = [[0,0],[0,58],[58,0]];
	rotate([90,0,0]) offset_sweep(triangle, height=20.2, bottom = os_circle(r=-2),steps=20,top = os_circle(r=-2));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewMount(Thickness) {
	translate([12,10,-Thickness]) color("green") cylinder(h=100,d=screw5);
	translate([12,10,25/2+1]) color("pink") cyl(h=25,d=screw5hd,rounding2=2);
	translate([-Thickness+1,10,12]) rotate([0,90,0]) color("pink") cylinder(h=100,d=screw5);
	translate([25/2+1.5,10,12]) rotate([0,90,0]) color("green") cyl(h=25,d=screw5hd,rounding2=2);
	translate([65,10,-Thickness]) color("blue") cylinder(h=100,d=screw5);
	translate([65,10,25/2]) color("purple") cyl(h=25,d=screw5hd);
	translate([-Thickness+1,10,65]) rotate([0,90,0]) color("red") cylinder(h=100,d=screw5);
	translate([Thickness,10,65]) rotate([0,90,0]) color("gray") cylinder(h=25,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////