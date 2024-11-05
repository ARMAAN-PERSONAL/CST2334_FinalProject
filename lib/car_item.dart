
import 'package:floor/floor.dart';

@Entity(tableName: 'cars')
class CarItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String brand;
  final String model;
  final int passengerCount;
  final double capacity;

  CarItem({this.id, required this.brand, required this.model, required this.passengerCount, required this.capacity});
}
