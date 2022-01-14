import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditText extends StatefulWidget {
  const EditText({Key? key}) : super(key: key);

  @override
  EditTextState createState() => EditTextState();

  String getText() {
    return EditTextState().myController.text;
  }

}

class EditTextState extends State<EditText> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  String getText() {
    return myController.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      height: 48.0,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        color: Colors.white,
      ),
      child: TextFormField(
          controller: myController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
          ]
      ),
    );

  }
}