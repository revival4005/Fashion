import 'package:fashion/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the fashion MVP browse flow', (tester) async {
    await tester.pumpWidget(const FashionMvpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Lulu Fashion'), findsWidgets);
    expect(find.text('New Arrivals'), findsOneWidget);
    expect(find.text('Styled Look'), findsOneWidget);
    expect(find.text('Wide Leg Trousers'), findsOneWidget);
    expect(find.text('Mini Shoulder Bag'), findsOneWidget);
  });

  testWidgets('can add a product and place a guest order', (tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exception is NetworkImageLoadException) return;
      originalOnError?.call(details);
    };

    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      FlutterError.onError = originalOnError;
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FashionMvpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, -360));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wide Leg Trousers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout - TZS 55,000'), findsOneWidget);

    await tester.tap(find.text('Checkout - TZS 55,000'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Fadhil');
    await tester.enterText(find.byType(TextFormField).at(1), '255712345678');
    await tester.enterText(find.byType(TextFormField).at(2), 'Dar es Salaam');

    await tester.tap(find.text('Place Order with M-Pesa'));
    await tester.pumpAndSettle();

    expect(find.text('Order confirmed'), findsOneWidget);
    expect(find.text('Total: TZS 55,000'), findsOneWidget);

    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('1 item(s) - TZS 55,000'), findsOneWidget);
    expect(find.text('Delivery to Dar es Salaam'), findsOneWidget);
  });

  testWidgets('profile tab only shows profile details', (tester) async {
    await tester.pumpWidget(const FashionMvpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Profile Details'), findsOneWidget);
    expect(find.text('Wishlist'), findsNothing);
    expect(find.text('Payment'), findsNothing);
    expect(find.text('Filters'), findsNothing);
  });

  testWidgets('shop theme button toggles app theme', (tester) async {
    await tester.pumpWidget(const FashionMvpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Use dark theme'), findsOneWidget);

    await tester.tap(find.byTooltip('Use dark theme'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Use light theme'), findsOneWidget);
  });

  testWidgets('shop search filters products', (tester) async {
    await tester.pumpWidget(const FashionMvpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'bag');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('Mini Shoulder Bag'), findsOneWidget);
    expect(find.text('Canvas Tote Bag'), findsOneWidget);
    expect(find.text('Wide Leg Trousers'), findsNothing);
  });
}
