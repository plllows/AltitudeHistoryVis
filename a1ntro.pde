//this is the intro screen

boolean intro = true;
Button intro_PLAY;

void intro() {
  intro_hover();
  background(0);
  intro_UI();
}
//intro_PLAY = new Button(350,325,125,125);
//void textFormat(int PR,int PG, int PB, int tSize, int sWeight);

//basic text and a button for continuing onto the animation page
void intro_UI() {
  textFormat(200,200,200,1,0);
  rect(-10,327,width+20,165);
  textFormat(255,255,255,28,5);
  text("Two centuries ago, we took flight in the first hot-air balloon.\nA hundred years later, we flew the first propeller aircraft.\nFifty years ago, our kind reached outer space.\nNow, we aim even higher.",85,125);
  intro_PLAY.display();
  textFormat(255,255,255,50,5);
  if (intro_PLAY.getActive()) {text("active is true",125,400);} else {text("BEGIN ANIMATION",105,424);}
}

void intro_hover() { //buttons display differently depending on whether your mouse is over it
  intro_PLAY.hover(); 
}

void intro_end() {//transition into animation page
  intro=false;
  intro_PLAY.resetActive();
  animate = true; 
  ani_speed(); //this initialises the speed of the x axis incrementation
}