char[] keyBinds = { 'a', 's', 'd', 'f', //keybinds for auto hits/misses and teleop hits/misses
                    'j', 'k', 'l', ';'};
String[] names = {"HIGH HIT", "HIGH MISS", "LOW HIT", "LOW MISS"};
char mostRecentUpdatedBind = 'z'; //keybind to remove 1 from the button last updated
int mostRecentUpdated = -1;
int mostRecentTime = 0;

Button resetButton;
Button[] buttons = new Button[8];

color autoColor = color(50, 255, 100);
color teleColor = color(0, 255, 255);

boolean start = false; //To prevent the kb's inputs from not registering

void setup(){
  //fullScreen();
  size(1200, 800);
  frameRate(240);
  
  int padding = 45;
  int x = padding;
  int y = padding;
  int w = (width - 5 * padding) / 4;
  int h = (height - 3 * padding) / 2;
  for(int i = 0; i < buttons.length; i++){
    if(i == 4){
      x = padding;
      y += h + padding;
    }
    buttons[i] = new Button(x, y, w, h, keyBinds[i], true);
    buttons[i].setName(names[i % 4]);
    if(i < 4) buttons[i].fillColor = autoColor;
    x += w + padding;
  }
  
  resetButton = new Button(width / 2 - 30, height - 45, 60, 40, '`', true);
  resetButton.fillColor = color(255, 0, 0);
  resetButton.showBorder = false;
  resetButton.name = "RESET";
  resetButton.showCount = false;
  /*
  test = new Button(100, 100, 300, 300, 'a');
  test.setName("TEST");
  */
}

void draw(){
  background(220);
  for(int i = 0; i < buttons.length; i++){
    if(buttons[i].getLastUpdated() > mostRecentTime){
      mostRecentUpdated = i;
      mostRecentTime = buttons[i].getLastUpdated();
    }
    if(start){
      buttons[i].disCheckAll();
    } else {
      buttons[i].display();
    }
  }
  if(start){
    resetButton.disCheckAll();
  }
  
  if(resetButton.getCounter() > 0){
    setup();
  }
  
  fill(0);
  textSize(50);
  textAlign(CENTER);
  text("AUTONOMOUS PERIOD", width / 2, 35);
  text("TELE-OPERATED PERIOD", width / 2, height / 2 + 20);
  text("!!!FOCUS WINDOW!!!", 250, height - 10);
  /*
  test.display();
  test.checkPress();
  test.checkKBPress();*/
  
  
  
  if(!start){
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
    fill(255);
    textSize(140);
    textAlign(CENTER);
    text("Press SPACE to start", width / 2, height / 2 );
  }
  
  fill(255, 0, 0);
  textSize(20);
  textAlign(RIGHT);
  text(frameRate, width - 5, height - 5);
}

void keyReleased(){
  //println(key + " " + frameCount);
  if(!start && key == ' ') start = true;
  if(key == mostRecentUpdatedBind){
    buttons[mostRecentUpdated].decrementCounter();
  }
  for(int i = 0; i < buttons.length; i++){
    if(buttons[i].getKey() == key){
      buttons[i].incrementCounter();
      buttons[i].lastUpdate = millis();
    }
  }
  if(resetButton.getKey() == key) resetButton.incrementCounter();
}
