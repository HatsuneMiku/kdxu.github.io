//import java.util.Random;
//import ddf.minim.*;
//import java.util.Arrays;

//Minim minim;
//AudioPlayer bgmPlayer;
//AudioPlayer sePlayer;

PShape ikaShape;
PFont f;

//int i = 0;
//int x = 0;


public Cell[][] cells;
Team[] teams;

public final color black = (12);  //Blank floor color
public final color gray = (220);  //Wall color

public static int numberOfIka = 4;
public static int numberOfTeams = 4;
public static final int FIELDSIZEX = 600;
public static final int FIELDSIZEY= 600;
public static final int STATEVIEWSIZE = 600;


public static final int CELLSIZE = 10;

public static final int CELLNUMBERX = Math.round(FIELDSIZEX / CELLSIZE);
public static final int CELLNUMBERY = Math.round(FIELDSIZEY / CELLSIZE);

public static final int BEFOREBATTLE = 0;
public static final int BATTLE = 1;
public static final int ENDBATTLE = 2;

public static PVector startBtnPos = new PVector(FIELDSIZEX + 20, FIELDSIZEY /2 - 40);
public static PVector teanNumPos = new PVector(FIELDSIZEX + 20, FIELDSIZEY /2 + 40);
public static PVector ikaNumPos = new PVector(FIELDSIZEX + 20, FIELDSIZEY /2 + 80);


int startTime;
int gameState;
int timer;

void settings(){
//  size(FIELDSIZEX + STATEVIEWSIZE, FIELDSIZEY);
//  size(1200,600);
}

void setup() {
  size(1200,600);
  startTime = 0;
  frameRate(25);
  // font settings
  f = createFont("ikamodoki", 12);
  textFont(f);

  // sound settings
  /*
  minim = new Minim(this);
  bgmPlayer = minim.loadFile("bgm.mp3");
  sePlayer = minim.loadFile("dead.mp3");
*/

  // shape settings
  ikaShape = loadShape("ika3.svg");

  // cell initialization
  cells = new Cell[FIELDSIZEX/CELLSIZE][FIELDSIZEY/CELLSIZE];
  for(int i = 0; i < FIELDSIZEX/CELLSIZE; i++){
    for(int j = 0; j < FIELDSIZEY/CELLSIZE; j++) cells[i][j] = new Cell();
  }

  // weapon initialization

  for (int i=0;i< WEAPONCOUNT;i++) weapons[i] = new Weapon(i);


  // 背景とかの整形
  noStroke();
  background(black);

  gameState = BEFOREBATTLE;

}

void draw() {

  timer = millis();

  //セルの更新
  for (int x=0; x<FIELDSIZEX/CELLSIZE; x++) {
    for (int y=0; y<FIELDSIZEY/CELLSIZE; y++) {
      if(cells[x][y].state == BLANK) fill(black);
      else if (cells[x][y].state == WALL) fill(gray);
      else fill(teams[cells[x][y].teamID].teamColor);

      rect (x*CELLSIZE, y*CELLSIZE, CELLSIZE, CELLSIZE);
    }
  }

  switch (gameState){
    case  BEFOREBATTLE :
    BattleSetup();
    break;

    case  BATTLE :
    Battle();
    break;

    case  ENDBATTLE :
    EndGame();
    noLoop();
    break;
  }
}

void EndGame(){

  //リセットボタンを描画
  stroke(200);
  fill(50,50);
  rect(FIELDSIZEX/2 - 60,FIELDSIZEY/2 - 20 , 120,40);
  fill(255);
  text("リセット" ,FIELDSIZEX/2 -20 ,FIELDSIZEY/2 + 10);

}


void mouseDragged() {

  //壁を描く
  int onMouseCellx = Math.round(mouseX / CELLSIZE) ;
  int onMouseCelly = Math.round(mouseY / CELLSIZE) ;

  if ( onMouseCellx >= 0 && onMouseCellx < CELLNUMBERX && onMouseCelly >= 0 && onMouseCelly < CELLNUMBERY) {
    cells[onMouseCellx][onMouseCelly].ChangeState(WALL);
    cells[onMouseCellx][Math.abs(onMouseCelly - (CELLNUMBERY-1))].ChangeState(WALL);
    cells[Math.abs(onMouseCellx - (CELLNUMBERX-1))][onMouseCelly].ChangeState(WALL);
    cells[Math.abs(onMouseCellx - (CELLNUMBERX-1))][Math.abs(onMouseCelly - (CELLNUMBERY-1))].ChangeState(WALL);
  }
}


