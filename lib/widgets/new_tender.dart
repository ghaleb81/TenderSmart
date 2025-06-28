import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/tender_service.dart';

class NewTender extends StatefulWidget {
  const NewTender({super.key, this.existingTender});

  final Tender? existingTender;

  @override
  State<NewTender> createState() => _NewTenderState();
}

class _NewTenderState extends State<NewTender> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleC;
  late final TextEditingController _descrC;
  late final TextEditingController _locC;
  late final TextEditingController _budgetC;
  late final TextEditingController _techC;
  late final TextEditingController _periodC;

  DateTime? _deadline;
  StateOfTender _state = StateOfTender.opened;

  File? _pdfFile; // ⬅️ استبدل Uint8List بــ File
  String? _pdfName;

  bool _saving = false;
  bool get _isEdit => widget.existingTender != null;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTender;
    _titleC = TextEditingController(text: t?.title ?? '');
    _descrC = TextEditingController(text: t?.descripe ?? '');
    _locC = TextEditingController(text: t?.location ?? '');
    _budgetC = TextEditingController(text: t?.budget.toString() ?? '');
    _techC = TextEditingController(
      text: t?.numberOfTechnicalConditions.toString() ?? '',
    );
    _periodC = TextEditingController(
      text: t?.implementationPeriod.toString() ?? '',
    );
    _deadline = t?.registrationDeadline;
    _state = t?.stateOfTender ?? StateOfTender.opened;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descrC.dispose();
    _locC.dispose();
    _budgetC.dispose();
    _techC.dispose();
    _periodC.dispose();
    super.dispose();
  }

  // اختيار ملف PDF من الذاكرة المحلية
  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
        _pdfName = result.files.single.name;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إكمال الحقول المطلوبة')),
      );
      return;
    }

    final tender = Tender(
      id: widget.existingTender?.id,
      title: _titleC.text,
      descripe: _descrC.text,
      location: _locC.text,
      implementationPeriod: int.tryParse(_periodC.text) ?? 0,
      numberOfTechnicalConditions: int.tryParse(_techC.text) ?? 0,
      registrationDeadline: _deadline!,
      stateOfTender: _state,
      budget: double.tryParse(_budgetC.text) ?? 0,
    );

    setState(() => _saving = true);
    try {
      if (_isEdit) {
        await TenderService.updateTender(
          tender,
          technicalFile: _pdfFile,
          technicalFileName: _pdfName,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعديل المناقصة بنجاح')),
        );
      } else {
        await TenderService.addTender(
          tender,
          technicalFile: _pdfFile,
          technicalFileName: _pdfName,
        );
        if (!mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة المناقصة بنجاح')),
          );
        }
      }
      Navigator.pushReplacementNamed(context, '/tendersScreen');
      // Navigator.pop(context, tender);
    } catch (e, st) {
      log('Tender save error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          // title: const Text(
          //   'تفاصيل المناقصة ',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: Colors.white,
          //   ),
          // ),
          title: Text(
            _isEdit ? 'تعديل المناقصة' : 'إضافة مناقصة جديدة',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          // centerTitle: true,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        //   backgroundColor: const Color(0xfff2f3f7),
        //   appBar: AppBar(
        //     backgroundColor: const Color(0xff005b96),
        //     title: Text(
        //       _isEdit ? 'تعديل المناقصة' : 'إضافة مناقصة جديدة',
        //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        //     ),
        //     centerTitle: true,
        //   ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_titleC, 'عنوان المناقصة'),
                        _buildTextField(_descrC, 'وصف المناقصة', maxLines: 3),
                        _buildTextField(_locC, 'موقع التنفيذ'),
                        _buildNumberField(_periodC, 'مدة التنفيذ بالأيام'),
                        _buildNumberField(_techC, 'عدد الشروط الفنية'),
                        _buildNumberField(
                          _budgetC,
                          'الميزانية المتوقعة',
                          prefix: 'S.P ',
                        ),
                        const SizedBox(height: 16),
                        _buildDatePicker(),
                        const SizedBox(height: 16),
                        _buildStateDropdown(),
                        const SizedBox(height: 16),
                        _buildPDFPicker(),
                        const SizedBox(height: 25),
                        _buildButtons(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Widgets Helpers -------------------- //

  Widget _buildTextField(
    TextEditingController c,
    String label, {
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: c,
      maxLines: maxLines,
      validator:
          (v) => v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xfff9fafc),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  Widget _buildNumberField(
    TextEditingController c,
    String label, {
    String? prefix,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        filled: true,
        fillColor: const Color(0xfff9fafc),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  Widget _buildDatePicker() => ListTile(
    tileColor: const Color(0xfff9fafc),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Colors.grey),
    ),
    title: Text(
      _deadline == null
          ? 'اختر تاريخ إغلاق التسجيل'
          : 'تاريخ الإغلاق: ${DateFormat.yMMMMd('ar').format(_deadline!)}',
    ),
    trailing: const Icon(Icons.calendar_month),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: _deadline ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) setState(() => _deadline = picked);
    },
  );

  Widget _buildStateDropdown() => DropdownButtonFormField<StateOfTender>(
    value: _state,
    decoration: InputDecoration(
      labelText: 'حالة المناقصة',
      filled: true,
      fillColor: const Color(0xfff9fafc),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    items:
        StateOfTender.values
            .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
            .toList(),
    onChanged: (val) => setState(() => _state = val ?? _state),
  );

  Widget _buildPDFPicker() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton.icon(
        onPressed: _pickPDF,
        icon: const Icon(Icons.attach_file),
        label: const Text('إرفاق ملف PDF'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0077b6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      if (_pdfName != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('تم اختيار الملف: $_pdfName'),
        ),
    ],
  );

  Widget _buildButtons(ThemeData theme) => Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _saving ? null : _submit,
          icon: const Icon(Icons.save),
          label: Text(_isEdit ? 'حفظ التعديلات' : 'إضافة المناقصة'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xff005b96),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/tendersScreen');
          },
          // icon: const Icon(Icons.save),
          // label: Text('إلغاء'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xff005b96),
            foregroundColor: Colors.white,

            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(12),
            // ),
          ),
          child: Text('إلغاء'),
        ),
      ),
    ],
  );
}

