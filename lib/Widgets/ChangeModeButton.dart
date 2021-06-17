import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SetupSettings.dart';

class ChangeModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}