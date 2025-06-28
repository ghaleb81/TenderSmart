import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerTextField extends StatefulWidget {
  final void Function(File file) onFilePicked;

  const FilePickerTextField({
    super.key,
    required this.onFilePicked,
    required String label,
  });

  @override
  State<FilePickerTextField> createState() => _FilePickerTextFieldState();
}

class _FilePickerTextFieldState extends State<FilePickerTextField> {
  String? _fileName;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      setState(() {
        _fileName = file.path.split('/').last;
      });

      widget.onFilePicked(file); // ترجيع الملف إلى الأب
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: Text('اختيار ملف العرض الفني'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            _fileName ?? 'لم يتم اختيار أي ملف',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class FilePickerTextField extends StatefulWidget {
//   @override
//   _FilePickerTextFieldState createState() => _FilePickerTextFieldState();
// }

// class _FilePickerTextFieldState extends State<FilePickerTextField> {
//   String? fileName;

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         fileName = result.files.single.name;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       //textfieldيجعل gestureDetector يتصرف كزر
//       onTap: pickFile,
//       child: AbsorbPointer(
//         //لمنع الكتابة في textfield
//         child: TextField(
//           decoration: InputDecoration(
//             labelText: 'اختر ملف',
//             hintText: fileName ?? 'اضغط لاختيار ملف',
//             suffixIcon: Icon(Icons.attach_file),
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ),
//     );
//   }
// }
