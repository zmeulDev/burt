import "package:flutter/material.dart";

// #C1CE73 for illustrations

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284048404),
      surfaceTint: Color(4284048404),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4291812479),
      onPrimaryContainer: Color(4282073856),
      secondary: Color(4284244286),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4293126074),
      onSecondaryContainer: Color(4282862378),
      tertiary: Color(4281035580),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288799914),
      onTertiaryContainer: Color(4278274591),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color.fromRGBO(225, 227, 216, 10),
      onSurface: Color(4279966742),
      onSurfaceVariant: Color(4282796090),
      outline: Color(4286019688),
      outlineVariant: Color(4291283125),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348394),
      inversePrimary: Color(4290891379),
      primaryFixed: Color(4292733580),
      onPrimaryFixed: Color(4279836160),
      primaryFixedDim: Color(4290891379),
      onPrimaryFixedVariant: Color(4282534656),
      secondaryFixed: Color(4292994745),
      onSecondaryFixed: Color(4279901699),
      secondaryFixedDim: Color(4291152543),
      onSecondaryFixedVariant: Color(4282730792),
      tertiaryFixed: Color(4289655735),
      onTertiaryFixed: Color(4278198538),
      tertiaryFixedDim: Color(4287878812),
      onTertiaryFixedVariant: Color(4279063078),
      surfaceDim: Color(4292664016),
      surfaceBright: Color(4294769135),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374633),
      surfaceContainer: Color(4293979875),
      surfaceContainerHigh: Color(4293585118),
      surfaceContainerHighest: Color(4293256152),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282271488),
      surfaceTint: Color(4284048404),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4285495849),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282467621),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285757522),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278603298),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282548816),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color.fromRGBO(225, 227, 216, 10),
      onSurface: Color(4279966742),
      onSurfaceVariant: Color(4282598454),
      outline: Color(4284440657),
      outlineVariant: Color(4286282860),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348394),
      inversePrimary: Color(4290891379),
      primaryFixed: Color(4285495849),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283916561),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285757522),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284112700),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282548816),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280838201),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292664016),
      surfaceBright: Color(4294769135),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374633),
      surfaceContainer: Color(4293979875),
      surfaceContainerHigh: Color(4293585118),
      surfaceContainerHighest: Color(4293256152),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280231168),
      surfaceTint: Color(4284048404),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282271488),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280296455),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282467621),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200590),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278603298),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294769135),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280493337),
      outline: Color(4282598454),
      outlineVariant: Color(4282598454),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348394),
      inversePrimary: Color(4293391508),
      primaryFixed: Color(4282271488),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280889344),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282467621),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281020176),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278603298),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278203668),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292664016),
      surfaceBright: Color(4294769135),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374633),
      surfaceContainer: Color(4293979875),
      surfaceContainerHigh: Color(4293585118),
      surfaceContainerHighest: Color(4293256152),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293786522),
      surfaceTint: Color(4290891379),
      onPrimary: Color(4281152512),
      primaryContainer: Color(4291022964),
      onPrimaryContainer: Color(4281547520),
      secondary: Color(4291152543),
      onSecondary: Color(4281217812),
      secondaryContainer: Color(4282270242),
      onSecondaryContainer: Color(4292139180),
      tertiary: Color(4291559375),
      onTertiary: Color(4278204694),
      tertiaryContainer: Color(4287944606),
      onTertiaryContainer: Color(4278206746),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279440398),
      onSurface: Color(4293256152),
      onSurfaceVariant: Color(4291283125),
      outline: Color(4287730305),
      outlineVariant: Color(4282796090),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293256152),
      inversePrimary: Color(4284048404),
      primaryFixed: Color(4292733580),
      onPrimaryFixed: Color(4279836160),
      primaryFixedDim: Color(4290891379),
      onPrimaryFixedVariant: Color(4282534656),
      secondaryFixed: Color(4292994745),
      onSecondaryFixed: Color(4279901699),
      secondaryFixedDim: Color(4291152543),
      onSecondaryFixedVariant: Color(4282730792),
      tertiaryFixed: Color(4289655735),
      onTertiaryFixed: Color(4278198538),
      tertiaryFixedDim: Color(4287878812),
      onTertiaryFixedVariant: Color(4279063078),
      surfaceDim: Color(4279440398),
      surfaceBright: Color(4281940530),
      surfaceContainerLowest: Color(4279111433),
      surfaceContainerLow: Color(4279966742),
      surfaceContainer: Color(4280295450),
      surfaceContainerHigh: Color(4280953380),
      surfaceContainerHighest: Color(4281677102),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293786522),
      surfaceTint: Color(4290891379),
      onPrimary: Color(4281152512),
      primaryContainer: Color(4291022964),
      onPrimaryContainer: Color(4279309568),
      secondary: Color(4291481251),
      onSecondary: Color(4279506945),
      secondaryContainer: Color(4287599724),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291559375),
      onTertiary: Color(4278204694),
      tertiaryContainer: Color(4287944606),
      onTertiaryContainer: Color(4278195974),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440398),
      onSurface: Color(4294835184),
      onSurfaceVariant: Color(4291611833),
      outline: Color(4288914578),
      outlineVariant: Color(4286809204),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293256152),
      inversePrimary: Color(4282600704),
      primaryFixed: Color(4292733580),
      onPrimaryFixed: Color(4279177984),
      primaryFixedDim: Color(4290891379),
      onPrimaryFixedVariant: Color(4281481728),
      secondaryFixed: Color(4292994745),
      onSecondaryFixed: Color(4279177984),
      secondaryFixedDim: Color(4291152543),
      onSecondaryFixedVariant: Color(4281612569),
      tertiaryFixed: Color(4289655735),
      onTertiaryFixed: Color(4278195461),
      tertiaryFixedDim: Color(4287878812),
      onTertiaryFixedVariant: Color(4278206490),
      surfaceDim: Color(4279440398),
      surfaceBright: Color(4281940530),
      surfaceContainerLowest: Color(4279111433),
      surfaceContainerLow: Color(4279966742),
      surfaceContainer: Color(4280295450),
      surfaceContainerHigh: Color(4280953380),
      surfaceContainerHighest: Color(4281677102),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294639564),
      surfaceTint: Color(4290891379),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4291154551),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294639568),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291481251),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293984237),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4288141984),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440398),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294769896),
      outline: Color(4291611833),
      outlineVariant: Color(4291611833),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293256152),
      inversePrimary: Color(4280757504),
      primaryFixed: Color(4292997008),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4291154551),
      onPrimaryFixedVariant: Color(4279506944),
      secondaryFixed: Color(4293323709),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291481251),
      onSecondaryFixedVariant: Color(4279506945),
      tertiaryFixed: Color(4289984443),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4288141984),
      onTertiaryFixedVariant: Color(4278196999),
      surfaceDim: Color(4279440398),
      surfaceBright: Color(4281940530),
      surfaceContainerLowest: Color(4279111433),
      surfaceContainerLow: Color(4279966742),
      surfaceContainer: Color(4280295450),
      surfaceContainerHigh: Color(4280953380),
      surfaceContainerHighest: Color(4281677102),
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


  List<ExtendedColor> get extendedColors => [
  ];
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

