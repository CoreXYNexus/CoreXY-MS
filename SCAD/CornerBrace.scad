////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CornerBrace.scad
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/27/2020
// last update 1/9/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11/30/21	- Added corner brace, changed over to BOSL2
// 1/9/22	- Changed to solid
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Thickness=6;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CornerBrace(1);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerBrace(Qty=1) {
	for(i = [0:Qty-1]) {
		translate([0,25*i,0]) difference() {
			color("purple") hull() {
				cuboid([80,20,Thickness],rounding=2,p1=[0,0]);
				translate([0,0,75]) cuboid([Thickness,20,Thickness],rounding=2,p1=[0,0]);
			}
			BraceSupportv2();
			ScrewMount();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BraceSupport() {
	translate([13,10,13]) color("white") rotate([90,0,0]) hull() {
		cyl(h=Thickness*4,d=10);
		translate([40,0,0]) cyl(h=Thickness*4,d=10);
		translate([0,40,0]) cyl(h=Thickness*4,d=10);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BraceSupportv2() {
	translate([13,10,13]) rotate([90,0,0]) {
		color("cyan") cyl(h=20.4,d=10,rounding=-2);
		translate([40,0,0]) color("blue") cyl(h=20.2,d=10,rounding=-2);
		translate([0,40,0]) color("khaki") cyl(h=20.2,d=10,rounding=-2);
		translate([20,1,0]) color("pink") cuboid([36,10,20.2],rounding=-2);
		translate([1,20,0]) color("plum") cuboid([10,36,20.2],rounding=-2);
		translate([19,19.5,0]) rotate([0,0,44.5]) color("white") cuboid([10,50,20.2],rounding=-2);
		translate([15,15,0]) rotate([90,0,0]) difference() {
			translate([0,0,0]) color("gray") cuboid([20,25,22]);
			translate([10,0,-10]) rotate([0,45,0]) color("lightgray") cuboid([25,30,25]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewMount() {
	translate([18,10,-Thickness-0.5]) color("green") cylinder(h=90,d=screw5);
	translate([18,10,Thickness-0.5]) color("pink") cylinder(h=25,d=screw5hd);
	translate([-Thickness+1,10,18]) rotate([0,90,0]) color("pink") cylinder(h=90,d=screw5);
	translate([Thickness-0.5,10,18]) rotate([0,90,0]) color("green") cylinder(h=25,d=screw5hd);
	translate([65,10,-Thickness-0.5]) color("blue") cylinder(h=90,d=screw5);
	translate([65,10,Thickness-0.5]) color("purple") cylinder(h=25,d=screw5hd);
	translate([-Thickness+1,10,65]) rotate([0,90,0]) color("red") cylinder(h=90,d=screw5);
	translate([Thickness-0.5,10,65]) rotate([0,90,0]) color("gray") cylinder(h=25,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////