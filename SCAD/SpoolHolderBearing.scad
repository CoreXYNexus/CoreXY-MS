//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SpoolHolderBearing.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C: 4/18/2021
// L:4/20/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
clearance = 0.3;
Diameter608 = 22+clearance;		// outside diameter of a 608
Height608 = 7; 					// thickness of a 608
SpoolHoleLargeDiameter=80;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////

SpoolHolderBearing(2,60);

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolHolderBearing(Qty=1,BigEndDiameter=SpoolHoleLargeDiameter) {
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
