class Asteroid {
  PVector loc;
  PVector velocity;
  PVector acceleration;
  float size, r, mass;
  float health;
  float alpha;
  PShape a;
  int seed, vertices = 30;
  Asteroid() {
    loc = new PVector(random(0, width), random(0, height-2*SCALE-MAXSIZE));
    velocity = PVector.random2D();
    velocity.limit(MAXVELOCITY);
    acceleration = new PVector(0, 0);
    size = random(MINSIZE, MAXSIZE);
    r = size/2;
    mass = size*10;
    health = (size-MINSIZE)*5;
    alpha = 80;
    a = createShape();
    generateShape();
    seed = (int)random(-1000, 1000);
  }
  void generateShape() {
    a.beginShape();
    a.fill(175, alpha);
    a.stroke(0);
    int n = vertices;
    for (int i=seed; i<n+seed; i++) {
      float angle = map(i-seed, 0, vertices, 0, TWO_PI);
      float noise = map(noise(i), 0, 1, 0.9, 1.2);
      PVector point = PVector.fromAngle(angle).mult(noise*r);
      a.vertex(point.x, point.y);
    }
    a.endShape(CLOSE);
  }
  void run() {
    if (!paused && !gameOver) update();
    display();
  }
  void display() {
    loc = new PVector(constrain(loc.x, 0, width), constrain(loc.y, 0, height));
    if (loc.x==0 || loc.x==width) velocity.x*=-1;
    if (loc.y==0 || loc.y==height) velocity.y*=-1;
    pushMatrix();
    translate(loc.x, loc.y);
    shape(a);
    popMatrix();
    //fill(175, alpha);
    //stroke(0);
    //ellipse(loc.x, loc.y, size, size);
    stroke(255);
  }
  void update() {
    PVector target = new PVector(random(0, width), random(0, height));
    acceleration = PVector.sub(target, loc);
    acceleration.limit(0.01);
    velocity.add(acceleration);
    loc.add(velocity);
  }  
  boolean intersects(Asteroid b) {
    float d = dist(loc.x, loc.y, b.loc.x, b.loc.y) -r - b.r;
    if (d>0) {
      return false;
    } else return true;
  }
  boolean intersect(Bullet b) {
    float d = dist(loc.x, loc.y, b.loc.x, b.loc.y) -r - b.r;
    if (d>0) {
      return false;
    } else return true;
  }
  void hit(Bullet b) {
    health -= b.damage;
    alpha = map(health, 0, (size-MINSIZE)*5, 20, 80);
    
    a.setFill(color(175, alpha));
  }
  boolean isDead() {
    return (health<=0);
  }
  void collide(Asteroid b) {
    float factor = 2*b.mass/(mass+b.mass);
    float dotP = PVector.dot(PVector.sub(velocity, b.velocity), PVector.sub(loc, b.loc));
    PVector disp = PVector.sub(loc, b.loc);
    PVector dir = disp.normalize();
    dir.mult(factor);
    dir.mult(dotP);
    float factor2 = 2*mass/(b.mass+mass);
    float dotP2 = PVector.dot(PVector.sub(b.velocity, velocity), PVector.sub(b.loc, loc));
    PVector disp2 = PVector.sub(b.loc, loc);
    PVector dir2 = disp2.normalize();
    dir2.mult(factor2);
    dir2.mult(dotP2);
    b.velocity.sub(dir2);
    velocity.sub(dir);
    velocity.limit(MAXVELOCITY);
    b.velocity.limit(MAXVELOCITY);
  }
}
