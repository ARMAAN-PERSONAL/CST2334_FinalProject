
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'car_item.dart';

class CarListPage extends StatefulWidget {
  final AppDatabase database;
  CarListPage(this.database);

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<CarItem> cars = [];
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final passengerCountController = TextEditingController();
  final capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCars();
    _loadPreviousCarData();
  }

  Future<void> _loadCars() async {
    cars = await widget.database.carDao.findAllCars();
    setState(() {});
  }

  Future<void> _loadPreviousCarData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    brandController.text = prefs.getString('lastBrand') ?? '';
    modelController.text = prefs.getString('lastModel') ?? '';
    passengerCountController.text = prefs.getString('lastPassengerCount') ?? '';
    capacityController.text = prefs.getString('lastCapacity') ?? '';
  }

  Future<void> _savePreviousCarData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastBrand', brandController.text);
    await prefs.setString('lastModel', modelController.text);
    await prefs.setString('lastPassengerCount', passengerCountController.text);
    await prefs.setString('lastCapacity', capacityController.text);
  }

  Future<void> _addCar() async {
    if (brandController.text.isNotEmpty &&
        modelController.text.isNotEmpty &&
        passengerCountController.text.isNotEmpty &&
        capacityController.text.isNotEmpty) {
      final newCar = CarItem(
        brand: brandController.text,
        model: modelController.text,
        passengerCount: int.parse(passengerCountController.text),
        capacity: double.parse(capacityController.text),
      );
      await widget.database.carDao.insertCar(newCar);
      _savePreviousCarData();
      _loadCars();
      brandController.clear();
      modelController.clear();
      passengerCountController.clear();
      capacityController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Car added successfully!')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text(
                    'Use this page to manage your cars. Add, update, or delete entries as needed.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passengerCountController,
              decoration: InputDecoration(labelText: 'Passenger Count'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: capacityController,
              decoration: InputDecoration(labelText: 'Capacity (L or kWh)'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: _addCar,
            child: Text('Add Car'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  title: Text('${car.brand} ${car.model}'),
                  subtitle: Text('Passengers: ${car.passengerCount}, Capacity: ${car.capacity}'),
                  onTap: () {
                    // Placeholder for update or delete functionality
                    // Implement further actions if required
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
