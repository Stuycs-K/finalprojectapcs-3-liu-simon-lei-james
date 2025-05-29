abstract class Weapon extends Item{

  private Resource durability;
  private int power;
  private String name;

  public Weapon(int durability, int power, String name){
    super(name, "Weapon");
    this.durability = new Resource(durability, "Durability");
    this.power = power;
  }

  public Resource getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }
  public String toString(){
    return name;
  }

  public boolean reduceDurability(int tear){
    return durability.consume(tear);
  }

  abstract void mainAttack(Character weilder, Character target){ //character is a parameter to call its strength stat}
}
