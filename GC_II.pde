//int mousepresses = 0; //This variable was used during creation of buttons to see if they were working or not
int datasetCount = 9; //the number of sets of data I've got
Data p_p;
Data p_alr;
Data p_j;
Data bloon;
Data gli;
Data mtnA;
Data mtnS;
Data spcfl;
Data tj;

Data[] collection_data = new Data[datasetCount];
boolean[] dataSwitch = new boolean[datasetCount]; //an array of booleans to enable users to toggle on and off different sets of data on the graph

void setup() {
  size(1000,600);
  background(255);
  frameRate(120);
  initialise_data(); 
  initialise_collection_data();
  ia_initialise();
  initialise_frameRates();
  initialise_buttons();
  long a = 54600000000L;
  ia_spcfl_2024.setAltitude(a);
}

void draw() {
  if (intro) {
    intro(); //booleans used to navigate the two main pages - 'intro' and 'animation'
  } else if (animate) {
    animate(); 
  }  else {
    background(75,0,155); //if the program functions as intended, this 'crash' screen should never be displayed
  }
  //println(ia_mtnS_1930.getAltitude());
  //println(ia_mtnS_1930.getDescription());
  //println(ia_mtnS_1931.getAltitude());   -glitch with 1931 altitude - turns out number formatting in excel was wrong
  //println(ia_mtnS_1931.getDescription());
  //println(ia_mtnS_1936.getAltitude());
  //println(ia_mtnS_1936.getDescription());
  //println(ia_spcfl_1998.getAltitude());
  //println(ia_spcfl_1998.getDescription());
  //println(ia_spcfl_2024.getAltitude());
  //println(ia_spcfl_2024.getDescription());
  //noLoop();
}

void mousePressed() {
  //mousepresses++;
  
  if (intro) { //toggles the press function for only the buttons that the users should be able to interact with at a given time
    intro_PLAY.press();
    if (intro_PLAY.getActive()) {
      intro_end();
    }
  } else if (animate) {
    if (ani_counter1!=1) {
      animate_PAUSE.press();
      animate_SPEED.press();
      animate_RESTART.press();
      animate_SKIP.press();
      
      ani_propeller.press();
      ani_turbojet.press();
      ani_jetplane.press();
      ani_balloons.press();
      ani_gliders.press();
      ani_mountainAlt.press();
      ani_mountainSum.press();
      ani_airLaunched.press();
      ani_spaceFlight.press();
      
      toggle_check(); //this checks whether any of the dataselect buttons have been pressed, and if any data sets should be turned on or off
      
      if (animate_PAUSE.getActive()) { //if any buttons are in their 'active' stage, does relevant actions
        loopDelay = !loopDelay;
        animate_PAUSE.resetActive();
      }
      if (animate_SPEED.getActive()) {
        ani_speed();
        animate_SPEED.resetActive();
      }
      if (animate_RESTART.getActive()) {
        ani_reset();
      }
      if (animate_SKIP.getActive()) {
        ani_end();
        //textFormat(0,0,0,70,1,0);
        //text("You are dead now",50,150);
        //noLoop();
      }
    } else {
      animate_CONTINUE.press();
      animate_REPLAY.press();
      if (animate_CONTINUE.getActive()) {
        ani_counter1++;        //ani_counter1 tracks whether the replay_continue menu should be displayed at the end of the animation (only display for first ending)
      }
      if (animate_REPLAY.getActive()) {
        ani_reset();
        ani_counter1++;  
      }
    }
  }
}

void toggle_check() {
  if (!ani_propeller.getActive()) {
    dataSwitch[0] = false;
  } else {
    dataSwitch[0] = true;
  }
  if (!ani_turbojet.getActive()) {
    dataSwitch[1] = false;
  } else {
    dataSwitch[1] = true;
  }
  if (!ani_jetplane.getActive()) {
    dataSwitch[2] = false;
  } else {
    dataSwitch[2] = true;
  }
  if (!ani_balloons.getActive()) {
    dataSwitch[3] = false;
  } else {
    dataSwitch[3] = true;
  }
  if (!ani_gliders.getActive()) {
    dataSwitch[4] = false;
  } else {
    dataSwitch[4] = true;
  }
  if (!ani_mountainAlt.getActive()) {
    dataSwitch[5] = false;
  } else {
    dataSwitch[5] = true;
  }
  if (!ani_mountainSum.getActive()) {
    dataSwitch[6] = false;
  } else {
    dataSwitch[6] = true;
  }
  if (!ani_airLaunched.getActive()) {
    dataSwitch[7] = false;
  } else {
    dataSwitch[7] = true;
  }
  if (!ani_spaceFlight.getActive()) {
    dataSwitch[8] = false;
  } else {
    dataSwitch[8] = true;
  }
}

