import java.util.Iterator;

class AsteroidSystem {
  ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
  int count;
  AsteroidSystem(int count_) {
    count = count_;
    for (int i=0; i<count; i++) {
      asteroids.add(new Asteroid());
    }
    checkStart();
  }
  void run() {
    for (Iterator<Asteroid> it = asteroids.iterator(); it.hasNext(); ) {
      Asteroid a = it.next();
      a.run();
    }
    checkCollisions();
  }
  void checkCollisions() {
    Asteroid b1, b2;
    for (int i=0; i<count; i++) {
      for (int j=i+1; j<count; j++) {
        b1 = asteroids.get(i);
        b2 = asteroids.get(j);
        if (b1.intersects(b2)) {
          b1.collide(b2);
        }
      }
    }
  }
  void checkStart() {
    for (Iterator<Asteroid> it = asteroids.iterator(); it.hasNext(); ) {
      Asteroid a1 = it.next();
      for(int i=0;i<count;i++) {
        Asteroid a2 = asteroids.get(i);
        if(a1!=a2 && a1.intersects(a2)) {
          it.remove();
          count--;
          break;
        }
      }
    }
  }
}
