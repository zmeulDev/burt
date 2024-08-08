import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4283196004),
      surfaceTint: Color(4283196004),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290762713),
      onPrimaryContainer: Color(4281090628),
      secondary: Color(4283916385),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292864232),
      onSecondaryContainer: Color(4282600524),
      tertiary: Color(4284505199),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292202470),
      onTertiaryContainer: Color(4282334286),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294638072),
      onSurface: Color(4279966748),
      onSurfaceVariant: Color(4282533960),
      outline: Color(4285692025),
      outlineVariant: Color(4290955464),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4289973197),
      primaryFixed: Color(4291815401),
      onPrimaryFixed: Color(4278722337),
      primaryFixedDim: Color(4289973197),
      onPrimaryFixedVariant: Color(4281682508),
      secondaryFixed: Color(4292601061),
      onSecondaryFixed: Color(4279573790),
      secondaryFixedDim: Color(4290758857),
      onSecondaryFixedVariant: Color(4282402889),
      tertiaryFixed: Color(4293320695),
      onTertiaryFixed: Color(4280031530),
      tertiaryFixedDim: Color(4291412954),
      onTertiaryFixedVariant: Color(4282926167),
      surfaceDim: Color(4292598489),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294308851),
      surfaceContainer: Color(4293914093),
      surfaceContainerHigh: Color(4293519591),
      surfaceContainerHighest: Color(4293124834),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281419592),
      surfaceTint: Color(4283196004),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284643707),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282139717),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285363831),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282662995),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285952646),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294638072),
      onSurface: Color(4279966748),
      onSurfaceVariant: Color(4282270788),
      outline: Color(4284112993),
      outlineVariant: Color(4285955196),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4289973197),
      primaryFixed: Color(4284643707),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283064418),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285363831),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283784798),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285952646),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284307821),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292598489),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294308851),
      surfaceContainer: Color(4293914093),
      surfaceContainerHigh: Color(4293519591),
      surfaceContainerHighest: Color(4293124834),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4279182887),
      surfaceTint: Color(4283196004),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281419592),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279968804),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282139717),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280492081),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282662995),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294638072),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280231205),
      outline: Color(4282270788),
      outlineVariant: Color(4282270788),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4292407795),
      primaryFixed: Color(4281419592),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4279906354),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282139717),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280692271),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282662995),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281150012),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292598489),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294308851),
      surfaceContainer: Color(4293914093),
      surfaceContainerHigh: Color(4293519591),
      surfaceContainerHighest: Color(4293124834),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292736760),
      surfaceTint: Color(4289973197),
      onPrimary: Color(4280169526),
      primaryContainer: Color(4289973197),
      onPrimaryContainer: Color(4280564284),
      secondary: Color(4290758857),
      onSecondary: Color(4280955443),
      secondaryContainer: Color(4281942338),
      onSecondaryContainer: Color(4291745495),
      tertiary: Color(4294242303),
      onTertiary: Color(4281413184),
      tertiaryContainer: Color(4291478747),
      onTertiaryContainer: Color(4281807942),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279374868),
      onSurface: Color(4293124834),
      onSurfaceVariant: Color(4290955464),
      outline: Color(4287402642),
      outlineVariant: Color(4282533960),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124834),
      inversePrimary: Color(4283196004),
      primaryFixed: Color(4291815401),
      onPrimaryFixed: Color(4278722337),
      primaryFixedDim: Color(4289973197),
      onPrimaryFixedVariant: Color(4281682508),
      secondaryFixed: Color(4292601061),
      onSecondaryFixed: Color(4279573790),
      secondaryFixedDim: Color(4290758857),
      onSecondaryFixedVariant: Color(4282402889),
      tertiaryFixed: Color(4293320695),
      onTertiaryFixed: Color(4280031530),
      tertiaryFixedDim: Color(4291412954),
      onTertiaryFixedVariant: Color(4282926167),
      surfaceDim: Color(4279374868),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045646),
      surfaceContainerLow: Color(4279966748),
      surfaceContainer: Color(4280229920),
      surfaceContainerHigh: Color(4280887850),
      surfaceContainerHighest: Color(4281611573),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292736760),
      surfaceTint: Color(4289973197),
      onPrimary: Color(4280169526),
      primaryContainer: Color(4289973197),
      onPrimaryContainer: Color(4278195478),
      secondary: Color(4291087565),
      onSecondary: Color(4279244824),
      secondaryContainer: Color(4287271571),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294242303),
      onTertiary: Color(4281413184),
      tertiaryContainer: Color(4291478747),
      onTertiaryContainer: Color(4279373856),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374868),
      onSurface: Color(4294769402),
      onSurfaceVariant: Color(4291218636),
      outline: Color(4288586916),
      outlineVariant: Color(4286481541),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124834),
      inversePrimary: Color(4281748558),
      primaryFixed: Color(4291815401),
      onPrimaryFixed: Color(4278195222),
      primaryFixedDim: Color(4289973197),
      onPrimaryFixedVariant: Color(4280564284),
      secondaryFixed: Color(4292601061),
      onSecondaryFixed: Color(4278850323),
      secondaryFixedDim: Color(4290758857),
      onSecondaryFixedVariant: Color(4281284664),
      tertiaryFixed: Color(4293320695),
      onTertiaryFixed: Color(4279373599),
      tertiaryFixedDim: Color(4291412954),
      onTertiaryFixedVariant: Color(4281807942),
      surfaceDim: Color(4279374868),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045646),
      surfaceContainerLow: Color(4279966748),
      surfaceContainer: Color(4280229920),
      surfaceContainerHigh: Color(4280887850),
      surfaceContainerHighest: Color(4281611573),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293852927),
      surfaceTint: Color(4289973197),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4290236369),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294245629),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291087565),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294900223),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291676382),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374868),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294376700),
      outline: Color(4291218636),
      outlineVariant: Color(4291218636),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124834),
      inversePrimary: Color(4279708975),
      primaryFixed: Color(4292078573),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4290236369),
      onPrimaryFixedVariant: Color(4278393115),
      secondaryFixed: Color(4292929769),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291087565),
      onSecondaryFixedVariant: Color(4279244824),
      tertiaryFixed: Color(4293583867),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291676382),
      onTertiaryFixedVariant: Color(4279702564),
      surfaceDim: Color(4279374868),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045646),
      surfaceContainerLow: Color(4279966748),
      surfaceContainer: Color(4280229920),
      surfaceContainerHigh: Color(4280887850),
      surfaceContainerHighest: Color(4281611573),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

enum AppTheme {
  Light,
  Dark,
}
