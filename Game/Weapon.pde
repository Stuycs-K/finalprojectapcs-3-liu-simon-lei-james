abstract class Weapon extends Item {
  private HashMap<String, Integer> weaponStats = new HashMap<String, Integer>(); // Power, Weight, Range, Hit
  private Resource durability;
  private String weaponType;
  private String material;

  public Weapon(HashMap<String, ArrayList<Integer>> data, String material, String weaponType){ // Expects weapon to be a valid key in the HashMap
    super(material + " " + weaponType, "Weapon");
    durability = new Resource(data.get(material).get(0), "Durability");
    weaponStats.put("Power", data.get(material).get(1));
    weaponStats.put("Weight", data.get(material).get(2));
    weaponStats.put("Hit", data.get(material).get(3));
    weaponStats.put("Range", data.get(material).get(4));
    this.material = material;
    this.weaponType = weaponType;
  }

  // Accessors

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

  // Durability

  public boolean reduceDurability(int tear) { // Returns false when weapon breaks
    if (!durability.consume(tear)) return false;
    return durability.getCurrent() <= 0;
  }

  // Attack

  public void attack(Character wielder, Character target) {
    int damage;
    int heavy = getStat("Weight") - wielder.getStat("Strength");
    int attackSpeed = wielder.getStat("Speed") - heavy;
    int hit = getStat("Hit") + (wielder.getStat("Skill") * 2);
    int avoid = target.getStat("Speed");

    if (target.hasWeapon()) {
      avoid -= (target.getWeapon().getStat("Weight") - target.getStat("Strength"));
    }

    avoid *= 2;

    switch (wielder.getPosition().getTerrain()) {
      case "Hills":
        switch (getWeaponType()) {
          case "Bow":
            hit += 50;
            break;
          case "Lance":
            hit += 20;
            break;
          default:
            hit -= 10;
            break;
        }
        avoid += 30;
        break;
      case "Forest":
        avoid += 20;
        break;
    }

    avoid = min(avoid, 99);

    if (getWeaponType().equals("Tome")) {
      damage = wielder.getStat("Magic") + getStat("Power") - target.getStat("Resistance");
    } else {
      damage = wielder.getStat("Strength") + getStat("Power") - target.getStat("Defense");
    }

    HashMap<String, String> weaknesses = new HashMap<String, String>() {{
      put("Lance", "Axe"); // Axe is weak to lance
      put("Sword", "Lance");
      put("Axe", "Sword");
    }};
    Set<String> weaponTriangle = weaknesses.keySet();

    if (target.hasWeapon() && wielder.hasWeapon()) {
      String wielderWeaponType = wielder.getWeapon().getWeaponType();
      String targetWeaponType = target.getWeapon().getWeaponType();

      if (weaponTriangle.contains(wielderWeaponType) && weaponTriangle.contains(targetWeaponType)) {
        if (weaknesses.get(wielderWeaponType).equals(targetWeaponType)) {
          damage--;
          hit -= 15;
        }
        if (weaknesses.get(targetWeaponType).equals(wielderWeaponType)) {
          damage++;
          hit += 15;
        }
      }
    }

    damage = max(0, damage);
    hit -= avoid;
    hit = min(hit, 100);

    int numAttacks = 1;
    if (attackSpeed >= (target.getStat("Speed") + 4)) numAttacks++;

    for (int i = 0; i < numAttacks; i++) {
      // Hit calculation from FE6 onwards. Makes hit rates lower than 50 lower than displayed, and hit rates higher than 50 higher than displayed
      if (((RANDOM.nextInt(100) + RANDOM.nextInt(100)) / 2) <= hit + HIT_CHANCE) {
        int crit = (wielder.getStat("Skill")/2) + CRIT_CHANCE - (target.getStat("Skill")/2);
        if (getMaterial().equals("Killer")) crit+= 30;
        if (getMaterial().equals("Fireball")) crit+= 12;
        if (RANDOM.nextInt(100) <= crit){
          critical(wielder, target);
        }
        else{
          target.damage(damage);
        }
        actionBar.write(wielder.toString() + " dealt " + damage + " damage to " + target.toString() + " with a " + hit + " percent chance to hit.");
        reduceDurability(1);
      } else {
        actionBar.write(wielder.toString() + " missed! They had a " + hit + " percent chance to hit.");
      }
    }
  }

  public void critical(Character wielder, Character target) {
    int damage;
    if (getWeaponType().equals("Tome")) {
      damage = (2 * (wielder.getStat("Magic") + getStat("Power"))) - target.getStat("Resistance");
    } else {
      /* this is the fe4/fe5 implementation. Criticals are more effective against units
         with high defense and less effective against units with low defense when compared
         with the more conventional critical system used in other games (a simple 3x damage) */
      damage = (2 * (wielder.getStat("Strength") + getStat("Power"))) - target.getStat("Defense");
    }
    target.damage(damage);
    reduceDurability(1);
    actionBar.write(wielder.toString() + " crit for " + damage + " damage!");
  }
}

