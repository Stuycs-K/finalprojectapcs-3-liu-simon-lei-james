abstract class Weapon extends Item {
  private HashMap<String, Integer> weaponStats = new HashMap<String, Integer>(); // Power, Weight, Range
  private Resource durability;
  private String weaponType;
  private String material;
  
  public Weapon(HashMap<String, ArrayList<Integer>> data, String material, String weaponType){ //expects weapon to be a valid key in the HashMap
    super(material + " " + weaponType, "Weapon");
    durability = new Resource(data.get(material).get(0), "Durability");
    weaponStats.put("Power", data.get(material).get(1));
    weaponStats.put("Weight", data.get(material).get(2));
    weaponStats.put("Range", data.get(material).get(3));
    this.material = material;
    this.weaponType = weaponType;
  }

  public Resource getDurability() {
    return durability;
  }
  public int getStat(String name) {
    return weaponStats.get(name);
  }
  public String getWeaponType() {
    return weaponType;
  }
  public String getMaterial() {
    return material;
  }

  public boolean reduceDurability(int tear) { // Returns false when weapon breaks 
    if (!durability.consume(tear)) return false;
    return durability.getCurrent() <= 0;
  }
  
  public boolean canDouble(Character wielder, Character target) {
    int heavy = getStat("Weight") - wielder.getStat("Strength");
    if (heavy < 0) heavy = 0;
    return (wielder.getStat("Speed") - heavy) >= (target.getStat("Speed") + 4);
  }

  public void attack(Character wielder, Character target) {
    int damage;
    if (getWeaponType().equals("Tome")) {
      damage = wielder.getStat("Magic") + getStat("Power") - target.getStat("Resistance");
    }
    else {
      damage = wielder.getStat("Strength") + getStat("Power") - target.getStat("Defense");
    }
    if (target.getCharacterClass().equals("Soldier")) { // Soldier special power
      if (getWeaponType().equals("Axe")) damage++;
      if (getWeaponType().equals("Sword")) damage--;
      if (damage <= 0) damage = 0;
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
    if (getWeaponType().equals("Tome")) {
      damage = (2 * (wielder.getStat("Magic") + getStat("Power"))) - target.getStat("Resistance");
    }
    else {
      /* this is the fe4/fe5 implementation. Criticals are more effective against units
         with high defense and less effective against units with low defense when compared  
         with the more conventional critical system used in other games (a simple 3x damage) */
      damage = (2 * (wielder.getStat("Strength") + getStat("Power"))) - target.getStat("Defense");
    }
    target.damage(damage);
    reduceDurability(1);
  }
}

public class Axe extends Weapon {
  public Axe(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 8, 5, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 16, 10, 1)));
      put("Killer", new ArrayList(Arrays.asList(20, 9, 6, 1)));
    }}, material, "Axe");
  }
  
  /* axes are the heaviest hitting weapon in the standard Fire Emblem weapon triangle (sword-lance-axe). However, they are also by far the least accurate, along with the heaviest. May make axes
  specifically unable to double, but have a higher chance to inflict bleed. */

  public void attack(Character wielder, Character target){
    if (getMaterial().equals("Killer")) {
      if (RANDOM.nextInt(100) <= 30){
        critical(wielder, target);
      }
      else {
        super.attack(wielder, target);
      }
    }
    else {
      super.attack(wielder, target);
    }
    if (RANDOM.nextInt(100) <= 15) target.applyCondition("Bleeding");
  }
}

public class Bow extends Weapon{
  public Bow(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 5, 1, 2)));
      put("Silver", new ArrayList(Arrays.asList(20, 8, 3, 2)));
      put("Sleep", new ArrayList(Arrays.asList(20, 3, 5, 3)));
    }}, material, "Bow");
  }

  public void attack(Character wielder, Character target) {
    super.attack(wielder, target);
    if (getMaterial().equals("Sleep")) target.applyCondition("Sleeping");
    if (RANDOM.nextInt(100) <= 10) target.applyCondition("Bleeding");
  }
}

public class Lance extends Weapon {
  public Lance(String material){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 7, 1, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 14, 3, 1)));
      put("Javelin", new ArrayList(Arrays.asList(20, 5, 5, 2)));
    }}, material, "Lance");
  }
  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
  }
}

public class Sword extends Weapon {
  public Sword(String material){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 5, 1, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 8, 3, 1)));
      put("Brave", new ArrayList(Arrays.asList(30, 7, 5, 1)));
    }}, material, "Sword");
  }

  public boolean calculateCondition(Character wielder) {
    if (wielder.getCharacterClass().equals("Thief")) {
      return RANDOM.nextInt(100) <= 20;
    }
    return RANDOM.nextInt(100) <= 10;
  }

  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (getMaterial().equals("Brave")){ //Brave weapons attack twice consecutively independently from doubling based on speed.
      super.attack(wielder, target);
    }
    if (calculateCondition(wielder)){
      target.applyCondition("Bleeding");
    }
  }
}

public class Tome extends Weapon{
  /* types for tomes will be different kinds of spells. I will likely be implementing more conditions to go with these spells
    Fireball: 40 durability, 3 power, low weight, chance to burn and/or increased chance to crit
    Thunder: 30 durability, 5 power, medium weight, paralyze and/or brave effect similar to Brave Sword. I am hesitant to give it the brave effect, because magic inherently does
    more damage than physical attacks thanks to every class besides Mage generally having less resistance than defense. Increased range could be an alternative.
    Blizzard: 10 durability, 12 power, very high weight, chance to put enemies to sleep (frozen would be more accurate but the implementation would likely be the same, and there
    are instances in Fire Emblem where ice magic puts enemies to sleep */

  public Tome(String material){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Fireball", new ArrayList(Arrays.asList(40, 3, 1, 2)));
      put("Thunder", new ArrayList(Arrays.asList(30, 5, 5, 2)));
      put("Blizzard", new ArrayList(Arrays.asList(10, 12, 10, 2)));
    }}, material, "Tome");
  }

  public void attack(Character wielder, Character target){
    if (getMaterial().equals("Fireball")) {
      if (RANDOM.nextInt() <= 12) {
        super.critical(wielder, target);
      }
      else {
        super.attack(wielder, target);
      }
    }
    super.attack(wielder, target);
    if (getMaterial().equals("Thunder")) super.attack(wielder, target);
    if (getMaterial().equals("Blizzard")) target.applyCondition("Sleeping");
  }
}
