# CXY-MSv1
A corexy printer using Makerslide and a DuetWifi on 24vdc. Please ignore the messy wiring in the photos. :-)

This is also available at http://www.thingiverse.com/thing:1470253

https://youtu.be/llArYEVT2ow

9/18/16 - Changed to a double plate x-carriage, corexy-x-carriage.scad has mounts for BLTouch and dc42's ir sensor. Proximity sensor version is for 19mm diameter.
9/23/16 - Added photos of the rear of the x-carriage.
10/1/16 - Added mount for E3D's Titan Extruder with a E3DV6 hotend, posted stl has mounting for the ir bracket to use DC42's ir sensor. Proximity & BLTouch is available in the scad file.
10/15/16 - Updated blower.scad for the blower mounts for the Titan extruder mount.
11/7/16 - Added an idler bearing to the z-axis leadscrew bearing mounts so that the belt wraps around more of the pulleys.  Also included a stl that just has the z bearing mounts for printing replacements of the originals.

12/20/16 - Changed the Titan extruder plate by moving the hotend 20mm to the -x and changed the sensor mounts to seperate attachments.

All the horizontal 2020/2040, and the vertical & horizontal makerslide ends are tapped for 5mm.
Vertical 2020 is drilled with a 5.5mm bit for access to the screws that hold everything together. Four in the top and two in the bottom. Use drillguide.stl for drilling the holes.

Corexy-x-carriage-extruder-drillguide.stl has a drill guide if you want to use 1/8" Aluminum in place of the printed extruder plate.

Additional information can be found in the scad files. Include files are expected to be in a folder called inc in the folder with the printer's scad files.
In the top extrusions, I put 8 tnuts in each channel, the rest four in each. Use a short screw in a unused one to hold them to one side to quiet the rattle they can make while printing.

Spool holder: 300mm 2020 with two screw access holes in the bottom to mount it on the top rear 4020 and a 8mm hole in the top for a 8mm threaded rod long enough to hold a spool on each side. Using http://www.thingiverse.com/thing:1647748 to hold the spools.  The horizontal 2020 300mm long to hold filament guides for each spool.

On the bearing brackets from the top: M5x50, bearing support, washer, 2xF625Z,2x washers,2x F625Z, M5 nut.

If you use metal couplers for the z-axis, use a 4mm ball bearing in between the TR8 and stepper motor shaft inside the coupler. The bearing will allow tilt without changing the length.

The Litemount.stl holds a 70mm LED ring in http://www.thingiverse.com/thing:8211 I used a LM2596 buck convertor to get the 12vdc to power the ring.

Alternate lighting method is to use a 5050 LED light string stuck to the bottom of the x axis makerslide.

Blower.scad uses http://www.thingiverse.com/thing:387301

The feet: http://www.thingiverse.com/thing:15880

The 400mm x 300mm 1/4" MIC-6 AL plate bed uses three short 2020 to support the bed, they're attached just like rest of the extrusions. I used three 45mm x 25mm x 9mm 6061 with a 5mm hole for the extrusion mount and tapped a 3mm hole to hold the bed. I used some silicon tubing for the bed spacers. I used two keenovo 200x300 600w 110vac silicon heaters, using the thermistor in the center and wired the ac in parallel to a SSR. The printer uses 11.28 amps until PID kicks in, while printing it uses about 5 amps.

Cover for the SSR: http://www.thingiverse.com/thing:1001385

Fans are 24vdc 5015 blowers.

FancapL.stl is for the power supply fan to make it blow to the side.

Uses: cubeX from http://www.thingiverse.com/thing:112008
      NEMA17 from https://github.com/mtu-most/most-scad-libraries
      configuration.scad, metric.scad, and functions.scad are from http://github.com/prusajr/PrusaMendel


