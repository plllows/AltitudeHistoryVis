boolean animate = false;
Button animate_PAUSE;
Button animate_SPEED;
Button animate_RESTART;
Button animate_SKIP;
Button animate_CONTINUE;
Button animate_REPLAY;

Button ani_propeller;
Button ani_turbojet;
Button ani_jetplane;
Button ani_balloons;
Button ani_gliders;
Button ani_mountainAlt;
Button ani_mountainSum;
Button ani_airLaunched;
Button ani_spaceFlight;

boolean loopDelay = false;
int ani_counter1 = 0; //a finish menu that appears once each run

float[] frameRates; //controls animation speed - this was initialised in GC_II
float x_increment = 0.2; //default framerate - changed with ani_speed();

int range = 40; //how wide is the x axis?
int increment = 15; //unrelated to the scrolling of the years in x-axis, but rather the spacing out of the points plotted onto the graph (confusing naming - sorry)
int x_axis_counter; 

//various graph-related variables - lx and ux refers to the lowest year and highest year displayed - ani_ prefix denotes max and min respectively
long temp_uy = 0;
int ani_lx=1750;
int ani_ux=2040;
float lx = ani_lx;
float ux = lx+range;
int ani_uy=10; //this is the default range of the y axis i.e. goes from 0 to 10 metres; can creat ly and ani_ly to filter lowest value of y axis, but not enough space on GUI to include 
long uy = ani_uy;
int speedcounter = -1; //cycles through the array containing different values of x_increment

float yscale; //scales the altitude to plot them onto the graph

void animate() {
  ani_hover(); //checks hover for relevant buttons in this page
  background(255);
  ani_UI_disp(); //text labels for various buttons and information on the bottom, top and left side of the canvas
  
  pushMatrix(); //translation of the graph in animation frame - for shifting things around the canvas easily
  translate(-10,0); 
  dynaUI_disp();
  
  ani_graph_xaxis(); //displays formatting for x_axis line
  ani_graph_staticpoint(); //displays the narrow ellipses in each frame
  ani_graph_dynamicpointdisp(); //displays the dynamic ellipses in each frame
  ani_graph_dynamicpointinteract(); //this tests for whether the mouse is over each dynamic ellipse currently displays, and if so will display the event summary
  ani_graph_xincrement(); //increments the year (x axis) at the appropriate rate
  //it may seem pointless to have five functions that go through basically the same for loop, but in order to layer the drawings on top of each other
  //so things don't draw over each other, I chose to resolve this issue this way
  popMatrix();
  
  if ((ani_counter1==0)&&!(ux+x_increment<=ani_ux)) { //menu that appears after animation runs its course
    ani_counter1=1;
  }
  if (ani_counter1==1) {
    ani_finish();
  }
}

void ani_button_disp() {
  animate_PAUSE.display();
  animate_SPEED.display();
  animate_RESTART.display();
  animate_SKIP.display();
  
  ani_propeller.display();
  ani_turbojet.display();
  ani_jetplane.display();
  ani_balloons.display();
  ani_gliders.display();
  ani_mountainAlt.display();
  ani_mountainSum.display();
  ani_airLaunched.display();
  ani_spaceFlight.display();
}

void dynaUI_disp() { 
  pushMatrix();
  textFormat(0,0,0,18,1,0);
  text("YEAR (C.E.)",320,525);  //x and y axis labels
  rotate(-PI/2.0);
  translate(-340,40);
  text("ALTITUDE (metres)",0,0);
  popMatrix();
  ani_static_axes(); //static x and y axis lines
  ani_set_uy();
}

void ani_graph_xaxis() {
  x_axis_counter = 0;
  for (int i=floor(lx);i<floor(ux);i++) { //for each year in the current viewing range
    x_axis_counter+=increment;
    textFormat(0,0,0,13,0,5);
    //scrolling x-axis labels 
    if (i%5==0) {
      line(60+x_axis_counter,475,60+x_axis_counter,480); //graphs the years onto x axis with equal displacement from each other (when year%5 == 0); horizontal scaling controlled by x_axis_counter
      text(str(i),45+x_axis_counter,500); 
      if (i%2 == 0) {
        stroke(220); strokeWeight(1);
        line(60+x_axis_counter,473,60+x_axis_counter,50); //every 10 years does a long line, every 5 years does a short line
      }  
    }
  }
}

void ani_graph_staticpoint() {
  x_axis_counter = 0;
  for (int i=floor(lx);i<floor(ux);i++) { //for each year in the current viewing range
    x_axis_counter+=increment;
    for (int j=0;j<datasetCount;j++) { //for each set of data
      if (dataSwitch[j]) {
        if (collection_data[j].getDa()[1][i-1749]!=0) { //if the highest altitude for that transport in that year is not 0
          ani_colourselect(j);
          noStroke();
          ellipse(60+x_axis_counter,floor(480-(collection_data[j].getDa()[1][i-1749]*yscale)),12,2); //displays a thin ellipse appropriately
        }
      }
    }
  } //floor(480-(altitude*yscale))
}

