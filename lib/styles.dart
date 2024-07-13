import 'package:flutter/material.dart';

const TextStyle headingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const TextStyle subheadingTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.grey,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const EdgeInsets cardPadding = EdgeInsets.all(16.0);

BoxDecoration cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      spreadRadius: 1.0,
      offset: Offset(0, 3),
    ),
  ],
);
