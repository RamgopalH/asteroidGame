class HitBox {
  PVector loc;
  float heading;
  float size, r;
  HitBox(PVector loc_, float size_) {
    size = size_;
    loc = loc_;
    r=size/2;
  }
  void display() {
    fill(255, 40);
    ellipse(loc.x, loc.y, size, size);
  }
  void update(PVector loc_) {
    loc = loc_;
  }
  void run(PVector loc_) {
    update(loc_);
    display();
  }
  boolean intersects(Asteroid a) {
    float d = dist(loc.x, loc.y, a.loc.x, a.loc.y) -r - a.r;
    if (d>0){
      return false;
    } 
    else return true;
  }
  boolean intersects(HitBox h) {
    float d = dist(loc.x, loc.y, h.loc.x, h.loc.y) -r - h.r;
    if (d>0){
      return false;
    } 
    return true;
  }
}
