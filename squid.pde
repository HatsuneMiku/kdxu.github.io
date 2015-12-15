final String[] teamNameDefault = {"アルファチーム","ブラボーチーム","クレイジーウンチ","ダイブツレクイエム"};
final color[] teamColorDefault = {#d88b25, #503ba0,#428944,#c25779};
final int PADDING = 40;
public static final int SHOOTER = 0;
public static final int ROLLER  = 1;
public static final int CHARGER = 2;
public static final int[] reach = {8,1,20};
public static final int[] range = {2,4,2};
public static final int[] shotRate = {4,1,6};
public static final String[] weaponStr = {"シューター","ローラー","チャージャー"};
public static final int UP = 0;
public static final int DOWN  = 1;
public static final int RIGHT = 2;
public static final int LEFT = 3;

class Team{
  int teamID;
  color teamColor;
  int respawnx;
  int respawny;
  String teamName;
  Squid[] members = new Squid[NumberOfIka];
  int paintPoint;

  Team(int teamID){
    this.teamID = teamID;
    this.teamColor = teamColorDefault[teamID];
    this.paintPoint = 0;

    switch (teamID){
      case 0:
      this.respawnx = PADDING;
      this.respawny = PADDING;
      break;

      case 1:
      this.respawnx = width  - PADDING;
      this.respawny = height - PADDING;
      break;

      case 2:
      this.respawnx = PADDING;
      this.respawny = height - PADDING;
      break;

      case 3:
      this.respawnx = width  - PADDING;
      this.respawny = PADDING;
      break;

      default:
      break;
    }

    this.teamName = teamNameDefault[teamID];

    for (int i=0;i< NumberOfIka;i++){
      members[i] = new Squid(teamID, i);
      members[i].x = this.respawnx;
      members[i].y = this.respawny;
    }
  }

  void Paint(){
    for(int i = 0; i < NumberOfIka; i++) members[i].Paint();
  }


}

class Squid {


  int x;
  int y;
  float vx;
  float vy;
  float ax;
  float ay;
  int direction;
  int weapon;
  int ikaNumber;
  int life;
  int kill = 0;
  int death = 0;

  int teamID;
  int paintPoint;

  boolean isPlaying;

  Squid(int teamID,int ikaNumber){

    vx = 0;
    vy = 0;
    ax = 0;
    ay = 0;

    this.teamID = teamID;
    this.ikaNumber = ikaNumber;
    this.weapon = (teamID + ikaNumber) % 3;
    life = 3;
    paintPoint = 0;
    isPlaying = true;
  }

  void RandomWalkAcc(){
    Random rnd = new Random();
    this.ax += -1 + (int)rnd.nextInt(3);
    this.ay += -1 + (int)rnd.nextInt(3);

    this.vx += this.ax / 10;
    this.vy += this.ay / 10;
  }

  void RandomWalkVel(){
    Random rnd = new Random();
    this.vx += -1 + (int)rnd.nextInt(3);
    this.vy += -1 + (int)rnd.nextInt(3);
  }

  void RandomWalkPos(){
    Random rnd = new Random();
    this.vx = -1 + (int)rnd.nextInt(3);
    this.vy = -1 + (int)rnd.nextInt(3);
  }

  void SlowDown(){
    if(Math.abs(this.vx) > 5)  this.vx *= 0.8;
    if(Math.abs(this.vy) > 5)  this.vy *= 0.8;
  }

  void isDead(){
    if(life == 0){
      death++;

      int deadx = Math.round(this.x / cellSize);
      int deady = Math.round(this.y / cellSize);
      int killTeamID  = cells[deadx][deady].teamID;
      int killSquidID = cells[deadx][deady].whoPainted;


      for (int i = 0;  i < 7  ; i++){
        for(int j = 0; j < 7 ; j++){
          if(i*i + j * j < 7*7 && (deadx + i <  width/cellSize) && (deady + j <  width/cellSize)
          && (deadx - i >  0) && (deady - j >  0) ){


            cells[deadx+i][deady+j].Painted(killTeamID, killSquidID);
            cells[deadx-i][deady+j].Painted(killTeamID, killSquidID);
            cells[deadx+i][deady-j].Painted(killTeamID, killSquidID);
            cells[deadx-i][deady-j].Painted(killTeamID, killSquidID);
          }
        }
      }


      teams[killTeamID].members[killSquidID].kill++;

      this.x = teams[this.teamID].respawnx;
      this.y = teams[this.teamID].respawny;
      this.life = 3;
      println("dead!");
    }


  }


  void Walk(){
    int nextx = (int)(this.x + this.vx);
    int nexty = (int)(this.y + this.vy);


    if(nextx > 0 && nextx < width && nexty > 0 && nexty < height && cells[Math.round(nextx/cellSize)][Math.round(nexty/cellSize)].state != WALL ){
      this.x = nextx;
      this.y = nexty;


      }else{
        this.vx *= -1;
        this.vy *= -1;
      }
    }

    void StopWalking(){
      this.isPlaying = false;
    }


    void ToBeInFrame(){
      while(this.x < 0)          this.x = this.x + width;
      while(this.x >= width)     this.x = this.x - width;
      while(this.y < 0)          this.y = this.y + height;
      while(this.y >= height)    this.y = this.y - height;
    }

void DrawSquid(){

  pushMatrix();
  translate(this.x,this.y);
  Random rnd = new Random();

  if(Math.abs(vx) > Math.abs(vy)){
    if(vx > 0){rotate(PI     /2); direction = RIGHT ;}
    else if(vx == 0){
      direction = rnd.nextInt(2) + 2;
    }
    else{       rotate(PI  *3 /2); direction = LEFT  ;}
    }else if(Math.abs(vx) == Math.abs(vy)){
      if(vx > 0){
        rotate(PI/2);
        direction = RIGHT;
      }
      else if(vx == 0){
        direction = rnd.nextInt(2) + 2;
      }
      else{
        rotate(PI  *3 /2); direction = LEFT ;
      }
    }
    else{
      if(vy > 0){rotate(PI ); direction = UP ;}
      else if(vy == 0){
        direction = rnd.nextInt(2);
      }
      else{
        rotate(0);
        direction = DOWN;
      }
    }

    shape(ikaShape,0,0,5*this.life,5*this.life);
    popMatrix();

  }

  void Shot(){
    this.SlowDown();
    boolean isWall = false;

    switch(direction){
      case UP:
      for (int i = 0 ; i < range[this.weapon] ;i++){
        for (int j = 0 ; j < reach[this.weapon];j++){
          int px = (Math.round(this.x / cellSize) - i - (range[this.weapon] / 2));
          int py = Math.round(this.y / cellSize) - j;
          if(px < width/cellSize && py < height/cellSize && px >= 0 && py >=0){
            if(cells[px][py].state == WALL){
              isWall = true;
              break;
            }
            cells[px][py].Painted(this.teamID,this.ikaNumber);
          }
        }
        if(isWall) break;
      }

      break;
      case DOWN:
      for (int i = 0 ; i < range[this.weapon] ;i++){
        for (int j = 0 ; j < reach[this.weapon];j++){
          int px = (Math.round(this.x / cellSize) - i - (range[this.weapon] / 2));
          int py = Math.round(this.y / cellSize) + j;
          if(px < width/cellSize && py < height/cellSize && px >= 0 && py >=0){
            if(cells[px][py].state == WALL){
              isWall = true;
              break;
            }
            cells[px][py].Painted(this.teamID,this.ikaNumber);
          }
        }
        if(isWall) break;
      }
      break;

      case LEFT:
      for (int i = 0 ; i < reach[this.weapon] ;i++){
        for (int j = 0 ; j < range[this.weapon];j++){
          int px = Math.round(this.x / cellSize) - i ;
          int py = Math.round(this.y / cellSize) - j - (range[this.weapon] / 2);
          if(px < width/cellSize && py < height/cellSize && px >= 0 && py >=0){
            if(cells[px][py].state == WALL){
              isWall = true;
              break;
            }
            cells[px][py].Painted(this.teamID,this.ikaNumber);
          }
        }
        if(isWall) break;
      }
      break;

      case RIGHT:
      for (int i = 0 ; i < reach[this.weapon] ;i++){
        for (int j = 0 ; j < range[this.weapon];j++){
          int px = Math.round(this.x / cellSize) + i;
          int py = Math.round(this.y / cellSize) + j- (range[this.weapon] / 2);
          if(px < width/cellSize && py < height/cellSize && px >= 0 && py >=0){
            if(cells[px][py].state == WALL){
              isWall = true;
              break;
            }
            cells[px][py].Painted(this.teamID,this.ikaNumber);
          }
        }
        if(isWall) break;
      }
      break;

    }


  }



  void Paint(){
    if(this.isPlaying){
      this.isDead();
      this.Walk();
      this.DrawSquid();


      //this.ReflectWall();

      if(cells[Math.round(this.x / cellSize)][Math.round(this.y / cellSize)].state == BLANK){
        this.SlowDown();
      }
      else if( cells[Math.round(this.x / cellSize)][Math.round(this.y / cellSize)].teamID == this.teamID){
        this.RandomWalkVel();
        this.life = 3;
        }else{
          this.vx *= 0.2; this.vy *= 0.2 ;
          this.life--;
        }

        // 足元を塗る
        cells[Math.round(this.x / cellSize)][Math.round(this.y / cellSize)].Painted(this.teamID,this.ikaNumber);

        // ブキの発射タイミング
        Random rnd = new Random();
        if(this.weapon == ROLLER && (frameCount % 50 > 20)) this.Shot();
        if(this.weapon == SHOOTER && (frameCount % 50 > 5)) this.Shot();
        else if ((frameCount + rnd.nextInt(25))% (10 * shotRate[this.weapon])  == 0) this.Shot();

      }
    }

  }
