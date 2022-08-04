class DigitDisplay {
  PVector loc;
  Digit[] digits;
  int d;
  int counterVariable;
  boolean visible = true;
  DigitDisplay(PVector loc_, int d_, int start) {
    counterVariable = 0;
    loc = loc_;
    d = d_;
    digits = new Digit[d];
    for (int i=0; i<d; i++) {
      int j=i-1;
      digits[i] = new Digit(PVector.add(loc, new PVector(20*j, 0)));
    }
    increase(start);
  }
  DigitDisplay(PVector loc_, int d_) {
    counterVariable = 0;
    loc = loc_;
    d = d_;
    digits = new Digit[d];
    for (int i=0; i<d; i++) {
      int j=i-1;
      digits[i] = new Digit(PVector.add(loc, new PVector(20*j, 0)));
    }
  }
  void display() {
    if(!visible) return;
    for (int i=0; i<d; i++) {
      digits[i].disp();
    }
  }
  void incr() {
    counterVariable++;
    incr(d-1);
  }
  void incr(int i) {
    if (i==-1) return;
    if (digits[i].incr()) {
      incr(i-1);
    }
  }
  void decr() {
    counterVariable--;
    if (counterVariable==0) {
      digits[d-1].decr();
    } else {
      decr(d-1);
    }
  }
  void decr(int i) {
    if (i==-1) return;
    if (digits[i].decr()) {
      decr(d-1);
    }
  }
  void increase(int x) {
    for(int i=0;i<x;i++) incr();
  }
  void subtract(int x) {
    for(int i=0;i<x;i++) decr();
  }
  int value() {
    return counterVariable;
  }
  void toggleVisibility() {
    visible = !visible;
  }
}

class Score  extends DigitDisplay {
  Score(PVector loc_, int d_) {
    super(loc_, d_);
  }
  void incr() {
    counterVariable++;
    incr(d-1);
  }
}

class HealthBar extends DigitDisplay {
  int health;
  boolean dead;
  float factor;
  HealthBar(PVector loc_, int d_, int health_) {
    super(loc_, d_, health_);
    health = health_;
    factor = 100/health_;
  }
  void update(PVector location, float size) {
    loc = PVector.add(location, new PVector(0,-size-10));
  }
  void display() {
    if(dead) return;
    rectMode(CENTER);
    fill(255, 40);
    rect(loc.x, loc.y, 100, 20);
    rectMode(CORNER);
    fill(255, 0, 0, 80);
    rect(loc.x-50, loc.y-10, map(counterVariable, 0, health, 0, 100), 20); 
  }
  void decr() {
    counterVariable--;
    if (counterVariable<=0) {
      digits[d-1].decr();
      visible = false;
      dead = true;
    } else {
      decr(d-1);
    }
  }
}
