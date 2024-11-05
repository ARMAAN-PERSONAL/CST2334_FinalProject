
import 'package:floor/floor.dart';
import 'car_item.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM cars')
  Future<List<CarItem>> findAllCars();

  @insert
  Future<void> insertCar(CarItem car);

  @update
  Future<void> updateCar(CarItem car);

  @delete
  Future<void> deleteCar(CarItem car);
}
