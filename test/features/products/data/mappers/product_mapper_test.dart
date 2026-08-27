import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/products/data/dtos/product_response.dart';
import 'package:juniorflutterroadmap/features/products/data/mappers/product_mapper.dart';

/// Tests that the API response is mapped into the UI model correctly.
void main() {
  test('toProductModel maps every field', () {
    final response = ProductResponse(
      image: ['https://img/1.jpg'],
      title: 'Book',
      description: 'A nice book',
      price: 9.99,
      id: 5,
      category: 'Books',
    );

    final model = ProductMapper.toProductModel(response);

    expect(model.title, 'Book');
    expect(model.description, 'A nice book');
    expect(model.price, 9.99);
    expect(model.id, 5);
    expect(model.category, 'Books');
    expect(model.thumbnailImage, 'https://img/1.jpg');
  });
}
