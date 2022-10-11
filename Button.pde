class Button{
  private int x, y, w, h, counter, mButton;
  private String name = "";
  private char inKey;
  final int pressOffset = 40;
  int textSize, rounding, lastUpdate;
  color fillColor = teleColor;
  color textColor = color(0);
  boolean isPressed, kbPressed, helpMode, showCount, showBorder;
  
  public Button(int x, int y, int w, int h, char inKey, boolean enableHelp){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    counter = 0;
    this.inKey = inKey;
    textSize = int(w / 4.5);
    lastUpdate = millis();
    helpMode = enableHelp;
    showCount = true;
    showBorder = true;
    kbPressed = false;
  }
  
  public void setName(String name){
    this.name = name;
  }
  
  public void disCheckAll(){
    checkPress();
    //checkKBPress();
    display();
    
  }
  
  public void display(){
    rectMode(CORNER);
    if(showBorder){
      strokeWeight(3);
      stroke(255);
    } else {
      noStroke();
    }
    
    fill(fillColor);
    rect(x, y, w, h, rounding);
    fill(textColor);
    textSize(textSize);
    if(showCount){
      textAlign(RIGHT);
      text(counter, x + (w * 0.9), y + (h * 0.9));
    }
    textAlign(CENTER);
    text(name, x + 0.5 * w, y + 0.25 * h);
    fill(255, 100, 100);
    text(inKey, x + 0.5 * w, y + 0.5 * h);
    textAlign(LEFT);
    
    
    if(isPressed || kbPressed){
      fill(255, 255, 255, 120);
      rect(x, y, w, h, rounding);
    }
  }
  
  public void checkPress(){
    if(mousePressed && (mouseX > x && mouseX < x + w) && (mouseY > y && mouseY < y + h)){
      if(!isPressed) isPressed = true;
      if(mouseButton == LEFT){
        mButton = 1;
      } else if(mouseButton == RIGHT){
        mButton = 2;
      }
    } else {
      if(isPressed){
        isPressed = false;
        if(mButton != 0){
          if(mButton == 1) counter++;
          if(mButton == 2) counter = max(0, --counter);
        } else {
          counter++;
        }
        mButton = 0;
        lastUpdate = millis();
      }
    }
  }
  
  public void checkKBPress(){
    //println(isPressed);
    if(keyPressed){
      //println(key + " " + frameCount + " " + isPressed);
      if(!kbPressed && key == inKey){
        kbPressed = true;
      }
    } else {
      if(kbPressed){
        kbPressed = false;
        counter++;
        lastUpdate = millis();
      }
    }
  }
  
  public int getCounter(){
    return counter;
  }
  
  public void decrementCounter(){
    counter = max(0, --counter);
  }
  
  public void incrementCounter(){
    counter++;
  }
  
  public int getLastUpdated(){
    return lastUpdate;
  }
  
  public char getKey(){
    return inKey;
  }
}
