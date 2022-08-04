class Digit {
  boolean a, b, c, d, e, f, g;
  PVector loc;
  int value;
  Digit(PVector loc_) {
    a=b=c=d=e=f=true;
    g=false;
    loc = loc_;
    value = 0;
    setDigit();
  }
  void disp() {
    pushMatrix();
    translate(loc.x, loc.y);
    point(0,0);
    stroke(255);
    if(a) line(0, -10, 10, -10);
    if(b) line(10, -10, 10, 0);
    if(c) line(10, 0, 10, 10);
    if(d) line(10, 10, 0, 10);
    if(e) line(0, 10, 0, 0);
    if(f) line(0, 0, 0, -10);
    if(g) line(0, 0, 10, 0);
    popMatrix();
  }
  boolean incr() {
    value++;
    value%=10;
    setDigit();
    if(value==0) return true;
    else return false;
  }
  boolean decr() {
    value--;
    if(value==-1) value = 9;
    setDigit();
    if(value==9) return true;
    else return false;
  }
  void setDigit() {
    switch(value) {
      case 1: {
        b=c=true;a=d=e=f=g=false;
        break;
      } case 2: {
        a=b=d=e=g=true;c=f=false;
        break;
      } case 3: {
        a=b=c=d=g=true;e=f=false;
        break;
      } case 4: {
        b=c=f=g=true;a=d=e=false;
        break;
      } case 5: {
        a=c=d=f=g=true;b=e=false;
        break;
      } case 6: {
        a=c=d=e=f=g=true;b=false;
        break;
      } case 7: {
        a=b=c=true;d=e=f=g=false;
        break;
      } case 8: {
        a=b=c=d=e=f=g=true;
        break;
      } case 9: {
        a=b=c=d=f=g=true;e=false;
        break;
      } default: {
        a=b=c=d=e=f=true;g=false;
        break;
      }
    }
  }
}
