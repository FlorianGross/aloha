import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DayButton extends StatefulWidget {
  final ValueChanged<bool> onTab;
  final String weekday;
  final double size;
  final double fontSize;
  const DayButton({Key? key, required this.onTab, required this.weekday, required this.size, required this.fontSize})
      : super(key: key);

  @override
  _DayButtonState createState() =>
      _DayButtonState(onTab: onTab, weekday: weekday, size: size, fontSize: fontSize);
}

class _DayButtonState extends State<DayButton> {
  final ValueChanged<bool> onTab;

  _DayButtonState({required this.onTab, required this.weekday, required this.size, required this.fontSize});

  bool _isSelected = true;
  Color _textColor = Colors.black;
  final String weekday;
  final double size;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          if(_isSelected) {
            _textColor = Colors.black;
          }else{
            _textColor = Colors.white;
          }
          });
        onTab.call(_isSelected);
      },
      child: Container(
        child: Center(child: Text(weekday, style: TextStyle(color: _textColor, fontSize: fontSize),)),
        height: size,
        width: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isSelected ? Theme.of(context).primaryColor : Colors.black26),
      ),
    );
  }
}