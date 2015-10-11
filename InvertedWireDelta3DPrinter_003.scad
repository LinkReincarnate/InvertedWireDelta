 include <utl.NEMA.scad>
include <rampsMount.scad>
module printerBody(){

    difference(){
        union(){
            //MainBody
            cylinder($fn=6, h=5, r=70);
            
            //TopLineAnchors
                rotate(30, [0, 0, 1])
               for ( i = [0 : 5] ){
                  rotate( i * 60, [0, 0, 1])
                    translate([0,63,10]){
                        rotate(90 , [0,0,1])
                            difference(){
                                cube([5,10,15], center=true);
                                rotate([0,90,0]){
                                    translate([-1,0,-6]){
                                        cylinder(h=12, r=2);
                                    }
                                }
                            }
                        }
                }
        }
        //center hole
        translate([0,0,-1]){
            cylinder(h=7, r=8);
        }
        //StepperMounts
            for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 30])
                    translate([0,33,3]){
                        rotate([0,0,0]){
                            nema17DiffBlock();
                            //#nema17();   
                        }
                    }
            }
            //tensioning pins
            rotate(30,[0,0,1])
            for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 30])
                    translate([-3,44,-4]){
                        rotate([0,0,0]){
                            cylinder(h=10, r=1);  
                        }
                    }
            }
    }
}
module spool(){
    difference(){
        union(){
            //near flange
            translate([0,0,9])
                cylinder(d1=19,d2=14, h=5);
            //far flange
            translate([0,0,29])
                cylinder(d=19, h=3);
            difference(){
                //outer spool part
                translate([0,0,.1])
                   cylinder($fn=64, d=14, h=30);
                //inner spool cutout
               cylinder($fn=20, d=12, h=14); 
           }
       }
       //stringhole
       rotate([0,90,0])
       translate([-14,0,-15])
       cylinder(d=2, h=40);
    }
}

printerBody();
//spool();