public class Axe extends Weapon {
  public Axe(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 8, 10, 75, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 15, 12, 70, 1)));
      put("Killer", new ArrayList(Arrays.asList(30, 11, 11, 65, 1)));
    }}, material, "Axe");
  }

  /* axes are the heaviest hitting weapon in the standard Fire Emblem weapon triangle (sword-lance-axe). However, they are also by far the least accurate, along with the heaviest. May make axes
  specifically unable to double, but have a higher chance to inflict bleed. */

  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (RANDOM.nextInt(100) <= 15 + CONDITION_CHANCE) target.applyCondition("Bleeding");
  }
}

public class Bow extends Weapon {
  public Bow(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 6, 5, 85, 2)));
      put("Silver", new ArrayList(Arrays.asList(20, 13, 6, 75, 2)));
      put("Sleep", new ArrayList(Arrays.asList(20, 5, 10, 50, 3)));
    }}, material, "Bow");
  }

  public void attack(Character wielder, Character target) {
    super.attack(wielder, target);
    if (getMaterial().equals("Sleep")) target.applyCondition("Sleeping");
    if (RANDOM.nextInt(100) <= 10 + CONDITION_CHANCE) target.applyCondition("Bleeding");
  }
}

public class Lance extends Weapon {
  public Lance(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 7, 8, 80, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 14, 80, 1, 1)));
      put("Javelin", new ArrayList(Arrays.asList(20, 6, 11, 65, 2)));
    }}, material, "Lance");
  }
  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
  }
}

public class Sword extends Weapon {
  public Sword(String material){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron", new ArrayList(Arrays.asList(40, 6, 5, 85, 1)));
      put("Silver", new ArrayList(Arrays.asList(20, 13, 8, 80, 1)));
      put("Brave", new ArrayList(Arrays.asList(30, 7, 12, 80, 1)));
      put("Sleep", new ArrayList(Arrays.asList(50, 8, 12, 70, 1)));
    }}, material, "Sword");
  }

  public boolean calculateCondition(Character wielder) {
    if (wielder.getCharacterClass().equals("Thief")) {
      return RANDOM.nextInt(100) <= 20 + CONDITION_CHANCE;
    }
    return RANDOM.nextInt(100) <= 10 + CONDITION_CHANCE;
  }

  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (getMaterial().equals("Brave")) { // Brave weapons attack twice consecutively independently from doubling based on speed.
      super.attack(wielder, target);
    }
    if (calculateCondition(wielder)) {
      if (getMaterial().equals("Sleep")) {
        target.applyCondition("Sleeping");
      } else {
        target.applyCondition("Bleeding");
      }
    }
  }
}

public class Tome extends Weapon {
  /* types for tomes will be different kinds of spells. I will likely be implementing more conditions to go with these spells
    Fireball: 40 durability, 3 power, low weight, chance to burn and/or increased chance to crit
    Thunder: 30 durability, 5 power, medium weight, paralyze and/or brave effect similar to Brave Sword. I am hesitant to give it the brave effect, because magic inherently does
    more damage than physical attacks thanks to every class besides Mage generally having less resistance than defense. Increased range could be an alternative.
    Blizzard: 10 durability, 12 power, very high weight, chance to put enemies to sleep (frozen would be more accurate but the implementation would likely be the same, and there
    are instances in Fire Emblem where ice magic puts enemies to sleep */

  public Tome(String material) {
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Fireball", new ArrayList(Arrays.asList(40, 3, 1, 90, 2)));
      put("Thunder", new ArrayList(Arrays.asList(30, 5, 12, 70, 2)));
      put("Blizzard", new ArrayList(Arrays.asList(10, 12, 15, 65, 2)));
    }}, material, "Tome");
  }

  public void attack(Character wielder, Character target) {
    super.attack(wielder, target);
    if (getMaterial().equals("Thunder")) super.attack(wielder, target);
    if (getMaterial().equals("Blizzard")) target.applyCondition("Sleeping");
  }
}