// class NewTender extends StatefulWidget {
//   const NewTender({super.key, this.existingTender});

//   final Tender? existingTender;

//   @override
//   State<NewTender> createState() => _NewTenderState();
// }

// class _NewTenderState extends State<NewTender> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _titleC;
//   late final TextEditingController _descrC;
//   late final TextEditingController _locC;
//   late final TextEditingController _budgetC;
//   late final TextEditingController _techC;
//   late final TextEditingController _periodC;

//   DateTime? _deadline;
//   StateOfTender _state = StateOfTender.opened;

//   Uint8List? _pdfBytes;
//   String? _pdfName;

//   bool _saving = false;

//   bool get _isEdit => widget.existingTender != null;

//   @override
//   void initState() {
//     super.initState();
//     final t = widget.existingTender;
//     _titleC = TextEditingController(text: t?.title ?? '');
//     _descrC = TextEditingController(text: t?.descripe ?? '');
//     _locC = TextEditingController(text: t?.location ?? '');
//     _budgetC = TextEditingController(text: t?.budget.toString() ?? '');
//     _techC = TextEditingController(
//       text: t?.numberOfTechnicalConditions.toString() ?? '',
//     );
//     _periodC = TextEditingController(
//       text: t?.implementationPeriod.toString() ?? '',
//     );
//     _deadline = t?.registrationDeadline;
//     _state = t?.stateOfTender ?? StateOfTender.opened;
//   }

//   @override
//   void dispose() {
//     _titleC.dispose();
//     _descrC.dispose();
//     _locC.dispose();
//     _budgetC.dispose();
//     _techC.dispose();
//     _periodC.dispose();
//     super.dispose();
//   }

