
//-----------------------------

epsilon=.05;
facet_epsilon = 0.03;
function facets(r) = 180 / acos(1 - (facet_epsilon / r));

module rounded(r=1) {
  offset(r=r, $fn=facets(r*2)) offset(r=-r, $fn=facets(r*2)) children(0);
}


//------------------------------

//overall thickness
thk=3;


//duct
d_h=9*3.3;
d_w=16*3.3;
h=d_h*1.3;


//magnet 
m_diam=8;
m_thk=1.85;
m_mount_wall=1.5;

batt_diam=24.5;
batt_h=2.9;


led_diam=4.9;
led_h=5;
led_b_diam=6.1;
led_b_thk=1.2;

//Outter duct
module outter(){
	color("grey")
	linear_extrude(height=h){
		rounded(2)
		square([d_w,d_h]);
	}
}


//Inner duct
module inner(){
	color("grey")
	translate([thk/2,thk/2,-epsilon])
	linear_extrude(height=h+epsilon*2){
		rounded(2)
		square([d_w-thk,d_h-thk]);
	}
}

//Hanger 
module hanger() {
	color("grey")
	difference(){
		//place a sphere at the top
		translate([d_w/2,0,h/2])
		sphere(d_h/5,$fn=60);
		//remove back half
		translate([d_h/4,-d_h/4,h/2+thk/2.5])
		cube([d_h,d_h/4+epsilon*2,d_h/4+epsilon*2]);
		//remove front half
		translate([d_h/4,-d_h/4,h/2-(d_h/4)-thk/2.5])
		cube([d_h,d_h/4+epsilon*2,d_h/4+epsilon*2]);
		//make a hole
		translate([d_w/2,-(d_h/5)/2,(h/2)-(d_h/4)/2])
		cylinder(r=thk/2,h=d_h/4,$fn=60);
	}
}

//place a magnet at the bottom center of the duct

module pic_mounts(){
	translate([d_w/2,d_h-thk/2+.5,h/2])
	rotate([90,0,0])
	cylinder(r=3,h=2,$fn=60);

	translate([d_w/2,thk/2+1.5,h/2])
	rotate([90,0,0])

	cylinder(r=3,h=2,$fn=60);
	translate([thk/2,0,0])
	#cube([2.5,d_h,1]);
	translate([d_w-2.5-thk/2,0,0])
	#cube([2.5,d_h,1]);

}


module magnet(){
	color("silver")
	translate([d_w/2,m_thk+d_h-.5,h/2])
	rotate([90,0,0])
	cylinder(r=m_diam/2,h=m_thk,$fn=60);
	//translate([d_w/2,m_thk+d_h,h/2])
	//rotate([90,0,0])
	//cylinder(r=m_diam/2,h=m_thk,$fn=60);
}

module magnet_housing(){
	color("grey")
	translate([d_w/2,m_thk+d_h-.5,h/2])
	rotate([90,0,0])
	cylinder(r=m_diam/2+thk/2,h=m_thk,$fn=60);

}

module battery(){
	color("green")
	translate([d_w/2,m_thk+d_h+batt_h-.5,h/2])
	rotate([90,0,0])
	cylinder(r=batt_diam/2,h=batt_h,$fn=90);


}

module batt_position(){
	difference(){
		color("grey")
		translate([d_w/2,d_h+m_thk-epsilon+batt_h,h/2])
		rotate([90,0,0])
		cylinder(r=batt_diam/2+thk/2,h=batt_h+m_thk,$fn=90);
		rotate([90,0,0])
		translate([0,h/2.8,-d_h-thk-m_thk])
		cube([d_w,h/2.5,m_thk+thk+epsilon*2]);
		translate([d_w/2,d_h+batt_h+m_thk,h/2])
		rotate([90,0,0])
		cylinder(r=batt_diam/2,h=batt_h+m_thk,$fn=90);
		rotate([0,30,0])
		translate([d_w*.2,d_h+m_thk,0])
		cylinder(r=1,h=h,$fn=60);

	}
}


led_z=.6;
led_x=.25;

module led(){
	color("orange")
	translate([d_w*led_x,d_h+thk/2,h*led_z]){
		rotate([90,0,0]){	
			cylinder(r=led_b_diam/2,h=led_b_thk,$fn=60);
			translate([0,0,led_b_thk])
			cylinder(r=led_diam/2,h=led_h,$fn=60);
			translate([0,0,led_b_thk+led_h])
			sphere(led_diam/2,$fn=60);
			//fake punchout
			translate([0,0,led_b_thk-thk/2-m_thk+epsilon])
			cylinder(r=led_b_diam/2,h=led_b_thk*2+m_thk,$fn=60);

			rotate([90,0,90])
			translate([0,-3,0])
			#cube([1.5,4.2,13]);
			//cylinder(r=.75,h=h,$fn=60);
			

			//rotate([90,0,0])
			translate([4.8,-13.1,-d_h-9])
			#cylinder(r=.75,h=h,$fn=60);

			//cylinder(r=1,h=h,$fn=60);



			rotate([0,00])
			translate([-1.5,-15,-thk/2-1.5])
			#cube([1.5,15,4.2]);

			
		}
	}
}

module led_mount(){
	color("grey")
	translate([d_w*led_x,d_h+m_thk,h*led_z]){
		rotate([90,0,0]){	
			cylinder(r=led_b_diam/2+thk/3,h=m_thk+thk/2,$fn=60);
			translate([0,0,m_thk+thk/2-epsilon])
			cylinder(r=led_diam/1.6,h=led_h-2,$fn=60);	
		}
	}

}




difference(){
	union(){
		pic_mounts();
		//magnet();	
		difference(){
			union(){
				outter();
				hanger();

			}
			inner();
		}
		led_mount();
		magnet_housing();
		//battery();
		batt_position();
	}
	led();
	magnet();
}
