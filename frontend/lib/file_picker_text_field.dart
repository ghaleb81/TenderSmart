import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerTextField extends StatefulWidget {
  @override
  _FilePickerTextFieldState createState() => _FilePickerTextFieldState();
}

class _FilePickerTextFieldState extends State<FilePickerTextField> {
  String? fileName;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //textfieldيجعل gestureDetector يتصرف كزر
      onTap: pickFile,
      child: AbsorbPointer(
        //لمنع الكتابة في textfield
        child: TextField(
          decoration: InputDecoration(
            labelText: 'اختر ملف',
            hintText: fileName ?? 'اضغط لاختيار ملف',
            suffixIcon: Icon(Icons.attach_file),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
