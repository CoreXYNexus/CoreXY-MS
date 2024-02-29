/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// bread air base mount
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 6/12/22
// Last Update 5/6/23
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/12/22	- Copy of Berd_Air_Floating_Base_v4.stl and Berd_Air_Floating_Base_v4_mirror.stl
//			  Created due to importing the stls don't render
// 5/6/23	- Added flat base
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <screwsizes.scad> // uses this from the scad/inc directory, copy to documents/openscad/libraries
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
LayerThickness=0.3;
TabDiameter=25;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Base(0,0);
FlatBase();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base(NotMirrorVersion=0,Show=0) {
	if(NotMirrorVersion) {
		if(Show) %translate([-82/2,-135/2-2,-2]) import("Berd_Air_Floating_Base_v4.stl");
		Base1();
	} else {
		if(Show) %translate([225,5,0]) import("Berd_Air_Floating_Base_v4_mirror.stl");
		Base2();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base1() {
	difference() {
		union() {
			color("cyan") cuboid([82,135,4],rounding=2);
			translate([-82/2+7/2,0,20/2-2]) color("red") cuboid([7,135,20],rounding=3);
			translate([-82/2+3.5,-32,25]) color("purple") cuboid([7,25,25],rounding=3);
			translate([-82/2+3.5,32,25]) color("green") cuboid([7,25,25],rounding=3);
			Tabs();
		}
		translate([-40,-70,-7]) Holes();
		ExtrusionMountHoles();
		translate([0,64,0]) ExtrusionMountHoles();
		translate([3,-40,0]) color("khaki") cyl(h=4.2,d=30,rounding=-2);
		translate([3,-2.5,0]) color("blue") cyl(h=4.2,d=30,rounding=-2);
		translate([3,35,0]) color("gray") cyl(h=4.2,d=30,rounding=-2);
	}
	translate([-82/2,-135/2-2,-2]) Supports();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FlatBase(Screw=screw5,ScrewHD=screw5hd) {
	difference() {
		union() {
			translate([-8,0,0]) color("cyan") cuboid([92,135,4],rounding=2);
			TabsFlat();
		}
		translate([-40,-70,-7]) HolesFlat();
		color("blue") translate([-44,55,0]) cyl(h=20,d=Screw);
		color("pink") translate([-44,-50,0])  cyl(h=20,d=Screw);
		//color("pink") translate([-44,55,0]) cyl(h=5,d=ScrewHD);
		//color("blue") translate([-44,-50,0]) cyl(h=5,d=ScrewHD);
		translate([3,-40,0]) color("khaki") cyl(h=4.2,d=30,rounding=-2);
		translate([3,-2.5,0]) color("blue") cyl(h=4.2,d=30,rounding=-2);
		translate([3,35,0]) color("gray") cyl(h=4.2,d=30,rounding=-2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Tabs(DoTabs=1,Diameter=TabDiameter) {
	if(DoTabs) {
		translate([39,66,-1.85048]) color("lightgray") cyl(h=LayerThickness,d=Diameter);
		translate([-39,66,-1.85048]) color("gray") cyl(h=LayerThickness,d=Diameter);
		translate([39,-66,-1.85048]) color("green") cyl(h=LayerThickness,d=Diameter);
		translate([-39,-66,-1.85048]) color("khaki") cyl(h=LayerThickness,d=Diameter);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TabsFlat(DoTabs=1,Diameter=TabDiameter) {
	if(DoTabs) {
		translate([30,66,-1.85048]) color("lightgray") cyl(h=LayerThickness,d=Diameter);
		translate([-50,66,-1.85048]) color("gray") cyl(h=LayerThickness,d=Diameter);
		translate([30,-66,-1.85048]) color("green") cyl(h=LayerThickness,d=Diameter);
		translate([-50,-66,-1.85048]) color("khaki") cyl(h=LayerThickness,d=Diameter);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base2() {
	rotate([0,180,180]) mirror([0,0,1]) Base1();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountHoles(Screw=screw5,ScrewHD=screw5hd) {
	color("blue") translate([-40,-32,9]) rotate([0,90,0]) cyl(h=20,d=Screw);
	color("pink") translate([-40,-32,29]) rotate([0,90,0]) cyl(h=20,d=Screw);
	color("pink") translate([-32,-32,9]) rotate([0,90,0]) cyl(h=5,d=ScrewHD);
	color("blue") translate([-32,-32,29]) rotate([0,90,0]) cyl(h=5,d=ScrewHD);
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HolesFlat() {
	translate([23.5,13,9]) color("red") cyl(d=10,h=10);
	translate([63.5,13,9]) color("purple") cyl(d=10,h=10);
	translate([23.5,49,9]) color("pink") cyl(d=10,h=10);
	translate([63.5,49,9]) color("green") cyl(d=10,h=10);
	translate([23.5,83,9]) color("gray") cyl(d=10,h=10);
	translate([63.5,83,9]) color("lightgray") cyl(d=11,h=10);
	translate([23.5,126,9]) color("white") cyl(d=10,h=10);
	translate([63.5,126,9]) color("khaki") cyl(d=10,h=10);

	translate([23.5,13,11]) color("red") cyl(d=15.5,h=10);
	translate([63.5,13,11]) color("purple") cyl(d=15.5,h=10);
	translate([23.5,49,11]) color("pink") cyl(d=15.5,h=10);
	translate([63.5,49,11]) color("green") cyl(d=15.5,h=10);
	translate([23.5,83,11]) color("gray") cyl(d=15.5,h=10);
	translate([63.5,83,11]) color("lightgray") cyl(d=15.5,h=10);
	translate([23.5,126,11]) color("white") cyl(d=15.5,h=10);
	translate([63.5,126,11]) color("khaki") cyl(d=15.5,h=10);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Supports() {
	translate([23.5,13,1.39]) color("red") cyl(d=15,h=LayerThickness);
	translate([63.5,13,1.39]) color("purple") cyl(d=15,h=LayerThickness);
	translate([23.5,49,1.39]) color("pink") cyl(d=15,h=LayerThickness);
	translate([63.5,49,1.39]) color("green") cyl(d=15,h=LayerThickness);
	translate([23.5,83,1.39]) color("gray") cyl(d=15,h=LayerThickness);
	translate([63.5,83,1.39]) color("lightgray") cyl(d=15,h=LayerThickness);
	translate([23.5,126,1.39]) color("white") cyl(d=15,h=LayerThickness);
	translate([63.5,126,1.39]) color("khaki") cyl(d=15,h=LayerThickness);
}

//////////////////////////////////////////////////////////////////////////////////