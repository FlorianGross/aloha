import 'package:flutter/material.dart';

class AddCustomDrinkButton extends StatefulWidget {
  const AddCustomDrinkButton({Key? key, required this.width, required this.height, required this.id, required this.onTap}) : super(key: key);
  final double height, width;
  final int id;
  final onTap;
  @override
  _AddCustomDrinkButtonState createState() => _AddCustomDrinkButtonState(height: height, width: width, id: id, onTap: onTap);
}

class _AddCustomDrinkButtonState extends State<AddCustomDrinkButton> {
  _AddCustomDrinkButtonState({required this.height, required this.width, required this.id, required this.onTap});
  final double height;
  final int id;
  final double width;
  final onTap;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sonstiges")
            ],
          ),
        ),
      ),
    );
  }

}
