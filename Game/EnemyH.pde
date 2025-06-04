abstract class EnemyH extends Enemy{
  
  private ArrayList<String> weaponProficiencies;
  
  private Weapon weapon;
  
  public EnemyH(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats);
    this.weaponProficiencies = weaponProficiencies;
  }
  
  public void equip(Weapon weapon) {
    if (weaponProficiencies.contains(weapon.getWeaponClass())) {
      this.weapon = weapon;
    }
  }

  public String getWeapon() {
    if (weapon == null) return "No Weapon";
    return weapon.toString();
  }

  public void attack(Character other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
      weapon.attack(this, other);
    }
  }
  
  public ArrayList<Tile> attackRange() {
    System.out.println(weapon.getRange());
    return getPosition().tilesInRadius(weapon.getRange());
  }
}
