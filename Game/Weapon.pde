abstract class Weapon extends Item {
  private int durability;
  private int power;
  private int weight;
  private int maxRange;
  private String weaponClass;
  private String material;

  HashMap<String, ArrayList<Integer>> data = new HashMap<String, ArrayList<Integer>>();

  public Weapon(int durability, int power, int weight, int maxRange, String material, String weaponClass){
    super(material + " " + weaponClass, "Weapon");
    this.durability = durability;
    this.power = power;
    this.weight = weight;
    this.maxRange = maxRange;
    this.material = material;
    this.weaponClass = weaponClass;
  }

  public Weapon(HashMap<String, ArrayList<Integer>> data, String weapon){ //expects weapon to be a valid key in the HashMap
    super(weapon, "Weapon");
    material = weapon.substring(0, weapon.indexOf(' '));
    weaponClass = weapon.substring(weapon.indexOf(' ') + 1, weapon.length());
    durability = data.get(weapon).get(0);
    power = data.get(weapon).get(1);
    weight = data.get(weapon).get(2);
    maxRange = data.get(weapon).get(3);
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
    if (damage <= 0){
      damage = 0;
    }
    target.damage(damage);
    actionBar.write(wielder.getName() + " dealt " + damage + " damage to " + target.getName());
    reduceDurability(1);
    if (canDouble(wielder, target)){
      target.damage(damage);
      actionBar.write(0, 1, wielder.getName() + " dealt " + damage + " damage to " + target.getName());
      reduceDurability(1);
    }
  }

  public void critical(Character wielder, Character target){
    int damage;
    if (getWeaponClass().equals("Tome")){
      damage = (2 * (wielder.getStat("Magic") + power)) - target.getStat("Resistance");
    }
    else{
      damage = (2 * (wielder.getStat("Strength") + power)) - target.getStat("Defense"); /* this is the fe4/fe5 implementation. Criticals are more effective against units
                                                                                             with high defense and less effective against units with low defense when compared
                                                                                             with the more conventional critical system used in other games (a simple 3x damage) */
    }
    target.damage(damage);
    reduceDurability(1);
  }
}
