////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CornerBrace.scad
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/27/2020
// last update 11/30/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11/30/21	- Added corner brace, changed over to BOSL2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Thickness=6;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Corner(2);
//CornerV2(2);
CornerBrace(5);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerBrace(Qty=1,Type=0) {
	for(i = [0:Qty-1]) {
		translate([0,25*i,0]) difference() {
			union() {
				color("red") cuboid([80,20,Thickness],rounding=2,p1=[0,0]);
				color("cyan") cuboid([Thickness,20,81],rounding=2,p1=[0,0]);
				translate([0,0,78]) color("green") rotate([0,45,0]) cuboid([110,20,Thickness],rounding=2,p1=[0,0]);
				if(Type) {
					translate([40,0,0]) color("khaki") cuboid([Thickness,20,41],rounding=2,p1=[0,0]);
					translate([0,0,40]) color("lightblue") cuboid([41,20,Thickness],rounding=2,p1=[0,0]);
					SideSupport();
					translate([0,16,0]) SideSupport();
				} else {
					BraceSupport();
					translate([0,20-Thickness,0]) BraceSupport();
				}
			}
			ScrewMount4();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BraceSupport() {
	difference() {
		color("purple") hull() {
			cuboid([80,Thickness,Thickness],rounding=2,p1=[0,0]);
			translate([0,0,75]) cuboid([Thickness,Thickness,Thickness],rounding=2,p1=[0,0]);
		}
		translate([15,15,15]) color("white") rotate([90,0,0]) hull() {
			cylinder(h=Thickness*4,d=10);
			translate([35,0,0]) cylinder(h=Thickness*4,d=10);
			translate([0,35,0]) cylinder(h=Thickness*4,d=10);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Corner(Qty=1) {
	for(i = [0:Qty-1]) {
		translate([0,25*i,0]) difference() {
			union() {
				color("red") cuboid([20,20,Thickness],rounding=2,p1=[0,0]);
				color("cyan") cuboid([Thickness,20,20],rounding=2,p1=[0,0]);
				SideSupport();
				translate([0,16,0]) SideSupport();
			}
			ScrewMount(screw5);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerV2(Qty=1) {
	for(i = [0:Qty-1]) {
		translate([0,25*i,0]) difference() {
			color("cyan") hull() {
				cuboid([20,20,Thickness],rounding=2,p1=[0,0]);
				translate([0,0,16]) cuboid([Thickness,20,5],rounding=2,p1=[0,0]);
			}
			ScrewMount(screw5);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SideSupport() {
	difference() {
		translate([-17.5,0,1.5]) color("blue") rotate([0,45,0]) cuboid([27,Thickness,27],rounding=2,p1=[0,0]);
		translate([-18,-1,-38]) color("gray") cube([40,6,40]);
		translate([-38,-1,-5]) color("lightgray") cube([40,6,40]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewMount(Screw=screw5) {
	translate([10,10,-Thickness-0.5]) color("green") cylinder(h=10,d=Screw);
	translate([10,10,Thickness-0.5]) color("pink") cylinder(h=15,d=screw5hd);
	translate([-Thickness+1,10,10]) rotate([0,90,0]) color("pink") cylinder(h=10,d=Screw);
	translate([Thickness+1,10,10]) rotate([0,90,0]) color("green") cylinder(h=15,d=screw5hd);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewMount4() {
	translate([17,10,-Thickness-0.5]) color("green") cylinder(h=90,d=screw5);
	translate([17,10,Thickness-0.5]) color("pink") cylinder(h=15,d=screw5hd);
	translate([-Thickness+1,10,17]) rotate([0,90,0]) color("pink") cylinder(h=90,d=screw5);
	translate([Thickness-0.5,10,17]) rotate([0,90,0]) color("green") cylinder(h=15,d=screw5hd);
	translate([65,10,-Thickness-0.5]) color("blue") cylinder(h=10,d=screw5);
	translate([65,10,Thickness-0.5]) color("purple") cylinder(h=25,d=screw5hd);
	translate([-Thickness+1,10,65]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw5);
	translate([Thickness-0.5,10,65]) rotate([0,90,0]) color("gray") cylinder(h=25,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////