height=128;
thickness=3;
plateWidth=63;

//height=50;
//thickness=2;
//plateWidth=50;

tubeRadius=6.1;
outerRadius=tubeRadius + thickness;
plateCornerRadius=7;
distScrewX=38;
distScrewZ=31;
radiusScrew=2;
heightSupport = height/8;
supportSize = outerRadius-thickness;
$fn=60;

radiusNut = 3.9;
radiusWasher = 4.6;
whasherNutDepth=1;

letterSize = 4;
letterDepth=1;
font = "Liberation Mono"; //["Liberation Sans", "Liberation Sans:style=Bold", "Liberation Sans:style=Italic", "Liberation Mono", "Liberation Serif"]

module letter(l) {
  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = 1+letterDepth) {
    text(l, size = letterSize, font = font, halign = "left", valign = "center", $fn = 60);
  }
}

difference(){
    union(){
        // outer tube
        cylinder(height, outerRadius, outerRadius);
        // tube is attached to the plate in a U form
        translate([-outerRadius, 0, 0])
          cube([outerRadius*2, outerRadius, height], center=false);
        
        
        // the plate with rounded corners
        translate([-plateWidth/2, tubeRadius, 0])
        union(){
          difference(){
            cube([plateWidth, thickness, height], center=false);
            union(){
                translate([plateWidth-plateCornerRadius, -1, -1])
                  cube([plateCornerRadius+1, thickness+2, plateCornerRadius+1]);
                translate([-1, -1, -1])
                  cube([plateCornerRadius+1, thickness+2, plateCornerRadius+1]);
                translate([plateWidth-plateCornerRadius, -1, height-plateCornerRadius])
                  cube([plateCornerRadius+1, thickness+2, plateCornerRadius+1]);
                translate([-1, -1, height-plateCornerRadius])
                  cube([plateCornerRadius+1, thickness+2, plateCornerRadius+1]);
            }
          }
          translate([plateWidth-plateCornerRadius, 0, plateCornerRadius])
            rotate([-90, 0, 0])
               cylinder(thickness, plateCornerRadius,plateCornerRadius);
          translate([plateCornerRadius, 0, plateCornerRadius])
            rotate([-90, 0, 0])
               cylinder(thickness, plateCornerRadius,plateCornerRadius);
          translate([plateWidth-plateCornerRadius, 0, height-plateCornerRadius])
            rotate([-90, 0, 0])
               cylinder(thickness, plateCornerRadius,plateCornerRadius);
          translate([plateCornerRadius, 0, height-plateCornerRadius])
            rotate([-90, 0, 0])
               cylinder(thickness, plateCornerRadius,plateCornerRadius);

          
        }
        
//        // the side supports - for lateral strength
//        for(i=[0,1]){
//            mirror([i,0,0])
//                translate([outerRadius, 0, 0])
//                    difference(){
//                        union(){
//                            for(z=[0, (height-heightSupport)/2, height-heightSupport]){
//                                translate([0,0,z]){
//                                    cube([supportSize, supportSize, heightSupport]);
//                                }
//                            }
//                        }
//                        translate([supportSize, 0, -1]){
//                            cylinder(height+2, supportSize,supportSize);
//                        }
//                    }
//        }

    }
    union(){
        // inner tube extrusion, but letting a cap on top
        translate([0,0,-thickness])
          cylinder(height, tubeRadius, tubeRadius, $fn=120);
        
        translate([0, tubeRadius-1, height/2]){
            // 4 holes to screw the GPS holder in
            for(i=[-1, 1], j=[-1, 1]){
                translate([i*distScrewX/2, 0, j*distScrewZ/2]){
                    rotate([-90, 0, 0]){
                        cylinder(thickness+2, radiusScrew, radiusScrew);
                        // nut inserts
                        cylinder(1+whasherNutDepth, radiusNut,radiusNut, $fn=6);
                    }     
                }
            }
        }
        // text logo
        translate([0, outerRadius-thickness, 0])
            translate([plateWidth/2-letterSize,letterDepth, 10])
               rotate([90, -90, 0])
                  letter("Terra Submersa");
        
        // the lateral hole for a bolt do fix to the pipe
        translate([-outerRadius-1, 0, height/4+heightSupport/4])
          rotate([0, 90, 0]){
            cylinder(2*outerRadius+2, radiusScrew, radiusScrew);
            // nut inserts
            cylinder(1+whasherNutDepth, radiusNut,radiusNut, $fn=6);
            // washer insert
            translate([0,0,1+2*outerRadius-whasherNutDepth])
               cylinder(1+whasherNutDepth, radiusWasher,radiusWasher);

          }
        
    }
}

