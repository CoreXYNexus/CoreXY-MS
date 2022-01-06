///////////////////////////////////////////////////////////////////////////
// tool holder
// created: 1/20/2014
// last update 1/6/22
///////////////////////////////////////////////////////////////////////////
// 1/25/14	- shortend base width
// 4/14/14	- added a double version
// 5/20/16	- made somewhat parametric & removed unnecessary lines
// 11/29/20	- changed to use screwsizes.scad
// 1/6/22	- BOSL2
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
//////////////////////////////////////////////////////////////////////////
inner = 9;		// hole size needed for tool
thickness = 5;
outer = inner*1.5;
adjust_doubleW = 1;	// move the double holders closer/farther together
adjust_M = 2.5;		// move the holder closer/farther from mount
//////////////////////////////////////////////////////////////////////////
$fn=75;  // cylinder quality

single();
translate([20+thickness,0,0])
	double();

///////////////////////////////////////////////////////////////////////////////

module single()
{
	rotate([0,90,0]) {
		difference() {
			color("cyan") cuboid([25,12,thickness],rounding=1); // mount
			color("red") cyl(h=thickness+4,d=screw5); // mount screw hole
			translate([0,0,13.75]) color("blue") cyl(h=27,d=screw5hd); // countersink
		}
		difference() {
			translate([0,0,thickness+adjust_M]) rotate([0,90,0]) color("gray") cyl(h=25, d=outer,rounding=1);
			translate([0,0,thickness+adjust_M]) rotate([0,90,0]) color("green") cyl(h=28, d=inner);
			translate([0,0,10]) color("plum") cyl(h=outer+5, d=screw5hd);	// hole for screw access
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

module double()
{
	rotate([0,90,0]) {
		difference() {
			color("blue") cuboid([25,22,thickness],rounding=1);	// mount
			translate([0,0,0]) color("cyan") cyl(h=thickness+4, d=screw5); // mount screw hole
			translate([0,0,13.75]) color("green") cyl(h=27, d=screw5hd);	// countersink
		}
		difference() {
			translate([0,-(thickness+adjust_doubleW),thickness+adjust_M]) rotate([0,90,0]) color("pink")
				cyl(h=25,d=outer,rounding=1);
			translate([0,-(thickness+adjust_doubleW),thickness+adjust_M]) rotate([0,90,0]) color("red")
				cyl(h=28, d=inner);
			translate([0,0,0]) color("white") cyl(h=outer+25, d=screw5hd);
		}
		difference() {
			translate([0,thickness+adjust_doubleW,thickness+adjust_M]) rotate([0,90,0]) color("gray")
				cyl(h=25, d=outer,rounding=1);
			translate([0,thickness+adjust_doubleW,thickness+adjust_M]) rotate([0,90,0]) color("plum")
				cyl(h=28, d=inner);
			translate([0,0,0]) color("gold") cyl(h=outer+25, d=screw5hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////