void ani_graph_dynamicpointdisp() {
  x_axis_counter = 0;
  for (int i=floor(lx);i<floor(ux);i++) { //for each year in the current viewing range
    x_axis_counter+=increment;
    for (int j=0;j<datasetCount;j++) { 
      if (dataSwitch[j]) {
        for (int k=0;k<get_holdercount(j);k++) {
          if ((get_holder(j)[k].getYear())==i+1) { //honestly not sure why i+1 but it works 
            get_holder(j)[k].display();
          }
        }
      }
    }
  }
}

void ani_graph_dynamicpointinteract() {
  x_axis_counter = 0;
  for (int i=floor(lx);i<floor(ux);i++) { //for each year in the current viewing range
    x_axis_counter+=increment;
    for (int j=0;j<datasetCount;j++) { //for each
      if (dataSwitch[j]) {
        for (int k=0;k<get_holdercount(j);k++) {
          if ((get_holder(j)[k].getYear())==i+1) {
            get_holder(j)[k].hover();
            get_holder(j)[k].summary();
          }
        }
      }
    }
  }
}

void ani_graph_xincrement() {
  //incrementing x axis if not paused 
  if (!loopDelay) { 
    if (((ux+x_increment)<=ani_ux)&&((lx+x_increment)>=ani_lx)) {
      ux+=x_increment;
      lx+=x_increment;
    }
  }
}

int get_holdercount(int j) { //refer to a3lotofbuttons
  switch (j) {
    case 0:
      return p_p_holdercount;
    case 1:
      return tj_holdercount;
    case 2:
      return p_j_holdercount;
    case 3:
      return bloon_holdercount;
    case 4:
      return gli_holdercount;
    case 5:
      return mtnA_holdercount;
    case 6:
      return mtnS_holdercount;
    case 7:
      return p_alr_holdercount;
    case 8: 
      return spcfl_holdercount;
  }
  return -1;
}

Button_ia[] get_holder(int j) { //refer to a3lotofbuttons
  switch (j) {
    case 0:
      return p_p_holder;
    case 1:
      return tj_holder;
    case 2:
      return p_j_holder;
    case 3:
      return bloon_holder;
    case 4:
      return gli_holder;
    case 5:
      return mtnA_holder;
    case 6:
      return mtnS_holder;
    case 7:
      return p_alr_holder;
    default: 
      return spcfl_holder;
  }
}

void ani_static_axes() {
  //x axis formatting
  line(60,480,60+(range+1)*increment,480);
  line(60+(range+1)*increment,470,60+(range+1)*increment,480);
  
  //static y axis
  line (60,50,60,480);  //total playspace of 430 pixels
  line(60,55,65,55); 
}

void ani_colourselect(int Pj) {
  switch (Pj) { //different colour for different data sauces (diff types of transport)
    case 0:
      fill(255,0,0);
      break;
    case 1:
      fill(255,155,0);
      break;
    case 2:
      fill(255,255,0);
      break;
    case 3:
      fill(0,255,0);
      break;
    case 4:
      fill(0,0,255);
      break;
    case 5:
      fill(255,0,255);
      break;
    case 6:
      fill(200,0,200);
      break;
    case 7:
      fill(155);
      break;
    case 8: 
      fill(30);
      break;
  }
}

void ani_set_uy() { //helps to scale the altitudes of the data for display purposes
  temp_uy = 0L;
  for (int i=ceil(lx);i<floor(ux);i++) { //for each year in the current viewing range
    for (int j=0;j<datasetCount;j++) { //for each set of data,
      if (dataSwitch[j]) {
        if ((collection_data[j].getDa()[1][i-1749])>temp_uy) {
          temp_uy = floor(collection_data[j].getDa()[1][i-1749]); //if highest altitude is outside of current range, we extend range so max value is the highest current altitude
        }
      }
    }
  }
  uy = temp_uy;  //uy = upper y, meaning the highest current altitude being displayed
  yscale = (420.0/uy);  //this scaling variable ensures all altitudes less than or equal to the highest altitude reached in that year can be graphed within the range of our graph
  textFormat(0,0,0,15,1,0);
  //text(str(yscale),400,330); //checking y scaling variables working as intended
  text(str(uy),69,60); //displays the highest altitude currently reached at the top of the y axis
}