void mousePressed(){
  if(gameState == BEFOREBATTLE){
    //スタートが押された
    if (RectOver(FIELDSIZEX + 20, FIELDSIZEY /2 - 40, 60, 40) ) {
      // team initialization
      teams = new Team[numberOfTeams];
      for(int i = 0; i < numberOfTeams; i++) teams[i] = new Team(i);
      gameState = BATTLE;
//      bgmPlayer.play();
      startTime = timer;
    }

    if (RectOver((int)teanNumPos.x +60 , (int)teanNumPos.y, 15, 15)){
      if(numberOfTeams > 1)numberOfTeams--;
    }
    if(RectOver((int)teanNumPos.x +85 , (int)teanNumPos.y, 15, 15)){
      if(numberOfTeams < 4) numberOfTeams++;
    }
    if(RectOver((int)ikaNumPos.x + 60, (int)ikaNumPos.y, 15, 15)){
      if(numberOfIka > 1)numberOfIka--;
    }
    if(RectOver((int)ikaNumPos.x + 85, (int)ikaNumPos.y, 15, 15)){
      if(numberOfIka < 9)numberOfIka++;
    }
  }

  if (gameState == ENDBATTLE){
    //リセットが押された
    if(RectOver(FIELDSIZEX/2 - 60,FIELDSIZEY/2 - 20 , 120,40)){
      setup();
      loop();
    }
  }
}

boolean RectOver( int x, int y, int w,int h){
  if (mouseX >= x && mouseX <= x+w &&
    mouseY >= y && mouseY <= y+h) {
      return true;
      } else {
        return false;
      }
    }

void BattleSetup(){
      //ステータス画面を掃除
      fill(0);
      rect(FIELDSIZEX, 0, STATEVIEWSIZE, height);

      //戦場の枠を書く
      noFill();
      stroke(200);
      rect(0,0,FIELDSIZEX,FIELDSIZEY); //field

      //ボタンの描画
      rect(startBtnPos.x, startBtnPos.y, 60, 30);
      noStroke();
      fill(255);
      text("スタート", startBtnPos.x + 20,startBtnPos.y + 20);
      text("チームのカズ  ▼"+ numberOfTeams+ " ▲",teanNumPos.x, teanNumPos.y+15);
      text("イカのカズ　▼ "+ numberOfIka + " ▲",ikaNumPos.x, ikaNumPos.y + 15);
    }

    void Battle(){
      if(timer - startTime >= 61000) {
        gameState = ENDBATTLE;
        return;
      }

      //イカを動かす

      for(int i = 0; i < teams.length; i++)  teams[i].Paint();


      //イカの状態を出す


      if(frameCount % 25 == 0){
        fill(0);
        rect(FIELDSIZEX, 0, STATEVIEWSIZE, height);

        for(int i=0; i <numberOfTeams; i++){
          teams[i].paintPoint = 0;
          for(int j=0; j <numberOfIka; j++){
            teams[i].members[j].paintPoint = 0;
          }

        }

        for (int x=0; x<FIELDSIZEX/CELLSIZE; x++) {
          for (int y=0; y<FIELDSIZEY/CELLSIZE; y++) {
            if(cells[x][y].state != BLANK && cells[x][y].state != WALL){
              teams[cells[x][y].teamID].paintPoint++;
              teams[cells[x][y].teamID].members[cells[x][y].whoPainted].paintPoint++;
            }
          }
        }
        fill(255);
        for(int i = 0; i < teams.length ; i++ ){
          fill(teams[i].teamColor);
          text(teams[i].teamName + teams[i].paintPoint + "P", FIELDSIZEX + 20,50 + i * 140);
          for(int j = 0; j < numberOfIka; j++){
            int k = j + 1;
            text( k +"ゴウ " + INTELIGENCENAME[teams[i].members[j].intelligece] +" \n" + teams[i].members[j].paintPoint +"P \n"
            + weapons[teams[i].members[j].weapon].weaponStr + "\nキル "
            + teams[i].members[j].kill + "\nデス " + teams[i].members[j].death , FIELDSIZEX + 20 + j* 80 ,50 + i * 140 + 20);
          }
        }
      }

    }
    void keyPressed() {

      if(gameState == BATTLE){
        if (key == CODED) {
          switch(keyCode){
            case UP    : teams[0].members[0].velocity.set(0,-6); break;
            case DOWN  : teams[0].members[0].velocity.set(0,6); break;
            case RIGHT : teams[0].members[0].velocity.set(6,0); break;
            case LEFT  : teams[0].members[0].velocity.set(-6,0); break;
          }
        }
      }

    }


    void stop()
    {
//      bgmPlayer.close();
//      sePlayer.close();
//      minim.stop();
      super.stop();
    }
