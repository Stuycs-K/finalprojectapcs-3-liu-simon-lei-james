abstract class Character extends Entity {
  private String name;
  private Resource health;
  public Character(String name, int maxHealth) {
    super("Character");
    this.name = name;
    health = new Resource(maxHealth);
  }
  public String getName() {
    return name;
  }
  public String getHealth() {
    return health.toString();
  }
}
