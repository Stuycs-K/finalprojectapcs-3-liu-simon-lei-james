public class Weapon extends Item{

  private int durability;
  private int power;

  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }

  public boolean reduceDurability(int break){
    durability-= break;
    return durability <= 0;
  }

  public void mainAttack(Character other){
    int damage = getPower();
    if (other.damage(damage) <= 0){
      System.out.println(Character.getName() + " defeated")
    }
    System.out.println()
  }
}
