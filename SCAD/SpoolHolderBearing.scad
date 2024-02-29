//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SpoolHolderBearing.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C: 4/18/2021
// L:6/19/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2/1/22	- Change to a hulled ends
// 6/19/22	- Added a rounded version
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
clearance = 0.3;
Diameter608 = 22+clearance;		// outside diameter of a 608
Height608 = 7; 					// thickness of a 608
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//SpoolHolderBearing(2);
SpoolHolderBearingV2(2);

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolHolderBearing(Qty=1,BigEndDiameter=80) {
	%translate([0,0,-Height608*2-3]) cyl(h=1,d=BigEndDiameter);
	for(x=[0:Qty-1]) {
		translate([x*90,0]) {
			difference() {
				union() {
					color("cyan") cyl(h=Height608*2+20,d=Diameter608+8.7,rounding=0);
					color("red") hull() {
						translate([BigEndDiameter/2-3,0,-(Height608*2+20)/2+2.5]) cuboid([5,20,5],rounding=2);
						translate([13,0,0]) cuboid([5,20,Height608*2+20],rounding=2);
					}
					rotate([0,0,180]) color("purple") hull() {
						translate([BigEndDiameter/2-3,0,-(Height608*2+20)/2+2.5]) cuboid([5,20,5],rounding=2);
						translate([13,0,0]) cuboid([5,20,Height608*2+20],rounding=2);
					}
					color("green") hull() {
						translate([0,BigEndDiameter/2-3,-(Height608*2+20)/2+2.5]) cuboid([20,5,5],rounding=2);
						translate([0,13,0]) cuboid([20,5,Height608*2+20],rounding=2);
					}
					rotate([0,0,180]) color("gold") hull() {
						translate([0,BigEndDiameter/2-3,-(Height608*2+20)/2+2.5]) cuboid([20,5,5],rounding=2);
						translate([0,13,0]) cuboid([20,5,Height608*2+20],rounding=2);
					}
				}
				BearingHole();
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolHolderBearingV2(Qty=1,BigEndDiameter=80) {
	//%translate([0,0,-Height608*2-3]) cyl(h=1,d=BigEndDiameter);
	for(x=[0:Qty-1]) {
		translate([x*90,0]) {
			difference() {
				union() {
					color("cyan") cyl(h=Height608*2+20,d2=Diameter608+8.7,d1=Diameter608+15,rounding=2);
					difference() {
						union() {
							translate([18,0,-4]) rotate([0,-37,0]) cyl(h=Height608*2+35,d=20);
							translate([0,18,-4]) rotate([0,-37,90]) cyl(h=Height608*2+35,d=20);
							translate([-18,0,-4]) rotate([0,-37,180]) cyl(h=Height608*2+35,d=20);
							translate([0,-18,-4]) rotate([0,-37,-90]) cyl(h=Height608*2+35,d=20);
						}
						translate([0,0,20.7]) color("pink") cyl(h=10,d=Diameter608+8.7);
						translate([0,0,-27]) color("pink") cyl(h=20,d=BigEndDiameter+8.7);
					}
				}
				BearingHole();
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole() {
	translate([0,0,15-Height608]) color("blue") cylinder(h=Height608+5,d=Diameter608);
	translate([0,0,4-Height608]) color("purple") cylinder(h=Height608+5,r1=(8+clearance)/2,r2=Diameter608/2+0.7);
	translate([0,0,-15-Height608]) color("red") cylinder(h=Height608+5,d=Diameter608);
	translate([0,0,-25-Height608]) color("green") cylinder(h=Height608+60,d=8+clearance);
	translate([0,0,-3.1-Height608]) color("white") cylinder(h=Height608+5,r1=Diameter608/2+0.7,r2=(8+clearance)/2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolHolderBearingOLD(Qty=1,BigEndDiameter=80) {
	for(x=[0:Qty-1]) {
		translate([x*120,0]) difference() {
			color("cyan")
				cyl(l=Height608*2+20,r1=BigEndDiameter,r2=Diameter608-5,rounding1=3,rounding2=3,$fa=1,$fs=1);
			translate([0,0,15-Height608]) color("blue") cylinder(h=Height608+5,d=Diameter608);
			translate([0,0,4-Height608]) color("purple") cylinder(h=Height608+5,r1=(8+clearance)/2,r2=Diameter608/2+0.7);
			translate([0,0,-15-Height608]) color("red") cylinder(h=Height608+5,d=Diameter608);
			translate([0,0,-25-Height608]) color("green") cylinder(h=Height608+60,d=8+clearance);
			translate([0,0,-3.1-Height608]) color("white") cylinder(h=Height608+5,r1=Diameter608/2+0.7,r2=(8+clearance)/2);
			translate([35,35,-5]) color("red") cuboid([50,50,50],rounding=3);
			translate([-35,-35,-5]) color("blue") cuboid([50,50,50],rounding=3);
			translate([35,-35,-5]) color("purple") cuboid([50,50,50],rounding=3);
			translate([-35,35,-5]) color("plum") cuboid([50,50,50],rounding=3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
