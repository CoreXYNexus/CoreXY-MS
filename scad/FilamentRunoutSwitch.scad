///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FilamentRunoutSwitch.scad - basic filament runout sensor
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 1/6/2017
// last modified: 1/11/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/7/16	- Made smaller & added squares to hold ptfe in place
// 10/10/20	- Changed to 1.75mm filament tubing, now uses brass inserts
// 1/5/22	- BOSL2
// 1/22/22	- Changed micro switch mounting pins to M2 flat head screws
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Uses black microswitch
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  **** NOT TESTED
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/brassinserts.scad>
include <bosl2/std.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
switch_w = 20.5;	// microswitch size
switch_l = 21;
switch_t = 6.5;
switch_h = 2;
switch_ho = 9.5;
switch_off = 21;
switch_on = 3;
ptfe_od = 4.0;  // 6.5 for 3mm filament
Use3mmInsert=1;
LargeInsert=1;
LayerThickness=0.3;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

gizmo(1);
//translate([51,0,switch_t+14.5]) rotate([0,180,0]) gizmo_lid(); // test fit
translate([60,0,0]) // for printing
	gizmo_lid(1);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module gizmo(DoTab=0) {
	union() {
		difference() {
			translate([0,1.5*switch_w,0]) color("blue") cuboid([switch_l+30,switch_w,switch_t+8],rounding=2,p1=[0,0]);
			translate([-2,-2,switch_t+4]) color("salmon") cuboid([switch_l+35,switch_w+45,switch_t+8],rounding=1,p1=[0,0]);
			screw_assemble(screw3);
			filament_slot();
			switch_hole(0);
		}
		difference() {
			translate([switch_l/2,0,0]) color("cyan") cuboid([switch_l+9,switch_w+15,switch_t+8],rounding=2,p1=[0,0]);
			translate([-2,-2,switch_t+4]) color("salmon") cuboid([switch_l+35,switch_w+45,switch_t+8],rounding=1,p1=[0,0]);
			screw_assemble(screw3);
			switch_hole(0);
			wire_hole();
			switch_mount(1);
		}
		ptfe_stops();
		translate([45,50.25,5.8]) rotate([-90,180,0]) color("white") printchar("----->---->----->"); // direction
		if(DoTab) difference() {
			union() {
				translate([12,2,0.15]) color("gray") cyl(h=LayerThickness,d=15);
				translate([39,2,0.15]) color("lightgray") cyl(h=LayerThickness,d=15);
			}
			screw_assemble(screw3);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module gizmo_lid(DoTab=0) {
	union() {
		difference() {
			translate([0,1.5*switch_w,0]) color("cyan") cuboid([switch_l+30,switch_w,switch_t+8],rounding=2,p1=[0,0]);
			translate([-2,-2,switch_t+4]) color("salmon") cuboid([switch_l+35,switch_w+45,switch_t+8],rounding=1,p1=[0,0]);
			screw_assemble(Yes3mmInsert(Use3mmInsert,LargeInsert));
			filament_slot();
			switch_hole(1);
			translate([6,0,0]) ptfe_stops();
		}
		difference() {
			translate([switch_l/2,0,0]) color("blue") cuboid([switch_l+9,switch_w+15,switch_t+8],rounding=2,p1=[0,0]);
			translate([-2,-2,switch_t+4]) color("green") cuboid([switch_l+35,switch_w+45,switch_t+8],rounding=1,p1=[0,0]);
			screw_assemble(Yes3mmInsert(Use3mmInsert,LargeInsert));
			switch_hole(1);
			switch_mount(0.5,1);
			wire_hole();
		}
		difference() {
			translate([40.92,50.25,5.8]) rotate([-90,180,0]) color("white") printchar("<-----<----<-----");
			translate([-2,-2,switch_t+4]) color("salmon") cube([switch_l+35,switch_w+45,switch_t+8],2);
		}
		if(DoTab) difference() {
			union() {
				translate([12,2,0.15]) color("white") cyl(h=LayerThickness,d=15);
				translate([39,2,0.15]) color("purple") cyl(h=LayerThickness,d=15);
			}
			screw_assemble(Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ptfe_stops() {
	translate([switch_l-switch_w/4-7.5,switch_w+16,3+switch_t/2]) color("brown") cube([3,3,6]);
	translate([switch_l-switch_w/4+17.5,switch_w+16,3+switch_t/2]) color("wheat") cube([3,3,6]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_assemble(Size=screw3) {
	translate([15,5,-1]) color("red") cylinder(h=30,d=Size);
	translate([switch_w+25,switch_l+25,-1]) color("black") cylinder(h=30,d=Size);
	translate([5,switch_l+25,-1]) color("white") cylinder(h=30,d=Size);
	translate([switch_w+15,5,-1]) color("blue") cylinder(h=30,d=Size);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_hole(Lid=0) {
	translate([switch_l-switch_w/4-0.75,10.5,4+switch_t/2]) cuboid([switch_w,switch_w+10,switch_t],rounding=2,p1=[0,0]);
	if(!Lid)
		translate([switch_l-switch_w/4-6.5,switch_w+12.5,4+switch_t/2])
			cuboid([8,8,switch_t],rounding=1,p1=[0,0]); // lever notch
	else
		translate([switch_l-switch_w/4+17,switch_w+12.5,4+switch_t/2])
			cuboid([8,8,switch_t],rounding=1,p1=[0,0]); // lever notch
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module filament_slot() {
	translate([-5,switch_w+20,switch_t+4]) rotate([0,90,0]) cylinder(h=100,d=ptfe_od);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module wire_hole() {
	translate([switch_l+switch_w/4-0.5,15,7+switch_t/2]) rotate([90,0,0]) cylinder(h=20,d=screw4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_mount(Resize=0,Lid=0) {
	if(!Lid) {
		translate([20.5,27.5,switch_t/2+1]) color("purple") cyl(h=10,d2=screw2t-1,d1=screw2hd);
		translate([20.5+switch_ho,27.5,switch_t/2+1]) color("magenta") cyl(h=10,d2=screw2t-1,d1=screw2hd);
	} else {
		translate([21,27.5,switch_t/2]) color("purple") cylinder(h=2*switch_t,d=switch_h+Resize);
		translate([21+switch_ho,27.5,switch_t/2]) color("magenta") cylinder(h=2*switch_t,d=switch_h+Resize);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////