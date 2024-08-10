import 'package:flutter/cupertino.dart';

class SpacingWidget extends StatelessWidget {
  final double? horizontal;
  final double? vertical;

  const SpacingWidget({
    super.key,
    this.horizontal,
    this.vertical,
  }) : assert(horizontal != null || vertical != null,
            "Spacing Widget requires at least 1 filled attribute");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: vertical,
      width: horizontal,
    );
  }
}
