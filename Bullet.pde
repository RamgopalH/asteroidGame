class Bullet {
  float size = SCALE/2, speed = MAXVELOCITY*2, r;
  PVector loc, velocity;
  int damage;
  boolean visible = true;
  Bullet(PVector loc_, PVector direction) {
    loc = loc_;
    velocity = PVector.mult(direction, speed);
    r = size/2;
    speed = MAXVELOCITY*2;
    visible = true;
    damage = 30;
  }
  void display() {
    fill(0, 255, 0, 50); stroke(0);
    ellipse(loc.x, loc.y, size, size);
    stroke(255);
  }
  void update() {
    loc.add(velocity);
  }
  void run() {
    if (!visible) return;
    update();
    display();
  }
  boolean outOfBounds() {
    if (loc.y>height || loc.y<0 || loc.x<0 || loc.x>width) return true;
    else return false;
  }
}

class FastBullet extends Bullet {
  FastBullet(PVector loc_, PVector direction) {
    super(loc_, direction);
    velocity.mult(2);
    damage = 20;
  }
}

class ExplodingBullet extends Bullet {
  Bullet[] shards;
  Gun parent;
  int countdown = 100;
  boolean exploded = false;
  ExplodingBullet(PVector loc_, PVector direction, Gun parent_) {
    super(loc_, direction);
    velocity.mult(0.75);
    parent = parent_;
    shards = new Bullet[6];
    damage = 60;
    for (int i=0; i<6; i++) {
      shards[i] = new WeakBullet(PVector.add(loc, PVector.mult(velocity, countdown)), PVector.fromAngle(radians(i*60)));
      shards[i].visible = false;
    }
  }
  void update() {
    loc.add(velocity);
    countdown--;
    if (countdown == 0) {
      explode();
    }
  }
  void explode() {
    exploded = true;
    for (int i=0; i<6; i++) {
      shards[i].visible = true;
    }
    loc = new PVector(-1, -1);
  }
}

class WeakBullet extends Bullet{
  WeakBullet(PVector loc_, PVector direction) {
    super(loc_, direction);
    visible = false;
    damage = 10;
  }
}
