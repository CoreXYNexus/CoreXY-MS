////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PlainLEDStripHolderEXO.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 9/25/21
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
// 3/5/21	- Added a strip holder for a plain strip of leds 100mm long to mount on the bottom
// 3/6/21	- PlainLEDStripHolder() can now use two strips
// 4/3/21	- Added hole for NEOPixelCover() if a non-transparent filametnt is used.  Added labels.
// 4/4/21	- Widden the plain led strip holder to get the leds closer to the hotend and can install two strips
//			  Converted to use BOSL2
// 5/16/21	- Added another short led strip mount that goes between the hotend and bltouch
// 9/25/21	- Added to CXY-MXV1 printer, made short LED mount able to be shifted or eliminated
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <BOSL2/std.scad> //was inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses three pieces of led light strips
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LEDStripWidth=8.5;
LayerThickness=0.35;
/////////////////////////////////////////////////////////////////////////////////////////////////

PlainLEDStripHolder(1,0);

///////////////////////////////////////////////////////////////////////////////////////////////////////

module PlainLEDStripHolder(DoTabs=1,ShiftShortLEDTab=0) {
	difference() {
		translate([0,-10,0]) color("cyan") cuboid([110,45,4],rounding=2);
		translate([-37,15,0]) {
			translate([0,-10,-3])color("red") cylinder(h=10,d=screw4);
			translate([40,-10,-3]) color("blue") cylinder(h=10,d=screw4);
			translate([0,-10,1.5])color("blue") cylinder(h=5,d=screw4hd);
			translate([40,-10,1.5]) color("red") cylinder(h=5,d=screw4hd);
		}
		translate([0,11,0]) ZipTieHoleSlot();
		translate([-50,11,0]) ZipTieHoleSlot();
		translate([-98,11,0]) ZipTieHoleSlot();
		translate([0,25,0]) {
			ZipTieHoleSlot();
			translate([-50,0,0]) ZipTieHoleSlot();
			translate([-98,0,0]) ZipTieHoleSlot();
		}
	}
	if(ShiftShortLEDTab != 0) {
		translate([ShiftShortLEDTab,0,0]) difference() {
			union() {
				translate([0,-49,0]) color("blue") cuboid([20,40,4],rounding=2);
				if(DoTabs) {
					translate([-9,-68,-2]) color("gray") cylinder(h=LayerThickness,d=10);
					translate([9,-68,-2]) color("white") cylinder(h=LayerThickness,d=10);
				}
			}
			translate([-34,-85,0]) rotate([0,0,90]) ZipTieHoleSlot();
			translate([-34,-112,0]) rotate([0,0,90]) ZipTieHoleSlot();
		}
	}
	if(DoTabs) {
		difference() {
			union() {
				translate([52,-30,-2]) color("red") cylinder(h=LayerThickness,d=10);
				translate([-52,-30,-2]) color("blue") cylinder(h=LayerThickness,d=10);
				translate([52,11,-2]) color("gray") cylinder(h=LayerThickness,d=10);
				translate([-52,11,-2]) color("white") cylinder(h=LayerThickness,d=10);
			}
			translate([0,10,0]) ZipTieHoleSlot();
			translate([-99,10,0]) ZipTieHoleSlot();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZipTieHoleSlot(TwoStrips=0) { // the sticky back on the led strip doesn't hold very good
	translate([-54,-40,0]) {
		translate([103,11,-3]) color("black") cylinder(h=10,d=3.5);
		translate([103,11-LEDStripWidth,-3]) color("gray") cylinder(h=10,d=3.5);
		translate([103.11,6,-1.5]) color("lightgray") cuboid([5,14,4],rounding=2);
	}
}

