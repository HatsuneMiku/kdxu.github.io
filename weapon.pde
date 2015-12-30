// weapon
public static final int WEAPONCOUNT = 12;

public static final int SHOOTER = 0;
public static final int ROLLER  = 1;
public static final int CHARGER = 2;
public static final int PABLO = 3;
public static final int TAKE = 4;
public static final int RAIZIN = 5;
public static final int SPINNER = 6;
public static final int SLOSHER = 7;
public static final int SWEAPER = 8;
public static final int BLASTER = 9;
public static final int DINAMO = 10;
public static final int LITER = 11;



public static final int[] reachDefault = {6, 3, 20,2, 6,3 ,12, 8,10,5 ,4  ,40};
public static final int[] rangeDefault = {15,80,5 ,180,5,30,40,10, 5,45,120,2}; //degree

public static final int[] shotRateDefault   = {4,2,20,1 ,2,3 ,15,9,10,6,2,25};
public static final int[] chargeTimeDefault = {1,0,10,0 ,3,1 ,20,2,1,2,0,25};
public static final int[] shotDelayDefault  = {2,4,2 ,0 ,1,3 ,1 ,6,2,4,4,8};
public static final int[] maxWalkSpeedDefault={8,5,4 ,30,4,16,2 ,6,7,7,2,4};
public static final String[] weaponStrDefault =
{"シューター","ローラー","チャージャー","パブロ","タケ",
"ボールド","スピナー","バケツ","スイーパー","ブラスター","ダイナモ","リッター"};

Weapon[] weapons = new Weapon[WEAPONCOUNT];



static class Weapon{
  int weaponID;
  String weaponStr;

  int reach;
  int range; //degrees

  int shotRate;
  int chargeTime;
  int shotDelay;
  int maxWalkSpeed;

  Weapon(int ID){
    weaponStr = weaponStrDefault[ID];
    reach = reachDefault[ID];
    range = rangeDefault[ID];

    shotRate = shotRateDefault[ID];
    chargeTime = chargeTimeDefault[ID];
    shotDelay = shotDelayDefault[ID];
    maxWalkSpeed = maxWalkSpeedDefault[ID];
  }
}
