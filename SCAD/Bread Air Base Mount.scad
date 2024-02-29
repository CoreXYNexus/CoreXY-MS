// bread air base mount
//////////////////////////////////////////////////
// C 6/11/22
// LU 6/11/22
///////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
$fn=100;
LayerHeight=0.3;
////////////////////////////////////////////////////////////////////

// fails to render
Base(1);

//////////////////////////////////////////////////////////////////////

module Base(MirrorVersion=0) {
	if(MirrorVersion) { // doesn't work
		%translate([-82/2,-135/2-2,-2]) import("Berd_Air_Floating_Base_v4OPENSCAD.stl");
		Base1();
	} else {
		translate([225,5,0]) color("lightblue") import("Berd_Air_Floating_Base_v4_mirrorOPENSCAD.stl");//,convexity=10);
		translate([88,139,0]) rotate([0,0,180]) upports();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base1() {
	difference() {
		union() {
			color("cyan") cuboid([82,135,4],rounding=2);
			translate([-82/2+7/2,0,39/2-2]) color("red") cuboid([7,135,39],rounding=2);
		}
		translate([-40,-70,-7]) Holes();
	}
	ExtrusionMountHoles();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountHoles(Screw=screw5) {
	color("blue") rotate([90,0,0]) cyl(h=20,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Holes() {
	translate([23.5,13,9]) color("red") cyl(d=10,h=10);
	translate([63.5,13,9]) color("purple") cyl(d=10,h=10);
	translate([23.5,49,9]) color("pink") cyl(d=10,h=10);
	translate([63.5,49,9]) color("green") cyl(d=10,h=10);
	translate([23.5,83,9]) color("gray") cyl(d=10,h=10);
	translate([63.5,83,9]) color("lightgray") cyl(d=10,h=10);
	translate([23.5,126,9]) color("white") cyl(d=10,h=10);
	translate([63.5,126,9]) color("khaki") cyl(d=10,h=10);

	translate([23.5,13,1.39]) color("red") cyl(d=15,h=10);
	translate([63.5,13,1.39]) color("purple") cyl(d=15,h=10);
	translate([23.5,49,1.39]) color("pink") cyl(d=15,h=10);
	translate([63.5,49,1.39]) color("green") cyl(d=15,h=10);
	translate([23.5,83,1.39]) color("gray") cyl(d=15,h=10);
	translate([63.5,83,1.39]) color("lightgray") cyl(d=15,h=10);
	translate([23.5,126,1.39]) color("white") cyl(d=15,h=10);
	translate([63.5,126,1.39]) color("khaki") cyl(d=15,h=10);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Supports() {
	translate([23.5,13,1.39]) color("red") cyl(d=15,h=LayerHeight);
	translate([63.5,13,1.39]) color("purple") cyl(d=15,h=LayerHeight);
	translate([23.5,49,1.39]) color("pink") cyl(d=15,h=LayerHeight);
	translate([63.5,49,1.39]) color("green") cyl(d=15,h=LayerHeight);
	translate([23.5,83,1.39]) color("gray") cyl(d=15,h=LayerHeight);
	translate([63.5,83,1.39]) color("lightgray") cyl(d=15,h=LayerHeight);
	translate([23.5,126,1.39]) color("white") cyl(d=15,h=LayerHeight);
	translate([63.5,126,1.39]) color("khaki") cyl(d=15,h=LayerHeight);
}

//////////////////////////////////////////////////////////////////////////////////