public class Game{

  private static int turn; //turn is incremented each time phase is switched
  private static boolean playerPhase, victory, enemyVictory;
  /*private Tile[][] board; commented out for now until Tile is implemented
  private ArrayList<Enemy>enemies = new ArrayList<Enemy>();
  private ArrayList<Player>players = new ArrayList<Player>(); all commented out until respective classes get implemented*/

  public static void setup(){
    turn = 1;
    playerPhase = true;
    victory = false;
    enemyVictory = false;
  }

  public static boolean checkVictory(){ //currently the only victory condition is rout, but other potential goals like seizing a point or defending for a specific number of turns may also be added
    if (enemies.size() <= 0){
      victory = true;
    }
    if (players.size() <= 0){
      enemyVictory = true;
    }
  }

  public static void run(){
    while (!victory && !enemyVictory){
      checkVictory();
      turn++;
      if (playerPhase){

      }
      else{
        
      }
    }
  }

  public static void main(String[] args){
    setup();
    run();
  }
}
