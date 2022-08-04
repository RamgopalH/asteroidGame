class Gun {
  PVector loc;
  float size;
  float heading;
  color col;
  ArrayList<Bullet> clip = new ArrayList<Bullet>();
  Gun(PVector loc_, float size_) {
    loc = loc_;
    size = size_;
    heading = 0;
    col = color(0, 0, 255);
  }
  Gun(PVector loc_, float size_, ArrayList<Bullet> clip_) {
    loc = loc_;
    size = size_;
    heading = 0;
    col = color(0, 0, 255);
    clip = clip_;
  }
  void display() {
    rectMode(CENTER);
    fill(col);
    rect(loc.x, loc.y, size/2, size);
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, 4, 4);
    fill(#F5EA19, 75);
    rect(loc.x+0, loc.y+size/2+0, size/2, size/2);
  }
  void dispBullets() {
    for (Iterator<Bullet> it = clip.iterator(); it.hasNext(); ) {
      Bullet b = it.next();
      boolean hit = false;
      b.run();
      if (bossSpawned && !paused) {
        if(boss.intersects(b)) {
          boss.hit(b);
          hit = true;
        }
      } else if(!gameOver && !paused){
        for (Iterator<Asteroid> it2 = system.asteroids.iterator(); it2.hasNext(); ) {
          Asteroid a = it2.next();
          if (a.intersect(b)) {
            a.hit(b);
            if(a.isDead()) {
              it2.remove();
              system.count--;
              ship.score.increase(POINTSPERHIT);
            }
            hit = true;
          }
        }
      }
      if (b.outOfBounds()||hit)it.remove();
    }
  }
  void addBullet(PVector loc_, PVector direction) {
    clip.add(new Bullet(loc_, direction));
  }
}

class FastGun extends Gun {
  FastGun(PVector loc_, float size_, ArrayList<Bullet> clip_) {
    super(loc_, size_, clip_);
    col = color(255, 0, 0, 80);
  }
  void addBullet(PVector loc_, PVector direction) {
    clip.add(new FastBullet(loc_, direction));
  }
}

class ExplodingGun extends Gun {
  ExplodingGun(PVector loc_, float size_, ArrayList<Bullet> clip_) {
    super(loc_, size_, clip_);
    col = color(255, 255, 0, 80);
  }
  void addBullet(PVector loc_, PVector direction) {
    ExplodingBullet b = new ExplodingBullet(loc_, direction, this);
    clip.add(b);
    for(int i=0;i<6;i++) {
      clip.add(b.shards[i]);
    }
  }
}

class EmptyGun extends Gun {
  EmptyGun(PVector loc_, float size_, ArrayList<Bullet> clip_) {
    super(loc_, size_, clip_);
    col = color(255, 0);
  }
  void addBullet(PVector loc_, PVector direction) {
    return;
  }
  void display() {
    return;
  }
}
