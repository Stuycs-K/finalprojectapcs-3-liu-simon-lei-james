public class Node {
  Coordinate coordinate;
  int distance;
  public Node(Coordinate coordinate, int distance) {
    this.coordinate = coordinate;
    this.distance = distance;
  }
  public Coordinate getCoordinate() {
    return coordinate;
  }
  public int getDistance() {
    return distance;
  }
}
