import java.util.*;

char[] keyBinds = { 'a', 's', 'd', 'f', //keybinds for auto hits/misses and teleop hits/misses
                    'j', 'k', 'l', ';'};
boolean[][] keysPressed = new boolean[10][2]; //keeps track of the keys pressed over the last two frames
String[] names = {"HIGH HIT", "HIGH MISS", "LOW HIT", "LOW MISS"};
char undoBind = 'z'; //keybind to remove 1 from the button last updated
char resetBind = '`'; //keybind to reset all buttons to 0
int mostRecentUpdated = -1;

Button resetButton;
Button[] buttons = new Button[8];

color autoColor = color(50, 255, 100);
color teleColor = color(0, 255, 255);

boolean start = false; 

boolean mouseDown = false;
int pressedX, pressedY;

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
  
  resetButton = new Button(width / 2 - 30, height - 45, 60, 40, resetBind, true);
  resetButton.fillColor = color(255, 0, 0);
  resetButton.showBorder = false;
  resetButton.name = "RESET";
  resetButton.showCount = false;
}

void draw(){
  background(220);
  for(int i = 0; i < buttons.length; i++){
    buttons[i].display();
  }
  resetButton.display();
  if(resetButton.getCounter() > 0){
    setup();
  }

  for(int i = 0; i < keysPressed.length; i++){
    if(keysPressed[i][0] && !keysPressed[i][1]){ //key was released
      if(i < keyBinds.length){
        buttons[i].incrementCounter();
        mostRecentUpdated = i;
      }
      if(i == keyBinds.length){
        if(mostRecentUpdated != -1){
          //check if any keys are being pressed other than z
          boolean anyPressed = false;
          for(int j = 0; j < keyBinds.length; j++){
            if(keysPressed[j][0]){
              anyPressed = true;
              break;
            }
          }
          if(!anyPressed) buttons[mostRecentUpdated].decrementCounter();
        }
      }
      if(i == keyBinds.length + 1){
        setup();
      }
    }
  }

  fill(0);
  textSize(50);
  textAlign(CENTER);
  text("AUTONOMOUS PERIOD", width / 2, 35);
  text("TELE-OPERATED PERIOD", width / 2, height / 2 + 20);
  //text("!!!FOCUS WINDOW!!!", 250, height - 10);
  
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

  for(int i = 0; i < keysPressed.length; i++){
    keysPressed[i][1] = keysPressed[i][0];
  }
  if(mostRecentUpdated != -1 && mostRecentUpdated < buttons.length){
    for(int i = 0; i < buttons.length; i++){
      if(i == mostRecentUpdated) continue;
      buttons[i].undoMode = false;
    }
    buttons[mostRecentUpdated].undoMode = true;
  } 
}

void mousePressed(){
  if(!start) return;
  if(!mouseDown){
    mouseDown = true;
    pressedX = mouseX;
    pressedY = mouseY;
  }
}

void mouseReleased(){
  if(!start) return;
  
  for(int i = 0; i < buttons.length; i++){
    if(buttons[i].mouseDown() != 0){
      if(buttons[i].mouseDown() == 1){
        buttons[i].incrementCounter();
      } else {
        buttons[i].decrementCounter();
      }
      
      mostRecentUpdated = i;
      break;
    }
  }
  if(resetButton.mouseDown() != 0){
    resetButton.incrementCounter();
  }
  pressedX = -1;
  pressedY = -1;
  mouseDown = false;
}

void keyPressed(){
  if(!start) return;
  for(int i = 0; i < keysPressed.length; i++){
    if(i < keyBinds.length){
      if(buttons[i].mouseDown() != 0) continue;
      if(key == keyBinds[i]){
        keysPressed[i][0] = true;
      }
    } else {
      if(key == undoBind && !(mousePressed && mouseButton == RIGHT)){
        keysPressed[keyBinds.length][0] = true;
      }
      if(key == resetBind && resetButton.mouseDown() != 0){
        keysPressed[keyBinds.length + 1][0] = true;
      }
    }
  }
}
void keyReleased(){
  if(start != true && key == ' '){
    start = true;
  }
  if(!start) return;
  for(int i = 0; i < keysPressed.length; i++){
    if(i < keyBinds.length){
      if(buttons[i].mouseDown() != 0) continue;
      if(key == keyBinds[i]){
        keysPressed[i][0] = false;
      }
    } else {
      if(key == undoBind && !(mousePressed && mouseButton == RIGHT)){
        keysPressed[i][0] = false;
      }
      if(key == resetBind && resetButton.mouseDown() != 0){
        keysPressed[i][0] = false;
      }
    }
  }
}

/*
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
*/