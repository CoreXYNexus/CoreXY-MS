///////////////////////////////////////////
// fanmount.scad
///////////////////////////////////////////
// C:422/21
// L: 4/22/21
///////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <brassinserts.scad>
include <screwsizes.scad>
/////////////////////////////////////////////////////////
$fn=100;
LargeInsert=0;
Use3mmInsert=1;
/////////////////////////////////////////////////////////////

FanMount();

///////////////////////////////////////////////////////////

module FanMount() {
	%translate([130,12,-5]) import("Air_Pump_Anti-Shock_Mount_.stl");
	difference() {
		translate([-20,0,50]) color("red") cuboid([50,5,80],rounding=2);
		translate([-2.6,5,17]) color("cyan") rotate([90,0,0]) cylinder(h=10,d=screw2p5+0.8);
		translate([-36.6,5,17]) color("blue") rotate([90,0,0]) cylinder(h=10,d=screw2p5+0.8);
		translate([-2.6,6,17]) color("cyan") rotate([90,0,0]) cylinder(h=5,d=screw3hd);
		translate([-36.6,6,17]) color("blue") rotate([90,0,0]) cylinder(h=5,d=screw3hd);
		translate([-36,5,50]) fanholes();
	}
}

/////////////////////////////////////////////////////////////////////

module fanholes() {
	rotate([90,0,0]) color("green") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([32,0,0]) rotate([90,0,0]) color("purple") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([32,0,32]) rotate([90,0,0]) color("white") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([0,0,32]) rotate([90,0,0]) color("black") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([16,0,15.5]) color("pink") rotate([90,0,0]) cylinder(h=10,d=38);
}

/////////////////////////////////////////////////////////////////////////////////