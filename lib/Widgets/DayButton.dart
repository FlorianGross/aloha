import 'package:flutter/material.dart';

class DayButton extends StatefulWidget {
  final ValueChanged<bool> onTab;
  final String weekday;
  final double size;

  const DayButton({Key? key, required this.onTab, required this.weekday, required this.size})
      : super(key: key);

  @override
  _DayButtonState createState() =>
      _DayButtonState(onTab: onTab, weekday: weekday, size: size);
}

class _DayButtonState extends State<DayButton> {
  final ValueChanged<bool> onTab;

  _DayButtonState({required this.onTab, required this.weekday, required this.size});

  bool _isSelected = true;
  Color _textColor = Colors.black;
  final String weekday;
  final double size;
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
        child: Center(child: Text(weekday, style: TextStyle(color: _textColor),)),
        height: size,
        width: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isSelected ? Colors.yellow : Colors.black26),
      ),
    );
  }
}