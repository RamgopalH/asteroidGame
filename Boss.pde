class Boss {
  PVector loc, velocity, acceleration;
  int health;
  float size, r, maxVelocity;
  color col;
  boolean attacking = false;
  HealthBar healthBar;
  HitBox hitBox;
  boolean evolved = false;
  Boss(PVector loc_, int health_, float size_, float maxVelocity_) {
    loc = loc_;
    size = size_;
    r = size/2;
    health = health_;
    maxVelocity = maxVelocity_;
    velocity = PVector.random2D().mult(random(-6, 6));
    acceleration = PVector.random2D().mult(random(-0.1, 0.1));
    healthBar = new HealthBar(PVector.add(loc, new PVector(0, -size-10)), 4, health_);
    hitBox =  new HitBox(loc, size);
    col = color(255, 0, 255);
  }
  Boss() {
  }
  Boss(int health_, float size_) {
    health = health_;
    loc = new PVector(random(0, width), random(0, height-2*SCALE));
    size = size_;
    r = size_/2;
    maxVelocity = MAXVELOCITY*80/size;
    velocity = PVector.random2D().mult(random(-6, 6));
    acceleration = PVector.random2D().mult(random(-0.1, 0.1));
    healthBar = new HealthBar(PVector.add(loc, new PVector(0, -size-10)), 4, health_);
    hitBox =  new HitBox(loc, size);
    col = color(255);
  }
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxVelocity);
    loc.add(velocity);
    healthBar.update(loc, size);
    hitBox.update(loc);
  }
  void display() {
    if (healthBar.dead) return;
    rollOver();
    //bounce();
    fill(col);
    ellipse(loc.x, loc.y, size, size);
    healthBar.display();
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
  void run() {
    if (dead()) return;
    if (!gameOver && !paused) {
      if (frameCount%200==0)
        makeMove();
      update();
    }
    display();
  }
  void hit(Bullet b) {
    if(gameOver || paused) return;
    healthBar.subtract(b.damage);
  }
  void makeMove() {
    float choice = random(0, 1);
    if (choice<0.4) charge(ship.loc);
    else if (choice<0.65) acceleration = new PVector(random(-width, width), random(-height, height)).mult(0.1);
    else if (choice<0.90) charge(new PVector(random(0, width), random(0, height)));
    else velocity.mult(0);
  }
  void charge(PVector target) {
    velocity.mult(0);
    acceleration =  PVector.sub(target, loc).normalize().mult(0.1);
  }
  boolean intersects(Bullet b) {
    if (!b.visible) return false;
    float d = dist(loc.x, loc.y, b.loc.x, b.loc.y) -r - b.r;
    if (d>0) {
      return false;
    } else return true;
  }
  boolean killed(Ship s) {
    return hitBox.intersects(ship.hitBox);
  }
  boolean dead() {
    return healthBar.dead;
  }
  boolean alive() {
    return !healthBar.dead;
  }
  void evolve() {
    if (evolved) return;
    healthBar = new HealthBar(PVector.add(loc, new PVector(0, -size-10)), 4, 3*health/2);
    hitBox =  new HitBox(loc, size);
    size*=1.25;
    maxVelocity*=1.25;
    evolved = true;
  }
}

class OAS extends Boss {
  Boss  Ornstein;
  Boss Smough;
  OAS(PVector loc_, int health_, float size_, float maxVelocity_) {
    super();
    Ornstein = new Boss(new PVector(random(0, width), random(0, height-2*SCALE)), 3*health_/4, size_*0.75, maxVelocity_*2);
    Ornstein.col = color(#D8FF03);
    Smough = new Boss(new PVector(random(0, width), random(0, height-2*SCALE)), 5*health_/3, size_*1.5, maxVelocity_*0.75);
    Smough.col = color(#798921);
  }

  void update() {
    Ornstein.update();
    Smough.update();
  }
  void display() {
    Ornstein.display();
    Smough.display();
  }
  void run() {
    Ornstein.run();
    Smough.run();
    if (Smough.dead()) Ornstein.evolve();
    else if (Ornstein.dead())Smough.evolve();
  }
  boolean intersects(Bullet b) {
    return (Ornstein.intersects(b) && Ornstein.alive() || Smough.intersects(b) && Smough.alive());
  }
  void hit(Bullet b) {
    if (Ornstein.intersects(b)) Ornstein.hit(b);
    else if (Smough.intersects(b)) Smough.hit(b);
  }
  boolean killed(Ship s) {
    return (Ornstein.killed(s)&&!Ornstein.dead() || Smough.killed(s)&&!Smough.dead());
  }
  boolean dead() {
    return (Ornstein.dead() && Smough.dead());
  }
}

class Spawner extends Boss {
  ArrayList<Boss> spawns;
  Spawner(PVector loc_, int health_, float size_, float maxVelocity_) {
    super(loc_, health_, size_, 1);
    col =  color(#212389);
    spawns = new ArrayList<Boss>();
    spawns.add(new Boss(health/2, random(20, size)));
  }
  void run() {
    if(dead()) return;
    for(Iterator<Boss> it = spawns.iterator();it.hasNext();) {
      Boss b = it.next();
      if(b.dead()) it.remove();
      else b.run();
    }
    if(healthBar.dead) return;
    if(!gameOver && !paused) {
      if(frameCount%(100)==0) {
        makeMove();
      }
      update();
    }
    display();
  }
  void makeMove() {
    float rng = random(0,1);
    if(rng<0.5) {
      spawns.add(new Boss(health/2, random(20, size)));
      healthBar.subtract(DIFFICULTY);
      health-=DIFFICULTY;
    }
    else if(rng<0.75) acceleration = new PVector(random(0, width), random(0, height)).mult(0.1);
    else charge(ship.loc);
  }
  boolean dead() {
    if (!healthBar.dead) return false;
    for (Boss b : spawns) {
      if (b.alive()) return false;
    }
    return true;
  }
  boolean killed(Ship s) {
    if(hitBox.intersects(ship.hitBox) && alive()) return true;
    for (Boss b : spawns) {
      if (b.alive() && b.killed(s)) return true;
    }
    return false;
  }
  boolean intersects(Bullet b) {
    if (!b.visible ) return false;
    for (Boss B : spawns) {
      if (B.alive() && B.intersects(b)) return true;
    }
    float d = dist(loc.x, loc.y, b.loc.x, b.loc.y) -r - b.r;
    if (d<=0 && alive()) {
      return true;
    } 
    return false;
  }
  void hit(Bullet b) {
    if(gameOver || paused) return;
    for (Boss B : spawns) {
      if (B.alive() && B.intersects(b)){
        B.hit(b);
        return;
      }
    }
    if(alive()) healthBar.subtract(b.damage);
  }
}
