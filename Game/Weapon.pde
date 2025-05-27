public class Weapon extends Item{

  private int durability;
  private int power;

  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }

  public boolean reduceDurability(int tear){
    durability-= tear;
    return durability <= 0;
  }

  public void mainAttack(Character other){
    int damage = getPower();
    if (other.damage(damage)){
      System.out.println(other.getName() + " defeated");
    }
    System.out.println(other.getHealth());
  }
}
