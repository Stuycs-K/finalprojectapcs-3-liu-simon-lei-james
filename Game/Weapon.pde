public class Weapon extends Item{

  private int durability;
  private int power;
  private String name;
  
  public Weapon(int durability, int power, String name){
    this.durability = durability;
    this.power = power;
    this.name = name;
  }
  
  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }
  public String toString(){
    return name;
  }

  public boolean reduceDurability(int tear){
    durability-= tear;
    return durability <= 0;
  }

  public int mainAttack(Character other){
    int damage = getPower();
    return damage;
  }
}
