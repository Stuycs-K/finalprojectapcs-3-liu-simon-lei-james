abstract class Weapon extends Item {
  private int durability;
  private int power;
  private int weight;
  private int maxRange;
  private String weaponClass;
  private String material;

  public Weapon(int durability, int power, int weight, int maxRange, String material, String weaponClass){
    super(material + " " + weaponClass, "Weapon");
    this.durability = durability;
    this.power = power;
    this.weight = weight;
    this.maxRange = maxRange;
    this.material = material;
    this.weaponClass = weaponClass;
  }

  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }
  public int getWeight(){
    return weight;
  }
  public int getRange(){
    return maxRange;
  }
  public String getWeaponClass(){
    return weaponClass;
  }
  public String getMaterial() {
    return material;
  }

  public boolean reduceDurability(int tear){
    durability -= tear;
    return durability <= 0;
  }
  public boolean canDouble(Character wielder, Character target){
    int heavy = getWeight() - wielder.getStat("Strength");
    if (heavy < 0){
      heavy = 0;
    }
    return (wielder.getStat("Speed") - heavy) >= (target.getStat("Speed") + 4);
  }

  public void attack(Character wielder, Character target){ //character is a parameter to call its strength stat
    int damage;
    if (getWeaponClass().equals("Tome")){
      damage = wielder.getStat("Magic") + power - target.getStat("Resistance");
    }
    else{
      damage = wielder.getStat("Strength") + power - target.getStat("Defense");
    }
    target.damage(damage);
    reduceDurability(1);
    if (canDouble(wielder, target)){
      target.damage(damage);
      reduceDurability(1);
    }
  }

  public void critical(Character wielder, Character target){ 
    int damage = (2 * (wielder.getStat("Strength") + power)) - target.getStat("Defense"); /* this is the fe4/fe5 implementation. Criticals are more effective against units 
                                                                                             with high defense and less effective against units with low defense when compared
                                                                                             with the more conventional critical system used in other games (a simple 3x damage) */
    target.damage(damage);
    reduceDurability(1);
  }
}
