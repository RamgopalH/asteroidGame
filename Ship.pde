class Ship {
  PVector loc;
  PVector velocity;
  PVector acceleration;
  float heading;
  float angularVelocity;
  float size;
  Score score;
  Gun l, r;
  HitBox hitBox;
  DigitDisplay ammo;
  int bullet;
  Ship(PVector loc_, float size_) {
    loc = loc_;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    heading = 0;
    angularVelocity = 0;
    size = size_;
    l = new Gun(new PVector(-size/2, 0), size);
    r = new Gun(new PVector(size/2, 0), size);
    hitBox = new HitBox(loc, size);
    score = new Score(new PVector(50, 50), 4);
    ammo = new DigitDisplay(new PVector(50, 100), 4, 100);
    bullet = 1;
  }

  void display() {
    pushMatrix();
    //bounce();
    rollOver();
    translate(loc.x, loc.y);
    rotate(radians(heading));
    l.display();
    r.display();
    fill(255, 80);
    triangle(0, -size, size, size/2, -size, size/2);
    fill(0, 255, 0);
    ellipse(0, 0, 4, 4);
    popMatrix();
    l.dispBullets();
    r.dispBullets();
    hitBox.display();
    score.display();
  }
  void fire() { //<>//
    l.addBullet(PVector.add(loc, l.loc), PVector.fromAngle(radians(heading-90))); //<>//
    r.addBullet(PVector.add(loc, r.loc), PVector.fromAngle(radians(heading-90))); //<>//
  }
  void update() {
    velocity.add(acceleration);
    loc.add(velocity);
    PVector target = PVector.sub(new PVector(mouseX, mouseY), loc).normalize();
    heading = degrees(target.heading())+90;
    acceleration.mult(0);
    velocity.mult(0.99);
    hitBox.update(loc);
  }
  void run() {
    if (!paused && !gameOver) update();
    display();
  }
  void reset() {
    loc = new PVector(width/2, height-50);
    velocity.mult(0);
    heading = 0;
  }
  void rotateLeft() {
    heading+=10;println(loc.heading()*180/PI);
  }
  void rotateRight() {
    heading-=10;
    println(loc.heading()*180/PI);
  }
  void moveForward() {
    //acceleration = PVector.fromAngle(radians(heading-90)).mult(0.5);
    acceleration.add(new PVector(0, -MAXACC));
  }
  void moveBackward() {
    //acceleration.add(PVector.fromAngle(radians(heading-90)).mult(-0.5));
    acceleration.add(new PVector(0, MAXACC));
  }
  void moveLeft() {
    acceleration.add(new PVector(-MAXACC, 0));
  }
  void moveRight() {
    acceleration.add(new PVector(MAXACC, 0));
  }
  void bounce() {
    if(loc.x>width || loc.x<0) velocity.x *= -0.5;
    if(loc.y>height || loc.y<0) velocity.y *= -0.5;
    loc = new PVector(constrain(loc.x, 0, width) , constrain(loc.y, 0, height));
  }
  void rollOver() {
    if(loc.x>width) loc.x = 0;
    if(loc.y>height) loc.y = 0;
    if(loc.x<0) loc.x = width;
    if(loc.y<0) loc.y = height;
  }
  boolean hasHit(Asteroid a) {
    return hitBox.intersects(a);
  }
  void changeGun(int x) {
    switch(x) {
      case 1:
        l = new Gun(new PVector(-size/2, 0), size, l.clip);
        r = new Gun(new PVector(size/2, 0), size, r.clip);
        bullet = 1;
        break;
      case 2:
        l = new FastGun(new PVector(-size/2, 0), size, l.clip);
        r = new FastGun(new PVector(size/2, 0), size, r.clip);
        bullet = 2;
        break;
       case 3:
        l = new ExplodingGun(new PVector(-0, -size/2), size, l.clip);
        r = new EmptyGun(new PVector(size/2, 0), size, r.clip);
        bullet = 3;
        break;
    }
  }
}
