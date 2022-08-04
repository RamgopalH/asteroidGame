float MAXVELOCITY = 2;
float MAXACC = 1;
int DIFFICULTY = 1;
int SCALE = 25;
float MINSIZE = 20;
float MAXSIZE = 50;
int POINTSPERHIT = 2;
PVector STARTLOC;
DigitDisplay finalScore;
boolean paused = false;
boolean gameOver = false;
boolean roundOver = false;
boolean bossSpawned = false;
Ship ship;
AsteroidSystem system;
DigitDisplay round;
Boss boss;
void setup() {
  //size(1000, 800);
  fullScreen();
  background(0);
  STARTLOC = new PVector(width/2, height-50);
  ship = new Ship(new PVector(width/2, height-50) , SCALE);
  system = new AsteroidSystem(8*DIFFICULTY);
  round = new DigitDisplay(new PVector(width-50, 50), 2, 1);
  //nextRound();
}
void draw() {
  background(0);
  if(gameOver) {
    finalScore.display();
  }
  ship.run();
  if(bossSpawned) boss.run();
  else system.run();
  round.display();
  if(mousePressed) ship.fire();
  check();
}

void keyPressed() {
  if(keyCode == 32) {
    paused = !paused;
  }
}

void keyTyped() {
  if(key=='d'|| key=='D') ship.moveRight();
  if(key=='a'|| key=='A') ship.moveLeft();
  if(key=='w'|| key=='W') ship.moveForward();
  if(key=='s'|| key=='S') ship.moveBackward();
  if(key=='1') ship.changeGun(1);
  if(key=='2') ship.changeGun(2);
  if(key=='3') ship.changeGun(3);
}

void mousePressed() {
  if(!paused && !gameOver)
    ship.fire();
}

void check() {
  if(gameOver) return; //<>//
  if(bossSpawned){
    if(boss.dead()) {
      ship.score.increase(1000);
      bossSpawned = false;
      //round.increase(4);
      nextRound();
      return;
    }
    if(boss.killed(ship)) {
      gameOver = true;
      bossSpawned = true;
      gameCloser();
    }
    return;
  }
  for(Iterator<Asteroid> it = system.asteroids.iterator();it.hasNext();) {
    Asteroid a = it.next();
    if(ship.hasHit(a)) {
      gameOver = true;
      gameCloser();
    }
  }
  if(system.count == 0) {
    nextRound();
  }
}

void nextRound() {
  round.incr();
  gameOver = false;
  paused = true;
  DIFFICULTY = constrain(DIFFICULTY+1, 0, 5);
  ship.reset();
  if(round.value()%3==0) {
    bossRound();
    return;
  }
  system = new AsteroidSystem(8*DIFFICULTY);  
}

void bossRound() {
  bossSpawned = true;
  float rng = random(0, 1);
  if(rng<0.1)
  boss = new Boss(new PVector(width/2, height/2), 500*DIFFICULTY, SCALE*3, DIFFICULTY*2);
  else if(rng<0.3)
  boss = new OAS(new PVector(width/2, height/2), 500*DIFFICULTY, SCALE*3, DIFFICULTY*2);
  else
  boss = new Spawner(new PVector(width/2, height/2), 500*DIFFICULTY, SCALE*3, DIFFICULTY*2);
}

void gameCloser() {
  round.toggleVisibility();
  ship.score.toggleVisibility();
  finalScore = new DigitDisplay(new PVector(width/2, 50), 4, ship.score.value());
}
