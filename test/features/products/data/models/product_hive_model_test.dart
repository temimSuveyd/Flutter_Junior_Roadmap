import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/products/data/dtos/product_response.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_hive_model.dart';

/// Tests that a product response is stored in the Hive cache model.
void main() {
  test('fromResponse converts the image list to List<String>', () {
    final response = ProductResponse(
      image: ['a.jpg', 'b.jpg'],
      title: 'Chair',
      description: 'Wooden chair',
      price: 19.0,
      id: 3,
      category: 'Furniture',
    );

    final hive = ProductHiveModel.fromResponse(response);

    expect(hive.image, isA<List<String>>());
    expect(hive.image, ['a.jpg', 'b.jpg']);
    expect(hive.title, 'Chair');
    expect(hive.id, 3);
  });
}
