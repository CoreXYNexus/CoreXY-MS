include <inc/cubex.scad>
wall=8;
width=20;


translate([-0.5,35,-4]) color("red") cubeX([width-0.15,wall,wall],1); // mak rear xcarriage even with front
