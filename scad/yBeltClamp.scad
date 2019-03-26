// yBeltBlamp.scad - https://www.thingiverse.com/thing:863408
// added comments, move inline modules to main to allow use <>, pretty upped code and added color()
// 2/22/19 - changed belt slot size for my belt

$fn=32 * 4;

platformHeight = 35.5; //clearance between y carriage and belt. Default 15.5mm fits for my Prusa i3. 

module beltClamp(){
	difference(){
		frame();
		translate([0,6.5,3]) beltOpening();
	}
}

module frame(){ // belt loop frame
	 color("blue") hull(){
		translate([7,11,0]) rotate([0,0,30])cylinder(10,8,8,$fn=6);
		translate([31,10.5,0]) rotate([0,0,30]) cylinder(10,8,8,$fn=6);
	}
}

module beltLoop(){ // the loop that holds the belt
	difference(){
		 color("red") hull(){ // belt slot (1.5mm)
			translate([6.5,1,0]) cylinder(h = 12, r1 = 1, r2 = 1);
			translate([13.5,5.5,0]) cylinder(h = 12, r1 = 6, r2 = 6);
		}
		 color("pink") hull(){ // inner boss
			translate([9,3,0]) cylinder(h = 12, r1 = 1, r2 = 1);
			translate([13.5,5.5,0]) cylinder(h = 12, r1 = 4, r2 = 4);
		}
	}
	 color("gray") cube([8,2.5,12]); // belt exit slot
}


module beltOpening(){  // both belt loops
	translate([-0.5,0,0]) beltLoop();
	translate([38.5,0,0]) mirror([1,0,0]) beltLoop();
	//translate([17.5,4,0])  color("khaki") cube([3,8,12]); // remove section between bosses
	//translate([19,7,0]) rotate([0,0,45])  color("white") cube([4,4,12]); // remove section between bosses
}

module platform(){
	translate([8.5,-1,-0])  color("plum") cube([33,platformHeight,10]);
	difference(){ // mount to y frame/bed
		translate([0,-1,0])  color("cyan") cube([50,4,10]);
		translate([4.5,-1,6]) rotate([-90,0,0])  color("black") cylinder(h=30, r=1.7); //, $fn=100);
		translate([45.5,-1,6]) rotate([-90,0,0])  color("salmon") cylinder(h=30, r=1.7); //, $fn=100);
	}
}

translate([6,platformHeight-6.5,0]) beltClamp();
platform();