//   Future<void> _pickPDF() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (result != null && result.files.single.bytes != null) {
//       setState(() {
//         _pdfBytes = result.files.single.bytes!;
//         _pdfName = result.files.single.name;
//       });
//     }
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate() || _deadline == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إكمال الحقول المطلوبة')),
//       );
//       return;
//     }

//     final tender = Tender(
//       id: widget.existingTender?.id,
//       title: _titleC.text,
//       descripe: _descrC.text,
//       location: _locC.text,
//       implementationPeriod: int.tryParse(_periodC.text) ?? 0,
//       numberOfTechnicalConditions: int.tryParse(_techC.text) ?? 0,
//       registrationDeadline: _deadline!,
//       stateOfTender: _state,
//       budget: double.tryParse(_budgetC.text) ?? 0,
//     );

//     setState(() => _saving = true);

//     try {
//       if (_isEdit) {
//         await TenderService.updateTender(
//           tender,
//           technicalFileBytes: _pdfBytes,
//           technicalFileName: _pdfName,
//         );
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تم تعديل المناقصة بنجاح')),
//         );
//       } else {
//         await TenderService.addTender(
//           tender,
//           technicalFileBytes: _pdfBytes,
//           technicalFileName: _pdfName,
//         );
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تمت إضافة المناقصة بنجاح')),
//         );
//         Navigator.pushReplacementNamed(context, '/tendersScreen');
//       }
//       Navigator.pop(context, tender);
//     } catch (e, st) {
//       log('Tender save error: $e\n$st');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Directionality(
//       textDirection: ui.TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: const Color(0xfff2f3f7),
//         appBar: AppBar(
//           backgroundColor: const Color(0xff005b96),
//           title: Text(
//             _isEdit ? 'تعديل المناقصة' : 'إضافة مناقصة جديدة',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 700),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 elevation: 8,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         _buildTextField(_titleC, 'عنوان المناقصة'),
//                         _buildTextField(_descrC, 'وصف المناقصة', maxLines: 3),
//                         _buildTextField(_locC, 'موقع التنفيذ'),
//                         _buildNumberField(_periodC, 'مدة التنفيذ بالأيام'),
//                         _buildNumberField(_techC, 'عدد الشروط الفنية'),
//                         _buildNumberField(
//                           _budgetC,
//                           'الميزانية المتوقعة',
//                           prefix: 'S.P ',
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDatePicker(),
//                         const SizedBox(height: 16),
//                         _buildStateDropdown(),
//                         const SizedBox(height: 16),
//                         _buildPDFPicker(),
//                         const SizedBox(height: 25),
//                         _buildButtons(theme),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // -------------------- Widgets Helpers -------------------- //

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         validator:
//             (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: const Color(0xfff9fafc),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     TextEditingController controller,
//     String label, {
//     String? prefix,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixText: prefix,
//           filled: true,
//           fillColor: const Color(0xfff9fafc),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return ListTile(
//       tileColor: const Color(0xfff9fafc),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: Colors.grey),
//       ),
//       title: Text(
//         _deadline == null
//             ? 'اختر تاريخ إغلاق التسجيل'
//             : 'تاريخ الإغلاق: ${DateFormat.yMMMMd('ar').format(_deadline!)}',
//         style: const TextStyle(fontSize: 16),
//       ),
//       trailing: const Icon(Icons.calendar_month),
//       onTap: () async {
//         final picked = await showDatePicker(
//           context: context,
//           initialDate: _deadline ?? DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2100),
//         );
//         if (picked != null) setState(() => _deadline = picked);
//       },
//     );
//   }

//   Widget _buildStateDropdown() {
//     return DropdownButtonFormField<StateOfTender>(
//       value: _state,
//       decoration: InputDecoration(
//         labelText: 'حالة المناقصة',
//         filled: true,
//         fillColor: const Color(0xfff9fafc),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       items:
//           StateOfTender.values
//               .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
//               .toList(),
//       onChanged: (val) => setState(() => _state = val ?? _state),
//     );
//   }

