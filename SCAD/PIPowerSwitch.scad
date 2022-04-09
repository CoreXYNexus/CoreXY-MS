////////////////////////////////////////////////////////////////////////////////////////////////
// PI Power Switch ' hold two momemtary siwthed to power off the PIs
///////////////////////////////////////////////////////////////////////////////////////////////
// Created: 4/3/2022
// Last Update: 4/3/22
///////////////////////////////////////////////////////////////////////////////////////////////
// Install in termial or PuTTY:
// git clone https://github.com/Howchoo/pi-power-button.git
// ./pi-power-button/script/install
//
// GPIO physical pins: 5 & 6
//////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Clearance=0.7;
SWDiameter=12 + Clearance;
Thickness=5;
LayerThickness=0.3;
Font="Liberation Sans";
/////////////////////////////////////////////////////////////////////////////////////////////////////

Switch(2);

////////////////////////////////////////////////////////////////////////////////////////////////////

module Switch(Qty=1) {
	Base(Qty);
	translate([18,0,0]) Mount(Qty);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module Base(Qty=1) {
	if(Qty==1) {
		difference() {
			color("cyan") cuboid([SWDiameter*2,SWDiameter*3,Thickness],rounding=2);
			color("red") cyl(h=Thickness*2,d=SWDiameter);
		}
		translate([-2,10,1]) printchar("PI",2,4,"purple");
		translate([-8,-14,1]) printchar("SHUTDOWN",2,4,"purple");
	} else if(Qty==2) {
		difference() {
			color("cyan") cuboid([SWDiameter*2,SWDiameter*4.5,Thickness],rounding=2);
			translate([0,10,0]) color("red") cyl(h=Thickness*2,d=SWDiameter);
			translate([0,-10,0]) color("green") cyl(h=Thickness*2,d=SWDiameter);
		}
		translate([-2,20,1]) printchar("PI",2,4,"purple");
		translate([-8,-23,1]) printchar("SHUTDOWN",2,4,"purple");
	} else {
		echo("Number of switches is one or two");
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount(Qty=1,Screw=screw5) {
	if(Qty==1) {
		difference() {
			color("blue") cuboid([20,SWDiameter*3,Thickness],rounding=2);
			translate([0,0,0]) color("red") cyl(h=Thickness*2,d=Screw);
			translate([0,0,4]) color("green") cyl(h=Thickness,d=screw5hd);
		}
	} else if(Qty==2) {
		difference() {
			color("blue") cuboid([20,SWDiameter*4.5,Thickness],rounding=2);
			translate([0,10,0]) color("red") cyl(h=Thickness*2,d=Screw);
			translate([0,-10,0]) color("green") cyl(h=Thickness*2,d=Screw);
			translate([0,10,4]) color("green") cyl(h=Thickness,d=screw5hd);
			translate([0,-10,4]) color("red") cyl(h=Thickness,d=screw5hd);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=2,Color="lightgray") { // print text
	color(Color) linear_extrude(height=Height) text(String,font=Font,size=Size);
}

///////////////////////////////////////////////////////////////////////////////////////////////