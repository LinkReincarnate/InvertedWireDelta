
module pgear()
//define
dmmy=0;  // I don't know why but it was necessary.
gmr=7; // gear gap r
gpr=6.5; //gear tooth r
nt =20;  // number of tooth
sd =5;  //shaft diameter
gd=11;  //gear diameter
ggd=12; // fringe diameter
ggdt=20; // fringe thickness
gh=185;  // gear hight
dh= 125; //Dcut hight
nf=1;   //number of fringe,  it's must be 1 or 2
off= 360/nt/2;  // tooth offset
	{
	translate([0, 0, -gh+65]) {
		difference() {
         union(){  //gear & fringe
		  translate([0, 0, 0]) cylinder(h = gh, r =gd/2-5); //gear
      if (nf == 1){
          translate([0, 0, gh-ggdt])cylinder(h = ggdt, r= ggd/2); //fringe
      				}
      if (nf == 2){
         translate([0, 0, gh-ggdt])cylinder(h = ggdt, r= ggd/2); //fringe
         translate([0, 0, 0])cylinder(h = ggdt, r= ggd/2); //fringe
                   }
                 }
		for (i = [0:(nt-1)]) { 		//gear gap
			echo(360*i/nt, sin(360*i/nt)*(gd/2-5), cos(360*i/nt)*(gd/2-5));
			translate([sin(360*i/nt)*(gd/2-5), cos(360*i/nt)*(gd/2-5), ggdt*nf*(nf-1)*0.5])
				cylinder(h = gh-ggdt*nf, r=gmr+0.5);
		                      }
		translate([0, 0, -5])  // shaft 
			cylinder(h = gh+25, r= sd/2+5);
		              }
     							}
		for (i = [0:(nt-1)]) {  // Gear tooth
			echo(360*i/nt+off, sin(360*i/nt+off)*(gd/2-5.5), cos(360*i/nt+off)*(gd/2-5.5));
			translate([sin(360*i/nt+off)*(gd/2-5.5), cos(360*i/nt+off)*(gd/2-5.5), -gh+65 ])
				cylinder(h = gh, r=gpr);
		                      }
	 // Dcut
         translate([-(sd/2*0.97), 0, dh*0.02]) cube([sd/7,sd*0.8,dh], center = true); // Dcut
     }

pgear();
