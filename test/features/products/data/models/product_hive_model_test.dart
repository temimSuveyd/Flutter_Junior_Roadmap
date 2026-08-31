import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/data/dtos/product_response.dart';
import 'package:juniorflutterroadmap/core/data/models/product_model.dart';

/// Tests that a product response is stored in the Hive cache model.
void main() {
  test('fromResponse converts the image list', () {
    final response = ProductResponse(
      image: ['a.jpg', 'b.jpg'],
      title: 'Chair',
      description: 'Wooden chair',
      price: 19.0,
      id: 3,
      category: 'Furniture',
    );

    final model = ProductModel.fromResponse(response);

    expect(model.image, ['a.jpg', 'b.jpg']);
    expect(model.title, 'Chair');
    expect(model.id, 3);
    expect(model.category, 'Furniture');
  });
}
