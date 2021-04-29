///////////////////////////////////////////////////
// mount.scad - 2020/2040 attachment base
//////////////////////////////////////////////////////
// C:4/4/21
// U:4/4/21
/////////////////////////////////////////////////////
include <BOSL2/std.scad>
//////////////////////////////////////////////////////
$fn=100;
////////////////////////////////////////////////////

difference() {
	union() {
		import("Air_Pump_Anti-Shock_Mount.3mf");
		translate([0,-31,-9.31]) color("red") cuboid([79,23,5],rounding=2);
	}
	translate([-50,-30,-6]) color("cyan") cube([100,60,20]);
	translate([25,-30,-15]) color("blue") cylinder(h=10,d=5.8,$fn=100);
	translate([-25,-30,-15]) color("blue") cylinder(h=10,d=5.8,$fn=100);
}
translate([-4,-15,-11.8]) color("gray") cylinder(h=5.8,d=10,$fn=100);
translate([-4,15,-11.8]) color("gray") cylinder(h=5.8,d=10,$fn=100);
