import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../SetupSettings.dart';

class ChangeModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Transform.scale(
      scale: 1.6,
      child: Switch.adaptive(
        value: themeProvider.getDarkMode(),
        activeColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        },
      ),
    );
  }
}
