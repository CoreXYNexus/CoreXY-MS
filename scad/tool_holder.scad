///////////////////////////////////////////////////////////////////////////
// tool holder
// created: 1/20/2014
// last update 11/29/20
///////////////////////////////////////////////////////////////////////////
// 1/25/14 - shortend base width
// 4/14/14 - added a double version
// 5/20/16 - made somewhat parametric & removed unnecessary lines
// 11/29/20	- changed to use screwsizes.scad
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////
inner = 9;		// hole size needed for tool
thickness = 5;
outer = inner*1.5;
adjust_doubleW = 1;	// move the double holders closer/farther together
adjust_M = 2.5;		// move the holder closer/farther from mount
//////////////////////////////////////////////////////////////////////////
$fn=75;  // cylinder quality

single();
translate([20+thickness,0,0]) double();

///////////////////////////////////////////////////////////////////////////////

module single()
{
	rotate([0,90,0]) {
		difference() {
			color("cyan") cube([25,12,thickness],true); // mount
			translate([0,0,-thickness]) color("red") cylinder(h=thickness+4, r = screw5/2); // mount screw hole
			translate([0,0,0.75]) color("blue") cylinder(h=27, d=screw5hd); // countersink
		}
		difference() {
			translate([-12.5,0,thickness+adjust_M]) rotate([0,90,0]) color("gray") cylinder(h=25, d=outer);
			translate([-13,0,thickness+adjust_M]) rotate([0,90,0]) color("green") cylinder(h=28, d=inner);
			translate([0,0,-1]) color("plum") cylinder(h=outer+5, d=screw5hd);	// hole for screw access
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

module double()
{
	rotate([0,90,0]) {
		difference() {
			color("blue") cube([25,22,thickness],true);	// mount
			translate([0,0,-thickness]) color("cyan") cylinder(h=thickness+4, d=screw5); // mount screw hole
			translate([0,0,0.75]) color("green") cylinder(h=27, d=screw5hd);	// countersink
		}
		difference() {
			translate([-12.5,-(thickness+adjust_doubleW),thickness+adjust_M]) rotate([0,90,0]) color("pink") cylinder(h=25,d=outer);
			translate([-13,-(thickness+adjust_doubleW),thickness+adjust_M]) rotate([0,90,0]) color("red") cylinder(h=28, d=inner);
			translate([0,0,-1]) color("black") cylinder(h=outer+5, d=screw5hd);
		}
		difference() {
			translate([-12.5,thickness+adjust_doubleW,thickness+adjust_M]) rotate([0,90,0]) color("gray") cylinder(h=25, d=outer);
			translate([-13,thickness+adjust_doubleW,thickness+adjust_M]) rotate([0,90,0]) color("plum") cylinder(h=28, d=inner);
			translate([0,0,-1]) color("gold") cylinder(h=outer+5, d=screw5hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////