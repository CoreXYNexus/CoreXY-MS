# CoreXY-MS
A corexy printer using Makerslide, EXOSlide with Duet 3 6HC and 1LC using a Raspberry Pi 4.

August 2020: Upgraded to a Duet 3 6HC with 1LC.  Currently using in stand alone, no Pi.

A very old version is available at http://www.thingiverse.com/thing:1470253

https://creativecommons.org/licenses/by-sa/4.0/

https://youtu.be/llArYEVT2ow with Duet 2.
https://www.youtube.com/watch?v=qqqCqKSmpecVideo with the Duet 3.

All the horizontal extrusions, and the horizontal makerslide ends are tapped for 5mm.
Vertical 2020 is drilled with a 5.5mm bit for access to the screws that hold everything together. Four in the top and two in the bottom. Use drillguide.stl for drilling the holes.

Additional information can be found in the scad files. Include files are expected to be in a folder called inc in the folder with the printer's scad files.
In the top extrusions, I put 8 tnuts in each channel, the rest four in each. Use a short screw in a unused one to hold them to one side to quiet the rattle they can make while printing.

Spool holder: 300mm 2020 with two screw access holes in the bottom to mount it on the top rear 2040 and a 8mm hole in the top for a 8mm threaded rod long enough to hold a spool on each side. Using http://www.thingiverse.com/thing:1647748 to hold the spools.  The horizontal 2020 300mm long to hold filament guides for each spool.

On the bearing brackets from the top: M5x50, bearing support, washer, 2xF625Z,2x washers,2x F625Z, M5 nut.

If you use metal couplers for the z-axis, use a 4mm ball bearing in between the TR8 and stepper motor shaft inside the coupler. The bearing will allow tilt without changing the length.

The Litemount.stl holds a 70mm LED ring in http://www.thingiverse.com/thing:8211 I used a LM2596 buck convertor to get the 12vdc to power the ring.

Alternate lighting method is to use a 5050 LED light string stuck to the bottom of the x axis makerslide.  For EXOSlide, use PlainLEDStripHolderEXO and two short pieces for led strip.

Blower.scad uses http://www.thingiverse.com/thing:387301

Feet: http://www.thingiverse.com/thing:15880
or
Wheels: https://www.amazon.com/gp/product/B07FM76212

The 400mm x 300mm 1/4" MIC-6 AL plate bed uses 2020 to support the bed, they're attached just like rest of the extrusions. I used three 45mm x 25mm x 9mm 6061 with a 5mm hole for the extrusion mount and tapped a 3mm hole to hold the bed. I used some silicon tubing for the bed spacers. I used two keenovo 200x300 600w 110vac silicon heaters, using the thermistor in the center and wired the ac in parallel to a SSR. The printer uses 11.28 amps until PID kicks in, while printing it uses about 5 amps.  For auto-leveling (3 z leadscrew), use a 2020 frame under the bed consisting of 2 425mm and 3 385mm.

Cover for the SSR: http://www.thingiverse.com/thing:1001385

Spool holder: http://www.thingiverse.com/thing:1647748

Parts cooling fan: 4040 blower or a berd air

FancapL.stl is for the power supply fan to make it blow to the side.

9/2021 - Added EXOSlide use for X-Carraige.

Uses:
		OPENSCAD https://www.openscad.org/downloads.html  Use version 2019.05 or later.

		BOSL2: https://github.com/revarbat/BOSL2
		
		NEMA17 from https://github.com/mtu-most/most-scad-libraries
		
		configuration.scad, metric.scad, fasteners.scad, functions.scad are from an old version of http://github.com/prusajr/PrusaMendel

		
