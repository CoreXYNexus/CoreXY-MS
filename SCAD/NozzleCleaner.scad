//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NozzleCleaner.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 4/21/2022
// last update: 4/21/22
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use3mmInsert=1;
BrushWidth=15;
BrushLength=50;
BrushHeight=20;
Thickness=6;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BrushMount(1); // print on closed end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BrushMount(DoTab=1) {
	difference() {
		union() {
			color("cyan") cuboid([BrushWidth+10,BrushLength,Thickness],rounding=2);
			translate([BrushWidth/2+Thickness/2,0,BrushHeight/2-Thickness/2]) color("gray")
				cuboid([Thickness,BrushLength,BrushHeight],rounding=2);
			translate([-(BrushWidth/2+Thickness/2),0,BrushHeight/2-5/2-0.5]) color("lightgray")
				cuboid([Thickness,BrushLength,BrushHeight],rounding=2);
			translate([0,BrushLength/2-2,BrushHeight/2-Thickness/2]) color("purple")
				cuboid([BrushWidth+10,Thickness,BrushHeight],rounding=2);
		}
		translate([-BrushWidth/2,-BrushLength/4,BrushHeight/2]) rotate([0,90,0]) color("green")
			cyl(h=15,d=Yes3mmInsert(Use3mmInsert));
		translate([-BrushWidth/2,BrushLength/4,BrushHeight/2]) rotate([0,90,0]) color("khaki")
			cyl(h=15,d=Yes3mmInsert(Use3mmInsert));
	}
	if(DoTab) {
		translate([BrushWidth/2+3,-BrushLength/2+2,BrushHeight-(3+LayerThickness/2)])
			color("white") cyl(h=LayerThickness,d=10);
		translate([-(BrushWidth/2+3),-BrushLength/2+2,BrushHeight-(3+LayerThickness/2)])
			color("gold") cyl(h=LayerThickness,d=10);
	}
	Mounting();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Mounting(Screw=screw5,ScrewHD=screw5hd) {
	difference() {
		translate([BrushWidth/2+Thickness/2,0,-((BrushHeight)/2-Thickness/2)]) color("pink")
			cuboid([Thickness,BrushLength,BrushHeight],rounding=2);
		translate([BrushWidth/2,BrushLength/4,-BrushHeight/2]) rotate([0,90,0]) color("red") cyl(h=15,d=Screw);
		translate([BrushWidth/2-1,BrushLength/4,-BrushHeight/2]) rotate([0,90,0]) color("blue") cyl(h=5,d=ScrewHD);
		translate([BrushWidth/2,-BrushLength/4,-BrushHeight/2]) rotate([0,90,0]) color("blue") cyl(h=15,d=Screw);
		translate([BrushWidth/2-1,-BrushLength/4,-BrushHeight/2]) rotate([0,90,0]) color("red") cyl(h=5,d=ScrewHD);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////