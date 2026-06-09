import 'package:all_benefits_group/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('completes insurance purchase flow', (tester) async {
    await tester.pumpWidget(const AllBenefitsApp(hasSeenOnboarding: true));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Seguros'), findsOneWidget);

    await tester.tap(find.text('Seguros'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Cotiza un seguro'), findsOneWidget);
    final detailButton = find.widgetWithText(TextButton, 'Ver detalle').first;
    await tester.ensureVisible(detailButton);
    tester.widget<TextButton>(detailButton).onPressed!.call();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Detalle del producto'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Iniciar cotizacion'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Iniciar cotizacion'),
        )
        .onPressed!
        .call();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Cotizacion guiada'), findsOneWidget);
    tester
        .widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, 'Cobertura familiar'),
        )
        .onSelected!
        .call(true);
    await tester.pump(const Duration(milliseconds: 500));
    tester
        .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Toda mi familia'))
        .onSelected!
        .call(true);
    await tester.pump(const Duration(milliseconds: 500));
    tester
        .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '\$150 - \$250'))
        .onSelected!
        .call(true);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.scrollUntilVisible(
      find.text('Continuar al checkout'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Continuar al checkout'),
        )
        .onPressed!
        .call();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Checkout seguro'), findsOneWidget);
    tester
        .widget<InkWell>(
          find
              .ancestor(
                of: find.text('Google Pay'),
                matching: find.byType(InkWell),
              )
              .first,
        )
        .onTap!
        .call();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.scrollUntilVisible(
      find.text('Confirmar compra'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Confirmar compra'),
        )
        .onPressed!
        .call();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Solicitud enviada'), findsOneWidget);
    expect(find.text('Google Pay'), findsOneWidget);
  });
}