void initialise_data() {
  p_p = new Data("p_p.csv");
  p_alr = new Data("p_alr.csv");
  p_j = new Data("p_j.csv");
  bloon = new Data("bloon.csv");
  gli = new Data("gli.csv");
  mtnS = new Data("mtnS.csv");
  mtnA = new Data("mtnA.csv");
  spcfl = new Data("spcfl.csv");
  tj = new Data("tj.csv");
}

void initialise_collection_data() {
  for (int i=0;i<datasetCount;i++) {
    dataSwitch[i] = true;  //used to toggle on and off datasets
  }
  //used to plot data in animate
  collection_data[0] = p_p; //propeller
  collection_data[1] = tj;  //turbojet
  collection_data[2] = p_j; // jetplane
  collection_data[3] = bloon; //balloons
  collection_data[4] = gli; //gliders
  collection_data[5] = mtnA; //mountain dew
  collection_data[6] = mtnS; //mountain dew
  collection_data[7] = p_alr; //air launched CHEAT plane
  collection_data[8] = spcfl; //polen can into space
}

void initialise_frameRates() { //these are used to increment the x axis of the graph - I've selected numbers that divide evenly into 1 for sake of smoothness
  frameRates = new float[4]; //I used this instead of frameRate() so I can keep the buttons really responsive and still adjust hte speed of the graph animation
  frameRates[0] = 0.05;
  frameRates[1] = 0.1;
  frameRates[2] = 0.2;
  frameRates[3] = -0.1;
}

int ani_xtogdisp = 0; //this bottom section is related to the initialisation of the buttons to toggle on and off datasets in the graph
int ani_ytogdisp = 22;
int ani_xtoggle = 715 + ani_xtogdisp;
int ani_ytoggle = 90 + ani_ytogdisp;
int ani_xtogtext = 740 + ani_xtogdisp;
int ani_ytogtext = 95 + ani_ytogdisp;

void initialise_buttons() {
  //various buttons
  intro_PLAY = new Button(680,408,100,100);
  
  //tried to use push & pop matrix to change button locations but didnt work as expected
  ani_propeller = new Button(ani_xtoggle,ani_ytoggle,25,25,1,1,255,0,0,255,220,220);
  ani_turbojet = new Button(ani_xtoggle,ani_ytoggle+45,25,25,1,1,255,155,0,255,245,220);
  ani_jetplane = new Button(ani_xtoggle,ani_ytoggle+90,25,25,1,1,255,255,0,255,255,220);
  ani_balloons = new Button(ani_xtoggle,ani_ytoggle+135,25,25,1,1,0,255,0,220,255,220);
  ani_gliders = new Button(ani_xtoggle,ani_ytoggle+180,25,25,1,1,0,0,255,220,220,255);
  ani_mountainAlt = new Button(ani_xtoggle,ani_ytoggle+225,25,25,1,1,255,0,255,255,220,255);
  ani_mountainSum = new Button(ani_xtoggle,ani_ytoggle+270,25,25,1,1,200,0,200,245,220,245);
  ani_airLaunched = new Button(ani_xtoggle,ani_ytoggle+315,25,25,1,1,155,155,155,200,200,200);
  ani_spaceFlight = new Button(ani_xtoggle,ani_ytoggle+360,25,25,1,1,30,30,30,175,175,175);
  
  animate_PAUSE = new Button(135,568,268,50,0,0,0,0,0,255,100,100);
  animate_SPEED = new Button(405,568,268,50,0,0,0,0,0,255,100,100);
  animate_RESTART = new Button(675,568,268,50,0,0,0,0,0,255,100,100);
  animate_SKIP = new Button(905,568,188,50,0,0,0,0,0,255,100,100);
  
  animate_CONTINUE = new Button (295,280,406,156,0,0,0,0,0,255,100,100);
  animate_REPLAY = new Button (705,280,406,156,0,0,0,0,0,255,100,100);
}

void textFormat(int PR,int PG, int PB, int tSize, int sWeight) { //some functions I wrote for convenience for easy text formatting
  fill(PR,PG,PB);
  textSize(tSize);
  strokeWeight(sWeight);
  stroke(1);
}

void textFormat(int PR,int PG, int PB, int tSize, int sWeight, int S) {
  fill(PR,PG,PB);
  textSize(tSize);
  strokeWeight(sWeight);
  stroke(S);
}