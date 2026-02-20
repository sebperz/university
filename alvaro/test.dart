// import 'dart:io';

void main() {
  // String? name = stdin.readLineSync();
  // String? km_string = stdin.readLineSync();
  // var km = int.parse(km_string);
  String name = "Sebastian";
  double distance = 350;
  double consumption = 14;
  double price = 5800;
  print(
    "Name: $name\nDistance: $distance km\nConsumption: $consumption km/l\nPrice: \$$price per liter\n",
  );
  print(
    "Hi there $name in your ${distance.toStringAsFixed(2)} km travel you will consume ${(distance / consumption).toStringAsFixed(2)} liters of gas, that will be \$${distance / consumption * price}",
  );
}
