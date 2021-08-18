import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Component extends StatefulWidget {
  const Component({Key? key}) : super(key: key);

  @override
  _ComponentState createState() => _ComponentState();
}

class _ComponentState extends State<Component> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Text buildText(String text, double fontSize, FontWeight fontWeight, {Color? color, String? hexColor}) {
    dynamic newCol;
    if(color != null )  newCol = color;
    else if(hexColor != null) newCol = HexColor(hexColor);
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Lato',
        color: newCol,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  TextFormField buildTextFormField(String inputText, double fontSize, FontWeight fontWeight) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: inputText,
      ),
      style: TextStyle(
        fontFamily: 'Lato',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }



}