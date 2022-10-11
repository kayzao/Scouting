import java.util.*;

char[] keyBinds = { 'a', 's', 'd', 'f', //keybinds for auto hits/misses and teleop hits/misses
                    'j', 'k', 'l', ';'};

Hashtable<Character, Boolean> keys = new Hashtable<Character, Boolean>(10); //To prevent unread inputs and other bugs. First 8 match with keyBinds[], then undoBind, then resetBind
Hashtable<Character, Boolean> prevKeys = new Hashtable<Character, Boolean>(10); //to keep track of the key presses from the last frame
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

  for(int i = 0; i < 10; i++){
    if(i < keyBinds.length){
      keys.put(keyBinds[i], false);
    } else {
      if(i == keyBinds.length){
        keys.put(undoBind, false);
      } else {
        keys.put(resetBind, false);
      }
    }
  }
  prevKeys = new Hashtable<Character, Boolean>(keys);
  
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
  
  Enumeration<Character> keysEnum = keys.keys();
  Enumeration<Character> prevKeysEnum = prevKeys.keys(); 
  while(keysEnum.hasMoreElements()){
    char k = keysEnum.nextElement();
    char pk = prevKeysEnum.nextElement();
    println(k + " " + pk);
    if(!keys.get(k) && keys.get(k) != prevKeys.get(pk)){
      for(int i = 0; i < buttons.length; i++){
        if(buttons[i].inKey == k){
          if(k == undoBind){
            buttons[mostRecentUpdated].decrementCounter();
            mostRecentUpdated = -1;
          } else {
            buttons[i].incrementCounter();
            mostRecentUpdated = i;
          }
        }
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

  prevKeys = new Hashtable<Character, Boolean>(keys);
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
      buttons[i].undoMode = true;
      if(mostRecentUpdated != -1 && mostRecentUpdated != i) buttons[mostRecentUpdated].undoMode = false;
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
  for(int i = 0; i < keys.size(); i++){
    if(i < keyBinds.length){
      if(key == keyBinds[i]){
        keys.replace(keyBinds[i], true);
      }
    }
    if(key == undoBind){
      keys.replace(undoBind, true);
    }
    if(key == resetBind){
      keys.replace(resetBind, true);
    }
  }
}
void keyReleased(){
  if(start != true && key == ' '){
    start = true;
  }
  if(!start) return;
  for(int i = 0; i < keys.size(); i++){
    if(i < keyBinds.length){
      if(key == keyBinds[i]){
        keys.replace(keyBinds[i], false);
      }
    }
    if(key == undoBind){
      keys.replace(undoBind, false);
    }
    if(key == resetBind){
      keys.replace(resetBind, false);
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