class Button{
  private int x, y, w, h, counter;
  private String name = "";
  private char inKey;
  final int pressOffset = 40;
  int textSize, rounding, lastUpdate;
  color fillColor = teleColor;
  color textColor = color(0);
  boolean helpMode, undoMode, showCount, showBorder;
  
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
  }
  
  public void setName(String name){
    this.name = name;
  }

  public int mouseDown(){
    if(!mouseDown) return 0;
    if(pressedX > x && pressedX < x + w && pressedY > y && pressedY < y + h){
      if(mouseButton == LEFT) return 1;
      if(mouseButton == RIGHT) return 2;
    } 
    return 0;
  }

  public int kbPressed(){
    for(int i = 0; i < keysPressed.length; i++){
      if(i < keyBinds.length){
        if(keyBinds[i] == inKey && keysPressed[i][0]) return 1;
      }
      if(i == keyBinds.length + 1 && keysPressed[i][0]) return 1;
    }
    if(keyPressed && key == 'z' && undoMode) return 2;
    return 0;
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
    
    if(mouseDown() == 1 || kbPressed() == 1){ //overlays gray cover to shade button
      fill(255, 255, 255, 120);
      rect(x, y, w, h, rounding);
    } else if(mouseDown() == 2 || kbPressed() == 2){ //overlays red cover to shade button
      fill(255, 0, 0, 120);
      rect(x, y, w, h, rounding);
    }
  }

  private void updateCounter(int x){
    counter = max(0, counter + x);
    lastUpdate = millis();
  }

  public void incrementCounter(){
    updateCounter(1);
  }

  public void decrementCounter(){
    updateCounter(-1);
  }
  
  public int getCounter(){
    return counter;
  }
  
  public int getLastUpdated(){
    return lastUpdate;
  }
  
  public char getKey(){
    return inKey;
  }
}
