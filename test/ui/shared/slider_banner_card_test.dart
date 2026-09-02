import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:bondly_app/ui/shared/slider_dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
      theme: ThemeData(extensions: const [BondlyColorScheme.light]),
      home: Scaffold(body: child),
    );

int _activeIndex(WidgetTester tester) => tester
    .widget<SliderDotsIndicator>(find.byType(SliderDotsIndicator))
    .activeIndex;

FocusNode _sliderFocusNode(WidgetTester tester) => tester
    .widget<Focus>(find.byWidgetPredicate((widget) =>
        widget is Focus && widget.focusNode?.debugLabel == 'SliderBannerCard'))
    .focusNode!;

void main() {
  testWidgets('renders loading, error, and empty states', (tester) async {
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [],
      isLoading: true,
    )));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [],
      errorMessage: 'No se pudo cargar',
    )));
    expect(find.text('No se pudo cargar'), findsOneWidget);

    await tester.pumpWidget(_host(const SliderBannerCard(items: [])));
    expect(find.text('No hay novedades disponibles'), findsOneWidget);
  });

  testWidgets('shows controls only for multiple items and supports keyboard',
      (tester) async {
    const one = BannerItem(title: 'Único');
    await tester.pumpWidget(_host(const SliderBannerCard(items: [one])));
    expect(find.byTooltip('Anterior'), findsNothing);
    expect(find.byTooltip('Siguiente'), findsNothing);

    const two = [BannerItem(title: 'Primero'), BannerItem(title: 'Segundo')];
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: two,
      autoPlayDuration: Duration(hours: 1),
    )));
    expect(find.byTooltip('Anterior'), findsOneWidget);
    expect(find.byTooltip('Siguiente'), findsOneWidget);
    expect(find.byType(SliderDotsIndicator), findsOneWidget);

    final focus = _sliderFocusNode(tester);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Segundo', skipOffstage: false), findsOneWidget);
    expect(_activeIndex(tester), 1);
  });

  testWidgets('updates asynchronously and autoplay advances', (tester) async {
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [],
      autoPlayDuration: Duration(milliseconds: 500),
    )));
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [BannerItem(title: 'A'), BannerItem(title: 'B')],
      autoPlayDuration: Duration(milliseconds: 500),
    )));
    FocusManager.instance.primaryFocus?.unfocus(
      disposition: UnfocusDisposition.scope,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_activeIndex(tester), 1);
  });

  testWidgets('touch does not acquire focus and swipe updates the indicator',
      (tester) async {
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [BannerItem(title: 'A'), BannerItem(title: 'B')],
      autoPlayDuration: Duration(hours: 1),
    )));

    final card = find.byType(SliderBannerCard);
    await tester.tap(card);
    expect(_sliderFocusNode(tester).hasFocus, isFalse);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(_activeIndex(tester), 1);
  });

  testWidgets('autoplay pauses for hover, focus, and touch, then resumes',
      (tester) async {
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [
        BannerItem(title: 'A'),
        BannerItem(title: 'B'),
        BannerItem(title: 'C'),
      ],
      autoPlayDuration: Duration(milliseconds: 500),
    )));
    final card = find.byType(SliderBannerCard);
    final focus = _sliderFocusNode(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(card));
    await tester.pump(const Duration(milliseconds: 550));
    expect(_activeIndex(tester), 0);
    await mouse.moveTo(const Offset(500, 500));
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_activeIndex(tester), 1);

    focus.requestFocus();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    expect(_activeIndex(tester), 1);
    focus.unfocus();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_activeIndex(tester), 2);

    final gesture = await tester.startGesture(tester.getCenter(card));
    await tester.pump(const Duration(milliseconds: 550));
    expect(_activeIndex(tester), 2);
    await gesture.cancel();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_activeIndex(tester), 0);
  });

  testWidgets('keeps the overlay and content when an image is unavailable',
      (tester) async {
    await tester.pumpWidget(_host(const SliderBannerCard(
      items: [
        BannerItem(
          title: 'Visible on image failure',
          image: 'https://invalid.example/banner.png',
        ),
      ],
    )));

    expect(find.text('Visible on image failure'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(DecoratedBox),
      ),
      findsWidgets,
    );
  });
}
