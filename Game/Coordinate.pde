public class Coordinate {
  private int x, y;
  public Coordinate(int x, int y) {
    this.x = x;
    this.y = y;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public boolean equals(Coordinate other) {
    return other.getX() == getX() && other.getY() == getY();
  }
  public Coordinate shift(int[] distances) {
    return new Coordinate(x + distances[0], y + distances[1]);
  }
}
