/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 40mmTo30mmFan.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/7/21
// last update 10/24/21
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2/11/21	- Added an offset fan adapter
// 2/14/21	- Added an angled fan adapter
// 4/3/21	- Converted to BOSL2
// 10/19/21	- Added E3DV6 5150 blower adapter
//10/24/21	- Changed FanAdapterWithOffsetAngled() to a longer one for clearance for a BMG
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <BOSL2/std.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
40mmOffset=33;
30mmOffset=24;
40mmFanDiameter=40;
30mmFanDiameter=30;
40mmScrewOffset=3;
30mmScrewOffset=7.9;
LayerHeight=0.3;
Use3mmInsert=1;
Use4mmInsert=1;
LargeInsert=0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//FanAdapter();
//FanAdapterWithOffset();
FanAdapterWithOffsetAngled();
//5150Adapter();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 5150Adapter() {
	difference() {
		union() {
			color("cyan") cuboid([30mmFanDiameter+2,30mmFanDiameter+2,10],rounding=1);
			translate([-10.5,-6,45/2]) difference() {
				translate([0,0,3]) color("purple") cuboid([5,10,56],rounding=1);
				translate([-10,0,27]) color("green") rotate([0,90,0]) cylinder(h=20,d=Yes4mmInsert(Use4mmInsert));
			}
		}
		translate([-8,-10,0]) color("green") cube([15,20,10]);
		translate([0,0,-7]) hull() {
			translate([0,0,-1]) color("blue") cylinder(h=5,d=30mmFanDiameter);
			translate([-8,-10,4]) cube([15,20,5]);
		}
		translate([-20,-20,15]) 30mmMount(10);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapter(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cuboid([40mmFanDiameter,40mmFanDiameter,1],rounding=0.5);
			translate([(40mmFanDiameter-30mmFanDiameter)/2-5,(40mmFanDiameter-30mmFanDiameter)/2-5,-Thickness])
				cuboid([30mmFanDiameter,30mmFanDiameter,1],rounding=0.5);
		}
		translate([-20,-20,2]) 40mmMount(Thickness);
		translate([-20,-20,2]) 30mmMount(Thickness);
		translate([-20,-20,2]) FanHole(Thickness);
	}
	translate([-20,-20,0.7]) SupportFor30mmMount(Thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapterWithOffset(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cuboid([40mmFanDiameter,40mmFanDiameter,1],rounding=0.5);
			translate([0,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness])
				cuboid([30mmFanDiameter,30mmFanDiameter,-Thickness],rounding=0.5);
		}
		translate([-20,-20,-2]) 40mmMount(Thickness);
		translate([-20,-15,2]) 30mmMount(Thickness);
		translate([-9.5,-14,2]) FanHoleWithOffset(Thickness);
	}
	translate([-9.5,-14,2]) SupportFor30mmMountWithOffset(Thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapterWithOffsetAngled(Thickness=10) {
	difference() {
		color("cyan") hull() {
			translate([-3,0,0]) rotate([0,-30,0]) cuboid([40mmFanDiameter+2,40mmFanDiameter+2,4],rounding=2);
			translate([-5,(40mmFanDiameter-30mmFanDiameter)/2-5,-50])
				cuboid([30mmFanDiameter+2,30mmFanDiameter+2,5],rounding=2);
		}
		translate([-26,-19.5,0]) rotate([0,-30,0]) 40mmMount(Thickness);
		translate([-25,-20,-37]) 30mmMountV3(Thickness);
		translate([-15,-19.5,-5]) FanHoleWithOffsetV4(Thickness);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 40mmMount(Thickness) {
	translate([40mmScrewOffset,40mmScrewOffset,-Thickness*2.5]) color("red")
		cylinder(h=Thickness*5,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset,-Thickness*2.5]) color("blue")
		cylinder(h=Thickness*5,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*5,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("black")
		cylinder(h=Thickness*5,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMount(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("lightgray") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness-1]) color("black") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness-1]) color("plum") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness-1]) color("red")
		cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness-1]) color("white") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness-1]) color("plum") cylinder(h=Thickness*7,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMountV2(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("lightgray") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness+5]) color("black") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness+5]) color("plum") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("white") cylinder(h=Thickness*7,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("red")
		cylinder(h=Thickness*8,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMountV3(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("lightgray") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness+5]) color("green") cylinder(h=Thickness*8,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness+5]) color("plum") cylinder(h=Thickness*8,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("white") cylinder(h=Thickness*8,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("red")
		cylinder(h=Thickness*8,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHole(Thickness) {
	color("blue") hull() {
		translate([20,20,Thickness+2]) cylinder(h=1,d=39);
		translate([20,20,-Thickness-5]) cylinder(h=1,d=27);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffset(Thickness) {
	color("blue") hull() {
		translate([9.5,10,Thickness-1]) cylinder(h=1,d=38);
		translate([9.5,20,-Thickness-4]) cylinder(h=1,d=27);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffsetV4(Thickness) {
	translate([0,0,-10]) color("red") hull() {
		translate([12,19.5,Thickness+9]) rotate([0,-30,0]) cylinder(h=1,d=36);
		translate([10,19.5,-50]) cylinder(h=1,d=27);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffsetV2(Thickness) {
	color("blue") hull() {
		translate([8,20,Thickness+9]) rotate([0,-30,0]) cylinder(h=1,d=36);
		translate([10,19.8,-Thickness-5]) cylinder(h=1,d=27);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffsetV3(Thickness) {
	translate([0,0,-10]) color("blue") hull() {
		translate([8,20,Thickness+9]) rotate([0,-30,0]) cylinder(h=1,d=36);
		translate([10,19.8,-65]) cylinder(h=1,d=27);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMount(Thickness) {
	difference() {
		translate([30mmScrewOffset*2.5,30mmScrewOffset*2.5,-Thickness]) color("gray")
			cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([0,0,-Thickness*2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([0,40,-Thickness*2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-5,0,-Thickness*1]) rotate([0,45,0]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([35,0,-Thickness*1]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHole(Thickness);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMountWithOffset(Thickness) {
	difference() {
		translate([10,30mmScrewOffset*2.5-2,-Thickness-LayerHeight-1]) color("gray")
			cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([-5,1,-Thickness*2-2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([-5,37,-Thickness*2-2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-12.6,0,-Thickness*1.5]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([22,0,-Thickness]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHoleWithOffset(Thickness);
		40mmMount(Thickness);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