//   Widget _buildPDFPicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton.icon(
//           onPressed: _pickPDF,
//           icon: const Icon(Icons.attach_file),
//           label: const Text('إرفاق ملف PDF'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xff0077b6),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         if (_pdfName != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Text(
//               'تم اختيار الملف: $_pdfName',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildButtons(ThemeData theme) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: _saving ? null : _submit,
//             icon: const Icon(Icons.save),
//             label: Text(_isEdit ? 'حفظ التعديلات' : 'إضافة المناقصة'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: const Color(0xff005b96),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/tendersScreen');
//             },
//             // icon: const Icon(Icons.save),
//             // label: Text('إلغاء'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: const Color(0xff005b96),
//               foregroundColor: Colors.white,

//               // shape: RoundedRectangleBorder(
//               //   borderRadius: BorderRadius.circular(12),
//               // ),
//             ),
//             child: Text('إلغاء'),
//           ),
//         ),
//       ],
//     );
//   }
// }
// class NewTender extends StatefulWidget {
//   const NewTender({super.key});

//   @override
//   State<NewTender> createState() => _NewTenderState();
// }

// class _NewTenderState extends State<NewTender> {
//   final _formKey = GlobalKey<FormState>();

//   final _titleC = TextEditingController();
//   final _descrC = TextEditingController();
//   final _locC = TextEditingController();
//   final _budgetC = TextEditingController();
//   final _techC = TextEditingController();
//   final _periodC = TextEditingController();

//   DateTime? _deadline;
//   StateOfTender _state = StateOfTender.opened;

//   Uint8List? _pdfBytes;
//   String? _pdfName;

//   Future<void> _pickPDF() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (result != null && result.files.single.bytes != null) {
//       setState(() {
//         _pdfBytes = result.files.single.bytes!;
//         _pdfName = result.files.single.name;
//       });
//     }
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate() || _deadline == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إكمال الحقول المطلوبة')),
//       );
//       return;
//     }

//     final tender = Tender(
//       title: _titleC.text,
//       descripe: _descrC.text,
//       location: _locC.text,
//       implementationPeriod: int.tryParse(_periodC.text) ?? 0,
//       numberOfTechnicalConditions: int.tryParse(_techC.text) ?? 0,
//       registrationDeadline: _deadline!,
//       stateOfTender: _state,
//       budget: double.tryParse(_budgetC.text) ?? 0,
//     );

//     try {
//       await TenderService.addTender(
//         tender,
//         technicalFileBytes: _pdfBytes,
//         technicalFileName: _pdfName,
//       );
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
//         Navigator.pushReplacementNamed(context, '/tendersScreen');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('خطأ أثناء الإضافة: $e')));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: ui.TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: const Color(0xfff2f3f7),
//         appBar: AppBar(
//           backgroundColor: const Color(0xff005b96),
//           title: const Text(
//             'إضافة مناقصة جديدة',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 700),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 elevation: 8,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         _buildTextField(_titleC, 'عنوان المناقصة'),
//                         _buildTextField(_descrC, 'وصف المناقصة', maxLines: 3),
//                         _buildTextField(_locC, 'موقع التنفيذ'),
//                         _buildNumberField(_periodC, 'مدة التنفيذ بالأيام'),
//                         _buildNumberField(_techC, 'عدد الشروط الفنية'),
//                         _buildNumberField(
//                           _budgetC,
//                           'الميزانية المتوقعة',
//                           prefix: 'S.P ',
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDatePicker(),
//                         const SizedBox(height: 16),
//                         _buildStateDropdown(),
//                         const SizedBox(height: 16),
//                         _buildPDFPicker(),
//                         const SizedBox(height: 25),
//                         _buildSubmitButton(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         validator:
//             (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: const Color(0xfff9fafc),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     TextEditingController controller,
//     String label, {
//     String? prefix,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixText: prefix,
//           filled: true,
//           fillColor: const Color(0xfff9fafc),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return ListTile(
//       tileColor: const Color(0xfff9fafc),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: Colors.grey),
//       ),
//       title: Text(
//         _deadline == null
//             ? 'اختر تاريخ إغلاق التسجيل'
//             : 'تاريخ الإغلاق: ${DateFormat.yMMMMd('ar').format(_deadline!)}',
//         style: const TextStyle(fontSize: 16),
//       ),
//       trailing: const Icon(Icons.calendar_month),
//       onTap: () async {
//         final picked = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2100),
//         );
//         if (picked != null) setState(() => _deadline = picked);
//       },
//     );
//   }