void ani_UI_disp() {
  //bottom menu
  textFormat(200,200,200,1,0,0);
  rect(-5,540,width+10,56);  //gray bar at the bottom that has the bottom buttons
  ani_button_disp();
  pushMatrix();
  translate(0,6);
  textFormat(30,30,30,29,1,0);
  if (animate_SPEED.getActive()) {text("BUGGED OUT",100,450);} else {text("ADJUST SPEED",300,572);}
  if (animate_SKIP.getActive()) {text("BUGGED OUT",200,450);} else {text(" BACK",860,572);}
  if (animate_RESTART.getActive()) {text("BUGGED OUT",200,450);} else {text("REPLAY",620,572);}
  if (loopDelay) {
    text("PLAY",97,572);
  } else if (!loopDelay) {
    text("PAUSE",97,572);
  }
  popMatrix();
  
  //top info bar
  textFormat(0,0,0,20,1,0);
  if (((ux+abs(x_increment)<ani_ux)&&(lx-abs(x_increment)>ani_lx))&&(loopDelay)) {
    text("animation status: paused",50,30);
  } else if (((ux+abs(x_increment)<ani_ux)&&(lx-abs(x_increment)>ani_lx))&&(!loopDelay)) {
    text("animation status: playing",50,30);
  } else if ((ux+abs(x_increment)>=ani_ux)){ //different status depending on whether you're reached the end of the animation, is paused, or rewinded to the start
    text("animation status: ended",50,30);
  } else if ((lx-5<=ani_lx)){
    text("animation status: starting",50,30);
  }
  text("animation speed:",350,30);
  switch (speedcounter) {
    case 0: 
      text("slow",550,30); //displayed depending on x axis increment speed 
      break;
    case 1:
      text("moderate",550,30);
      break;
    case 2:
      text("fast",550,30);
      break;
    case -1:
      text("rewinding",550,30);
      break;
  }
  
  //toggle menu - refer to ani_ytogdisp and ani_xtogdisp to adjust placement on screen - 
  textFormat(0,0,0,1,1,0); //this is the text and visual display of the rectangle on the right of the canvas with the toggle buttons
  noFill();
  rect(ani_xtogtext-55,ani_ytogtext-100,300,500);
  textFormat(0,0,0,32,1,0);
  text("LEGEND",ani_xtogtext-30,ani_ytogtext-45);
  textFormat(0,0,0,13,1,0);
  text("(CLICK to TOGGLE)",ani_xtogtext+50,ani_ytogtext-25);
  textFormat(0,0,0,15,1,0);
  text("PROPELLER PLANE",ani_xtogtext,ani_ytogtext);
  text("TURBOJET",ani_xtogtext,ani_ytogtext+45);
  text("JET PLANE",ani_xtogtext,ani_ytogtext+90);
  text("BALLOONS",ani_xtogtext,ani_ytogtext+135);
  text("GLIDERS",ani_xtogtext,ani_ytogtext+180);
  text("MOUNTAINEERING [ALTITUDE]",ani_xtogtext,ani_ytogtext+225);
  text("MOUNTAINEERING [SUMMIT]",ani_xtogtext,ani_ytogtext+270);
  text("AIR-LAUNCHED ROCKET PLANE",ani_xtogtext,ani_ytogtext+315);
  text("SPACEFLIGHT",ani_xtogtext,ani_ytogtext+360);
}

void ani_finish() { //menu that gives option to either replay the animation or continue on to the interactive part
  fill(0,0,0,30);
  rect(-5,-5,width+10,height+10);
  fill(200,200,200);
  rect(90,200,width-2*90,160);
  animate_CONTINUE.display();
  animate_REPLAY.display();
  textFormat(255,255,255,50,5,0);
  text("CONTINUE",163,300);
  text("REPLAY",593,300);
}

void ani_end() { //ends animation for navigation onto another page (in this case, intro)
  ani_reset();
  ani_toggle_reset();
  animate = false;
  intro = true;
}

void ani_reset() { //resets all the appropriate variables except for the toggle buttons -  this is attached to the replay button
  temp_uy = 0;
  x_increment = 0.2;
  lx = ani_lx;
  ux = lx+range;
  uy = ani_uy;
  speedcounter = -1;
  ani_speed();
  
  animate_SPEED.resetActive();
  animate_SKIP.resetActive();
  animate_RESTART.resetActive();
  animate_PAUSE.resetActive();
  animate_CONTINUE.resetActive();
  animate_REPLAY.resetActive();
}

void ani_toggle_reset() { //the toggles for the datasets are reset separately 
  ani_propeller.resetActive();
  ani_turbojet.resetActive();
  ani_jetplane.resetActive();
  ani_balloons.resetActive();
  ani_gliders.resetActive();
  ani_mountainAlt.resetActive();
  ani_mountainSum.resetActive();
  ani_airLaunched.resetActive();
  ani_spaceFlight.resetActive();
}

void ani_speed() { //changes rate at which x-axis increments (years)
  speedcounter++;
  x_increment = frameRates[speedcounter];
  if (speedcounter==3) {
    speedcounter = -1;
  }
}

void ani_hover() { //checks for hovering over buttons - however only affects display when button itself is displayed
  if (ani_counter1!=1) {
    ani_propeller.hover();
    ani_turbojet.hover();
    ani_jetplane.hover();
    ani_balloons.hover();
    ani_gliders.hover();
    ani_mountainAlt.hover();
    ani_mountainSum.hover();
    ani_airLaunched.hover();
    ani_spaceFlight.hover();

    animate_PAUSE.hover();
    animate_SPEED.hover();
    animate_RESTART.hover();
    animate_SKIP.hover();
  } else {
    animate_CONTINUE.hover();
    animate_REPLAY.hover();
  }
}