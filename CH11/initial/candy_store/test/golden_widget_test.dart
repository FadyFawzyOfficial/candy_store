import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'goldens/candy_shop_golden_test_widgets_page.dart';

//! main(): The entry point of our test file.
void main() {
  //! testWidget(): Defines a single widget test case.
  testWidgets('Golden test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    //! pumpWidget(): Renders the widget under test.
    await tester
        .pumpWidget(const MaterialApp(home: CandyShopGoldenTestWidgetsPage()));

    await tester.pumpAndSettle();

    await expectLater(
      //! find() Locates widgets in the widget tree.
      find.byType(CandyShopGoldenTestWidgetsPage),
      matchesGoldenFile('goldens/candy_shop_widgets.png'),
    );
  });
}
