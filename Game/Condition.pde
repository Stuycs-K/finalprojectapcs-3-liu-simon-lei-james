public class Condition {
  private String name;
  private Resource duration;

  public Condition(String name, int duration){
    this.name = name;
    this.duration = new Resource(duration, "Duration");
  }

  public String toString(){
    return name;
  }

  public int getDuration(){
    return duration.getCurrent();
  }

  public void reset() {
    duration.restore();
  }

  public void reduceDuration(){
    duration.consume(1);
  }
}
