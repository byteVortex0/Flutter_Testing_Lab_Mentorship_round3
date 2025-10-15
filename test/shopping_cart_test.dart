import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('Test cart', () {
    late CartRepo cartRepo;

    setUp(() {
      cartRepo = CartRepo(); // نحفظه في المتغير اللي هيتشارك بين كل tests
    });
    test('Add item', () {
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      expect(cartRepo.items.length, 1);
      expect(cartRepo.totalAmount, 90);
    });

    test('Add duplicate item', () {
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      expect(cartRepo.items.length, 1);
      expect(cartRepo.totalAmount, 180);
    });

    test('Remove item', () {
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      cartRepo.removeItem('1');
      expect(cartRepo.items.length, 0);
      expect(cartRepo.totalAmount, 0.0);
    });

    test('Update quantity', () {
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      cartRepo.updateQuantity('1', 2);
      expect(cartRepo.items.length, 1);
      expect(cartRepo.totalAmount, 180);
    });

    test('Clear cart', () {
      cartRepo.addItem('1', 'Apple iPhone', 100, discount: 0.1);
      cartRepo.clearCart();
      expect(cartRepo.items.length, 0);
      expect(cartRepo.totalAmount, 0.0);
    });
  });
}