//   Widget _buildStateDropdown() {
//     return DropdownButtonFormField<StateOfTender>(
//       value: _state,
//       decoration: InputDecoration(
//         labelText: 'حالة المناقصة',
//         filled: true,
//         fillColor: const Color(0xfff9fafc),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       items:
//           StateOfTender.values.map((state) {
//             return DropdownMenuItem(value: state, child: Text(state.name));
//           }).toList(),
//       onChanged: (val) {
//         if (val != null) setState(() => _state = val);
//       },
//     );
//   }

//   Widget _buildPDFPicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton.icon(
//           onPressed: _pickPDF,
//           icon: const Icon(Icons.attach_file),
//           label: const Text('إرفاق ملف PDF'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xff0077b6),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         if (_pdfName != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Text(
//               'تم اختيار الملف: $_pdfName',
//               style: const TextStyle(color: Colors.green),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/tendersScreen');
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               backgroundColor: const Color(0xff023e8a),
//               foregroundColor: Colors.white,
//               textStyle: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: const Text('إلغاء الإرسال'),
//           ),
//         ),
//         SizedBox(height: 20),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: _submit,

//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               backgroundColor: const Color(0xff023e8a),
//               foregroundColor: Colors.white,
//               textStyle: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: const Text('إرسال المناقصة'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:developer';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/services/tender_service.dart';

// class NewTender extends StatefulWidget {
//   const NewTender({
//     super.key,
//     // required this.onAddTender,
//     // required this.tendersFuture,
//   });
//   // final void Function(Tender tender) onAddTender;
//   // Future<List<Tender>> tendersFuture;
//   @override
//   State<NewTender> createState() => _NewTenderState();
// }

// class _NewTenderState extends State<NewTender> {
//   final _titleController = TextEditingController();
//   final _descripeController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _implmentationPeriodController = TextEditingController();
//   final _numberOfTechnicalConditionsController = TextEditingController();
//   final _budgetController = TextEditingController();
//   final formatter = DateFormat.yMd();
//   // DateTime? _expectedStartTime;
//   DateTime? _registrationDeadline;
//   StateOfTender _selectedState = StateOfTender.opened;

//   @override
//   void dispose() {
//     super.dispose();
//     _titleController.dispose();
//     _budgetController.dispose();
//     _descripeController.dispose();
//     _implmentationPeriodController.dispose();
//     _numberOfTechnicalConditionsController.dispose();
//     _locationController.dispose();
//   } //لتدمير الكونتولار بعد الانتهاء من العمل

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: ui.TextDirection.rtl,
//       child: Scaffold(
//         body: Padding(
//           padding: EdgeInsets.only(
//             top: 16,
//             left: 16,
//             right: 16,
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextField(
//                   decoration: InputDecoration(label: Text('العنوان')),
//                   // onChanged: _saveChangeTitle,
//                   controller: _titleController,
//                   maxLength: 75,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(label: Text('الوصف')),
//                   // onChanged: _saveChangeTitle,
//                   controller: _descripeController,
//                   // maxLength: ,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(label: Text('الموقع')),
//                   // onChanged: _saveChangeTitle,
//                   controller: _locationController,
//                   keyboardType: TextInputType.streetAddress,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                     label: Text('وقت التنفيذ(بالأيام)'),
//                   ),
//                   // onChanged: _saveChangeTitle,
//                   controller: _implmentationPeriodController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: false),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(label: Text('عدد الشروط الفنية')),
//                   // onChanged: _saveChangeTitle,
//                   controller: _numberOfTechnicalConditionsController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: false),
//                 ),
//                 TextField(
//                   controller: _budgetController,
//                   keyboardType:
//                       TextInputType
//                           .number, // ال لتعريف نمط المدخلات التي سيدخلها المستخدم
//                   decoration: InputDecoration(
//                     prefixText: 'ٍS.P', //لوضع شيء ثابت قبل النص المدخل
//                     label: Text('الميزانية'),
//                   ),
//                   // onChanged: _saveChangeTitle,
//                 ),
//                 Row(
//                   children: [
//                     // Flexible(
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.end,
//                     //     children: [
//                     //       Text(
//                     //         _expectedStartTime == null
//                     //             ? 'الوقت المتوقع للبدء'
//                     //             : formatter.format(_expectedStartTime!),
//                     //       ),
//                     //       IconButton(
//                     //         onPressed: () async {
//                     //           final now = DateTime.now();
//                     //           final firstDate = DateTime(
//                     //             now.year - 1,
//                     //             now.month,
//                     //             now.day,
//                     //           );
//                     //           final DateTime? pickedDate = await showDatePicker(
//                     //             context: context,
//                     //             firstDate: firstDate,
//                     //             lastDate: now,
//                     //             // initialDate: now,
//                     //           );
//                     //           setState(() {
//                     //             _expectedStartTime = pickedDate;
//                     //           });
//                     //         },
//                     //         icon: Icon(Icons.calendar_month),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     // SizedBox(width: 16),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             _registrationDeadline == null
//                                 ? 'آخر موعد للتقديم'
//                                 : formatter.format(_registrationDeadline!),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               final now = DateTime.now();
//                               final firstDate = DateTime(
//                                 now.year - 1,
//                                 now.month,
//                                 now.day,
//                               );
//                               final DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 firstDate: firstDate,
//                                 // lastDate: now,
//                                 lastDate: DateTime(
//                                   now.year + 1,
//                                   now.month,
//                                   now.day,
//                                 ),
//                                 // initialDate: DateTime(now.year+1,now.month,now.day),
//                               );
//                               setState(() {
//                                 _registrationDeadline = pickedDate;
//                               });
//                             },
//                             icon: Icon(Icons.calendar_month),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     DropdownButton(
//                       value: _selectedState,
//                       items:
//                           StateOfTender.values
//                               .map(
//                                 (e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(e.name.toUpperCase()),
//                                 ),
//                               )
//                               .toList(),
//                       onChanged: (newCat) {
//                         if (newCat == null) {
//                           return;
//                         }
//                         setState(() {
//                           _selectedState = newCat;
//                         });
//                       },
//                     ),
//                     const Spacer(),
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: WidgetStatePropertyAll(
//                           Colors.blue[200],
//                         ),
//                       ),
//                       onPressed:
//                           () => Navigator.popAndPushNamed(
//                             context,
//                             '/tendersScreen',
//                           ),
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(backgroundColor: Colors.blue[200]),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: WidgetStatePropertyAll(
//                           Colors.blue[200],
//                         ),
//                       ),
//                       onPressed: () async {
//                         final double? enteredBudget = double.tryParse(
//                           _budgetController.text,
//                         );
//                         final bool budgetIsInvalid =
//                             enteredBudget == null || enteredBudget <= 0;

//                         final int? enteredImplementationPeriod = int.tryParse(
//                           _implmentationPeriodController.text,
//                         );
//                         final bool implementationPeriodIsInvalid =
//                             enteredImplementationPeriod == null ||
//                             enteredImplementationPeriod <= 0;
//                         final int? enterednumberOfTechnicalConditions =
//                             int.tryParse(
//                               _numberOfTechnicalConditionsController.text,
//                             );
//                         final bool numberOfTechnicalConditionsIsInvalid =
//                             enterednumberOfTechnicalConditions == null ||
//                             enterednumberOfTechnicalConditions <= 0;
//                         //final snackBar = SnackBar(content: Text('Error'));
//                         if (_titleController.text.trim().isEmpty ||
//                             _descripeController.text.trim().isEmpty ||
//                             _locationController.text.trim().isEmpty ||
//                             budgetIsInvalid ||
//                             implementationPeriodIsInvalid ||
//                             numberOfTechnicalConditionsIsInvalid ||
//                             // _expectedStartTime == null ||
//                             _registrationDeadline == null) {
//                           // ScaffoldMessenger.of(context).showSnackBar(snackBar);عرض رسالة خطأ لثواني معدودة
//                           showDialog(
//                             context: context,
//                             builder:
//                                 (ctx) => AlertDialog(
//                                   // title: Text('Invaled Input'),
//                                   // backgroundColor: Colors.blue,
//                                   icon: Icon(Icons.warning),
//                                   title: Center(
//                                     child: Text(
//                                       'إدخال خاطئ',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         // backgroundColor: Colors.blue,
//                                       ),
//                                     ),
//                                   ),
//                                   content: Text(
//                                     'الرجاء إدخال قيم صحيحية',
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   actions: [
//                                     ElevatedButton(
//                                       style: ButtonStyle(
//                                         backgroundColor: WidgetStatePropertyAll(
//                                           Colors.blue[200],
//                                         ),
//                                       ),
//                                       onPressed: () => Navigator.pop(ctx),
//                                       child: Text('حسناً'),
//                                     ),
//                                   ],
//                                 ),
//                           );
//                           // log(_titleController.text);
//                           // log(_amountController.text);
//                         } else {
//                           final newTender = Tender(
//                             title: _titleController.text,
//                             descripe: _descripeController.text,
//                             location: _locationController.text,
//                             implementationPeriod: enteredImplementationPeriod,
//                             numberOfTechnicalConditions:
//                                 enterednumberOfTechnicalConditions,
//                             registrationDeadline: _registrationDeadline!,
//                             stateOfTender: _selectedState,
//                             // expectedStartTime: _expectedStartTime!,
//                             budget: enteredBudget,
//                           );
//                           try {
//                             await TenderService.addTender(newTender);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('تمت الإضافة بنجاح')),
//                             );
//                             // Navigator.pop(context);
//                             // tendersFuture;
//                             // tendersFuture = TenderService.fetchTenders();
//                             // setState(() {
//                             //   tendersFuture; //= TenderService.fetchTenders();
//                             // });
//                           } catch (e, stackTrace) {
//                             log('خطأ في الاضافة : $e');
//                             log('Stack trace : $stackTrace');
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('فشل في الإضافة :$e')),
//                             );
//                           }
//                           Navigator.pushReplacementNamed(
//                             context,
//                             '/tendersScreen',
//                           );
//                           // Navigator.pop(context);
//                           // setState(()  {
//                           //    widget
//                           //       .tendersFuture; //=await TenderService.fetchTenders();
//                           // });
//                           // widget.onAddTender(
//                           //   Tender(
//                           //     title: _titleController.text,
//                           //     descripe: _descripeController.text,
//                           //     location: _locationController.text,
//                           //     implementationPeriod: enteredImplementationPeriod,
//                           //     numberOfTechnicalConditions:
//                           //         enterednumberOfTechnicalConditions,
//                           //     registrationDeadline: _expectedStartTime!,
//                           //     stateOfTender: _selectedState,
//                           //     budget: enteredBudget,
//                           //     expectedStartTime: _expectedStartTime!,
//                           //   ),
//                           // );
//                         }
//                       },
//                       child: Text('Save Tender'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
