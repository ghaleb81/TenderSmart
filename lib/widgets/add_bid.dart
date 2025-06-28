import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/bid_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'dart:io';

import 'package:tendersmart/widgets/tender_details.dart';

class AddBid extends StatefulWidget {
  AddBid({
    super.key,
    this.tenderId,
    this.onBidAdded,
    this.contractorId,
    this.tender,
    this.existingBid, // جديد
  });

  Tender? tender;
  final int? tenderId;
  final void Function(Bid bid)? onBidAdded;
  final int? contractorId;
  final Bid? existingBid; // جديد

  @override
  State<AddBid> createState() => _AddBidState();
}

class _AddBidState extends State<AddBid> {
  final _formKey = GlobalKey<FormState>();
  final _bidAmountCtrl = TextEditingController();
  final _completionTimeCtrl = TextEditingController();
  final _matchedCountCtrl = TextEditingController();

  File? _pdfFile;
  String? _pdfName;

  bool _saving = false;
  int? _contractorId;

  @override
  void initState() {
    super.initState();
    _loadContractor();

    // تعبئة البيانات إذا كان تعديل
    final existing = widget.existingBid;
    if (existing != null) {
      _bidAmountCtrl.text = existing.bidAmount.toString();
      _completionTimeCtrl.text = existing.completionTime.toString();
      _matchedCountCtrl.text = existing.technicalMatchedCount.toString();
    }
  }

  Future<void> _loadContractor() async {
    final idStr = await TokenStorage.getUserrId();
    setState(() => _contractorId = int.tryParse(idStr ?? ''));
  }

  @override
  void dispose() {
    _bidAmountCtrl.dispose();
    _completionTimeCtrl.dispose();
    _matchedCountCtrl.dispose();
    super.dispose();
  }

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
    if (!_formKey.currentState!.validate()) return;
    if (_contractorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر العثور على حساب المقاول')),
      );
      return;
    }

    final isEditing = widget.existingBid != null;
    final bid = Bid(
      id: widget.existingBid?.id, // ضروري لتحديث العرض
      contractorId: widget.contractorId!,
      tenderId: widget.tenderId!,
      bidAmount: double.parse(_bidAmountCtrl.text),
      completionTime: int.parse(_completionTimeCtrl.text),
      technicalMatchedCount: int.parse(_matchedCountCtrl.text),
    );
    log(bid.toJson().toString());

    setState(() => _saving = true);

    try {
      final success =
          isEditing
              ? await BidService.updateBid(
                bid,
                technicalFile: _pdfFile,
                technicalFileName: _pdfName,
              )
              : await BidService.addBid(
                bid,
                technicalFile: _pdfFile,
                technicalFileName: _pdfName,
              );

      if (success) {
        widget.onBidAdded?.call(bid);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'تم تعديل العرض بنجاح' : 'تمت إضافة العرض بنجاح',
            ),
          ),
        );

        Navigator.pushReplacementNamed(context, '/tendersScreen');
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TenderDetails(tender: widget.tender!),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في حفظ العرض')));
      }
    } catch (e, st) {
      log('AddBid error: $e\n$st');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحفظ')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingBid != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            isEditing ? 'تعديل العرض' : 'إضافة عرض',
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          // appBar: AppBar(
          //   title: Text(
          //     isEditing ? 'تعديل العرض' : 'إضافة عرض',
          //     style: const TextStyle(color: Colors.white),
          //   ),
          //   backgroundColor: Colors.indigo,
          //   centerTitle: true,
          actions: [
            IconButton(
              onPressed:
                  () =>
                      Navigator.pushReplacementNamed(context, '/tendersScreen'),
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isEditing ? 'تعديل العرض الحالي' : 'تفاصيل العرض',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _MoneyField(controller: _bidAmountCtrl),
                  const SizedBox(height: 16),
                  _NumberField(
                    controller: _completionTimeCtrl,
                    label: 'مدة التنفيذ (يوم)',
                  ),
                  const SizedBox(height: 16),
                  _NumberField(
                    controller: _matchedCountCtrl,
                    label: 'عدد الشروط الفنية المطابقة',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _pickPDF,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('اختيار ملف PDF'),
                  ),
                  if (_pdfName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('تم اختيار الملف: $_pdfName'),
                    ),
                  const SizedBox(height: 32),
                  _saving
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(isEditing ? 'تحديث العرض' : 'حفظ'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class AddBid extends StatefulWidget {
//   AddBid({
//     super.key,
//     this.tenderId,
//     this.onBidAdded,
//     this.contractorId,
//     this.tender,
//   });
//   Tender? tender;
//   final int? tenderId;
//   final void Function(Bid bid)? onBidAdded;
//   final int? contractorId;
//   @override
//   State<AddBid> createState() => _AddBidState();
// }

// class _AddBidState extends State<AddBid> {
//   final _formKey = GlobalKey<FormState>();
//   final _bidAmountCtrl = TextEditingController();
//   final _completionTimeCtrl = TextEditingController();
//   final _matchedCountCtrl = TextEditingController();

//   File? _pdfFile;
//   String? _pdfName;

//   bool _saving = false;
//   int? _contractorId;

//   @override
//   void initState() {
//     super.initState();
//     _loadContractor();
//   }

//   Future<void> _loadContractor() async {
//     final idStr = await TokenStorage.getUserrId();
//     setState(() => _contractorId = int.tryParse(idStr ?? ''));
//   }

//   @override
//   void dispose() {
//     _bidAmountCtrl.dispose();
//     _completionTimeCtrl.dispose();
//     _matchedCountCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickPDF() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _pdfFile = File(result.files.single.path!);
//         _pdfName = result.files.single.name;
//       });
//     }
//   }
//   // Future<void> _pickPDF() async {
//   //   final result = await FilePicker.platform.pickFiles(
//   //     type: FileType.custom,
//   //     allowedExtensions: ['pdf'],
//   //   );
//   //   if (result != null && result.files.single.bytes != null) {
//   //     setState(() {
//   //       _pdfBytes = result.files.single.bytes!;
//   //       _pdfName = result.files.single.name;
//   //     });
//   //   }
//   // }

//   // Future<void> _submit() async {
//   //   if (!_formKey.currentState!.validate()) return;
//   //   if (_contractorId == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('تعذّر العثور على حساب المقاول')),
//   //     );
//   //     return;
//   //   }

//   //   final bid = Bid(
//   //     contractorId: widget.contractorId!,
//   //     // contractorId: _contractorId!,
//   //     tenderId: widget.tenderId!,
//   //     bidAmount: double.parse(_bidAmountCtrl.text),
//   //     completionTime: int.parse(_completionTimeCtrl.text),
//   //     technicalMatchedCount: int.parse(_matchedCountCtrl.text),
//   //   );

//   //   setState(() => _saving = true);
//   //   try {
//   //     // await BidService.addBid(
//   //     //   bid,
//   //     //   technicalFileBytes: _pdfBytes,
//   //     //   technicalFileName: _pdfName,
//   //     // );
//   //     await BidService.addBid(
//   //       bid,
//   //       technicalFile: _pdfFile,
//   //       technicalFileName: _pdfName,
//   //     );
//   //     widget.onBidAdded?.call(bid);
//   //     if (!mounted) {
//   //       ScaffoldMessenger.of(
//   //         context,
//   //       ).showSnackBar(const SnackBar(content: Text('تمت إضافة العرض بنجاح')));
//   //       // Navigator.pushReplacementNamed(context);
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => TenderDetails(tender: widget.tender!),
//   //         ),
//   //       );
//   //     }
//   //   } catch (e, st) {
//   //     log('AddBid error: $e\n$st');
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(
//   //         context,
//   //       ).showSnackBar(SnackBar(content: Text('فشل في الإضافة: $e')));
//   //     }
//   //   } finally {
//   //     if (mounted) setState(() => _saving = false);
//   //   }
//   // }
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_contractorId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تعذّر العثور على حساب المقاول')),
//       );
//       return;
//     }

//     final bid = Bid(
//       contractorId: widget.contractorId!,
//       tenderId: widget.tenderId!,
//       bidAmount: double.parse(_bidAmountCtrl.text),
//       completionTime: int.parse(_completionTimeCtrl.text),
//       technicalMatchedCount: int.parse(_matchedCountCtrl.text),
//     );

//     setState(() => _saving = true);

//     try {
//       final success = await BidService.addBid(
//         bid,
//         technicalFile: _pdfFile,
//         technicalFileName: _pdfName,
//       );

//       if (success) {
//         widget.onBidAdded?.call(bid);
//         if (!mounted) return;

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('تمت إضافة العرض بنجاح')));

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TenderDetails(tender: widget.tender!),
//           ),
//         );
//       } else {
//         // فشل ولكن بدون طباعة تفاصيل للمستخدم
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('فشل في إضافة العرض')));
//       }
//     } catch (e, st) {
//       // فقط للمطور في log
//       log('AddBid error: $e\n$st');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('فشل في إضافة العرض')));
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('إضافة عرض', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.indigo,
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed:
//                   () =>
//                       Navigator.pushReplacementNamed(context, '/tendersScreen'),
//               icon: Icon(Icons.keyboard_arrow_right),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surface,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'تفاصيل العرض',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),
//                   _MoneyField(controller: _bidAmountCtrl),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _completionTimeCtrl,
//                     label: 'مدة التنفيذ (يوم)',
//                   ),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _matchedCountCtrl,
//                     label: 'عدد الشروط الفنية المطابقة',
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _pickPDF,
//                     icon: const Icon(Icons.upload_file),
//                     label: const Text('اختيار ملف PDF'),
//                   ),
//                   if (_pdfName != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Text('تم اختيار الملف: $_pdfName'),
//                     ),
//                   const SizedBox(height: 32),
//                   _saving
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton.icon(
//                         onPressed: _submit,
//                         icon: const Icon(Icons.check_circle_outline),
//                         label: const Text('حفظ'),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _MoneyField extends StatelessWidget {
  const _MoneyField({required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: 'قيمة العرض (ل.س)',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: const Icon(Icons.attach_money),
    ),
    validator: (v) {
      final d = double.tryParse(v ?? '');
      return (d == null || d <= 0) ? 'أدخل مبلغاً صحيحاً' : null;
    },
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: const Icon(Icons.numbers),
    ),
    validator: (v) {
      final n = int.tryParse(v ?? '');
      return (n == null || n <= 0) ? 'أدخل رقماً صحيحاً' : null;
    },
  );
}

// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:tendersmart/file_picker_text_field.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';
// import 'package:tendersmart/services/token_storage.dart';

// class AddBid extends StatefulWidget {
//   const AddBid({super.key, this.tenderId, this.onBidAdded});

//   final int? tenderId;
//   final void Function(Bid bid)? onBidAdded;

//   @override
//   State<AddBid> createState() => _AddBidState();
// }

// class _AddBidState extends State<AddBid> {
//   final _formKey = GlobalKey<FormState>();
//   final _bidAmountCtrl = TextEditingController();
//   final _completionTimeCtrl = TextEditingController();
//   final _matchedCountCtrl = TextEditingController();

//   bool _saving = false;
//   int? _contractorId;

//   Uint8List? _pdfBytes;
//   String? _pdfFileName;

//   @override
//   void initState() {
//     super.initState();
//     _loadContractor();
//   }

//   Future<void> _loadContractor() async {
//     final idStr = await TokenStorage.getUserrId();
//     setState(() => _contractorId = int.tryParse(idStr ?? ''));
//   }

//   @override
//   void dispose() {
//     _bidAmountCtrl.dispose();
//     _completionTimeCtrl.dispose();
//     _matchedCountCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_contractorId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تعذّر العثور على حساب المقاول')),
//       );
//       return;
//     }

//     final bid = Bid(
//       contractorId: _contractorId!,
//       tenderId: widget.tenderId!,
//       bidAmount: double.parse(_bidAmountCtrl.text),
//       completionTime: int.parse(_completionTimeCtrl.text),
//       technicalMatchedCount: int.parse(_matchedCountCtrl.text),
//     );

//     setState(() => _saving = true);
//     try {
//       await BidService.addBid(
//         bid,
//         technicalFileBytes: _pdfBytes,
//         technicalFileName: _pdfFileName,
//       );

//       widget.onBidAdded?.call(bid);
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('تمت إضافة العرض بنجاح')));
//       Navigator.pop(context);
//     } catch (e, st) {
//       log('AddBid error: $e\n$st');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('فشل في الإضافة: $e')));
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('إضافة عرض', style: TextStyle(color: Colors.white)),
//           centerTitle: true,
//           backgroundColor: Colors.indigo,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surface,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'تفاصيل العرض',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),
//                   _MoneyField(controller: _bidAmountCtrl),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _completionTimeCtrl,
//                     label: 'مدة التنفيذ (يوم)',
//                   ),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _matchedCountCtrl,
//                     label: 'عدد الشروط الفنية المطابقة',
//                   ),
//                   const SizedBox(height: 24),
//                   FilePickerTextField(
//                     label: 'ملف العرض الفني (PDF)',
//                     onFilePicked: (file) async {
//                       final bytes = await file.readAsBytes();
//                       setState(() {
//                         _pdfBytes = bytes;
//                         _pdfFileName = file.path.split('/').last;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 32),
//                   _saving
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         icon: const Icon(Icons.check_circle_outline),
//                         onPressed: _submit,
//                         label: const Text(
//                           'حفظ',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MoneyField extends StatelessWidget {
//   const _MoneyField({required this.controller});
//   final TextEditingController controller;

//   @override
//   Widget build(BuildContext context) => TextFormField(
//     controller: controller,
//     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//     decoration: InputDecoration(
//       labelText: 'قيمة العرض (ل.س)',
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: const Icon(Icons.attach_money),
//     ),
//     validator: (v) {
//       final d = double.tryParse(v ?? '');
//       return (d == null || d <= 0) ? 'أدخل مبلغاً صحيحاً' : null;
//     },
//   );
// }

// class _NumberField extends StatelessWidget {
//   const _NumberField({required this.controller, required this.label});
//   final TextEditingController controller;
//   final String label;

//   @override
//   Widget build(BuildContext context) => TextFormField(
//     controller: controller,
//     keyboardType: TextInputType.number,
//     decoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: const Icon(Icons.numbers),
//     ),
//     validator: (v) {
//       final n = int.tryParse(v ?? '');
//       return (n == null || n <= 0) ? 'أدخل رقماً صحيحاً' : null;
//     },
//   );
// }

// import 'dart:developer';
// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:tendersmart/file_picker_text_field.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';
// import 'package:tendersmart/services/token_storage.dart';

// class AddBid extends StatefulWidget {
//   const AddBid({super.key, this.tenderId, this.onBidAdded});

//   final int? tenderId;
//   final void Function(Bid bid)? onBidAdded;

//   @override
//   State<AddBid> createState() => _AddBidState();
// }

// class _AddBidState extends State<AddBid> {
//   final _formKey = GlobalKey<FormState>();

//   final _bidAmountCtrl = TextEditingController();
//   final _completionTimeCtrl = TextEditingController();
//   final _matchedCountCtrl = TextEditingController();
//   // File? _pdfFile;

//   bool _saving = false;
//   int? _contractorId;

//   @override
//   void initState() {
//     super.initState();
//     _loadContractor();
//   }

//   Future<void> _loadContractor() async {
//     final idStr = await TokenStorage.getUserrId();
//     setState(() => _contractorId = int.tryParse(idStr ?? ''));
//   }

//   @override
//   void dispose() {
//     _bidAmountCtrl.dispose();
//     _completionTimeCtrl.dispose();
//     _matchedCountCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_contractorId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تعذّر العثور على حساب المقاول')),
//       );
//       return;
//     }

//     final bid = Bid(
//       contractorId: _contractorId!,
//       tenderId: widget.tenderId!,
//       bidAmount: double.parse(_bidAmountCtrl.text),
//       completionTime: int.parse(_completionTimeCtrl.text),
//       technicalMatchedCount: int.parse(_matchedCountCtrl.text),
//       // technicalProposalPdf: _pdfFile,
//     );

//     setState(() => _saving = true);
//     try {
//       final pdfBytes = await _pdfFile?.readAsBytes();
//       final pdfName = _pdfFile != null ? _pdfFile!.path.split('/').last : null;

//       await BidService.addBid(
//         bid,
//         technicalFileBytes: pdfBytes,
//         technicalFileName: pdfName,
//       );
//       // await BidService.addBid(bid); // تأكّد أن SERVICE يستخدم bid.toJson()
//       widget.onBidAdded?.call(bid);
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('تمت إضافة العرض بنجاح')));
//       Navigator.pop(context);
//     } catch (e, st) {
//       log('AddBid error: $e\n$st');
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('فشل في الإضافة: $e')));
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Bid', style: TextStyle(color: Colors.white)),
//           centerTitle: true,
//           backgroundColor: Colors.indigo,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surface,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'تفاصيل العرض',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),
//                   _MoneyField(controller: _bidAmountCtrl),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _completionTimeCtrl,
//                     label: 'مدة التنفيذ (يوم)',
//                   ),
//                   const SizedBox(height: 16),
//                   _NumberField(
//                     controller: _matchedCountCtrl,
//                     label: 'عدد الشروط الفنية المطابقة',
//                   ),
//                   const SizedBox(height: 24),
//                   FilePickerTextField(
//                     label: 'ملف العرض الفني (PDF)',
//                     onFilePicked: (f) => setState(() => _pdfFile = f),
//                   ),
//                   const SizedBox(height: 32),
//                   _saving
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         icon: const Icon(Icons.check_circle_outline),
//                         onPressed: _submit,
//                         label: const Text(
//                           'حفظ',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// //=================== عناصر مساعدة لحقول الإدخال ===================
// class _MoneyField extends StatelessWidget {
//   const _MoneyField({required this.controller});
//   final TextEditingController controller;
//   @override
//   Widget build(BuildContext context) => TextFormField(
//     controller: controller,
//     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//     decoration: InputDecoration(
//       labelText: 'قيمة العرض (ل.س)',
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: const Icon(Icons.attach_money),
//     ),
//     validator: (v) {
//       final d = double.tryParse(v ?? '');
//       return (d == null || d <= 0) ? 'أدخل مبلغاً صحيحاً' : null;
//     },
//   );
// }

// class _NumberField extends StatelessWidget {
//   const _NumberField({required this.controller, required this.label});
//   final TextEditingController controller;
//   final String label;
//   @override
//   Widget build(BuildContext context) => TextFormField(
//     controller: controller,
//     keyboardType: TextInputType.number,
//     decoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: const Icon(Icons.numbers),
//     ),
//     validator: (v) {
//       final n = int.tryParse(v ?? '');
//       return (n == null || n <= 0) ? 'أدخل رقماً صحيحاً' : null;
//     },
//   );
// }

// // import 'dart:developer';
// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:tendersmart/contractor_profile_page.dart';
// // import 'package:tendersmart/file_picker_text_field.dart';
// // import 'package:tendersmart/models/Bid.dart';
// // import 'package:tendersmart/models/Tender.dart';
// // import 'package:tendersmart/services/bid_service.dart';
// // import 'package:tendersmart/services/token_storage.dart';

// // class AddBid extends StatefulWidget {
// //   AddBid({super.key, this.addBid, this.tenderId});
// //   final void Function(Bid bid)? addBid;
// //   final tenderId;
// //   // final contractorId;

// //   @override
// //   State<AddBid> createState() => _AddBidState();
// // }

// // class _AddBidState extends State<AddBid> {
// //   // List<Bid> Bid_Contractor = [
// //   //   Bid(
// //   //     bid_amount: 3222,
// //   //     completion_time_excepted: 2,
// //   //     technical_matched_count: 5,
// //   //   ),
// //   //   Bid(
// //   //     bid_amount: 444,
// //   //     completion_time_excepted: 3,
// //   //     technical_matched_count: 3,
// //   //   ),
// //   //   Bid(
// //   //     bid_amount: 111,
// //   //     completion_time_excepted: 4,
// //   //     technical_matched_count: 9,
// //   //   ),
// //   // ];
// //   final _bidAmountController = TextEditingController();
// //   final _completionTimeExceptedController = TextEditingController();
// //   final _technicalMatchedCountController = TextEditingController();
// //   final _technicalProposalPdfController = TextEditingController();
// //   // void _addBid(Bid bid) {
// //   //   setState(() {
// //   //     Bid_Contractor.add(bid);
// //   //   });
// //   // }
// //   File? _selectedTechnicalProposalPdf;
// //   String? contractorId;

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     loadUserId();
// //     // userId = await TokenStorage.getUserrId();
// //   }

// //   void loadUserId() async {
// //     final userId = await TokenStorage.getUserrId();
// //     setState(() {
// //       contractorId = userId;
// //       // contractorId = int.tryParse(userId!);
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _bidAmountController.dispose();
// //     _completionTimeExceptedController.dispose();
// //     _technicalMatchedCountController.dispose();
// //     _technicalProposalPdfController.dispose();
// //   } //لتدمير الكونتولار بعد الانتهاء من العمل

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         // leading: IconButton(
// //         //   onPressed: () => Navigator.pop(context),
// //         //   icon: Icon(Icons.arrow_back),
// //         // ),
// //         centerTitle: true,
// //         backgroundColor: Colors.blue,
// //         title: const Text(
// //           'طلب توريد',
// //           style: TextStyle(color: Colors.black, fontSize: 20),
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed: () => Navigator.pop(context),
// //             icon: Icon(Icons.keyboard_arrow_right),
// //           ),
// //         ],
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(8.0),
// //         child: Expanded(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               TextField(
// //                 decoration: InputDecoration(
// //                   label: Text(': الميزانية المقدمة من قبل المقاول'),
// //                 ),
// //                 controller: _bidAmountController,
// //                 maxLength: 50,
// //               ),
// //               TextField(
// //                 decoration: InputDecoration(
// //                   label: Text(': وقت التنفيذ للمقاول'),
// //                 ),
// //                 // onChanged: _saveChangeTitle,
// //                 controller: _completionTimeExceptedController,
// //                 maxLength: 50,
// //               ),
// //               TextField(
// //                 decoration: InputDecoration(
// //                   label: Text(': عدد الشروط الفنية المطابقة'),
// //                 ),
// //                 // onChanged: _saveChangeTitle,
// //                 controller: _technicalMatchedCountController,
// //                 maxLength: 50,
// //               ),
// //               FilePickerTextField(
// //                 onFilePicked: (file) {
// //                   setState(() {
// //                     _selectedTechnicalProposalPdf = file;
// //                   });
// //                 },
// //               ),

// //               // TextField(
// //               //   decoration: InputDecoration(
// //               //     label: Text(': ملف العرض الفني المقدم من المقاول'),
// //               //   ),
// //               //   // onChanged: _saveChangeTitle,
// //               //   controller: _technical_proposal_pdfController,
// //               //   maxLength: 50,
// //               // ),
// //               SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                     },
// //                     child: Text('Cancel'),
// //                   ),
// //                   SizedBox(height: 10),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       final double? enteredBidAmount = double.tryParse(
// //                         _bidAmountController.text,
// //                       );
// //                       final bool bidAmountIsInvalid =
// //                           enteredBidAmount == null || enteredBidAmount <= 0;

// //                       final int? enterdCompletionTimeExcepted = int.tryParse(
// //                         _completionTimeExceptedController.text,
// //                       );
// //                       final bool CompletionTimeExceptedIsInvalid =
// //                           enterdCompletionTimeExcepted == null ||
// //                           enterdCompletionTimeExcepted <= 0;
// //                       final int? enteredTechnicalMatchedCount = int.tryParse(
// //                         _technicalMatchedCountController.text,
// //                       );
// //                       final bool TechnicalMatchedCountIsInvalid =
// //                           enteredTechnicalMatchedCount == null ||
// //                           enteredTechnicalMatchedCount <= 0;
// //                       if (bidAmountIsInvalid ||
// //                           CompletionTimeExceptedIsInvalid ||
// //                           TechnicalMatchedCountIsInvalid) {
// //                         // ScaffoldMessenger.of(context).showSnackBar(snackBar);عرض رسالة خطأ لثواني معدودة
// //                         showDialog(
// //                           context: context,
// //                           builder:
// //                               (ctx) => AlertDialog(
// //                                 icon: Icon(Icons.warning),
// //                                 title: Center(
// //                                   child: Text(
// //                                     'إدخال خاطئ',
// //                                     style: TextStyle(fontSize: 20),
// //                                   ),
// //                                 ),
// //                                 content: Text(
// //                                   'الرجاء إدخال قيم صحيحية',
// //                                   textAlign: TextAlign.center,
// //                                 ),
// //                                 actions: [
// //                                   ElevatedButton(
// //                                     style: ButtonStyle(
// //                                       backgroundColor: WidgetStatePropertyAll(
// //                                         Colors.blue[200],
// //                                       ),
// //                                     ),
// //                                     onPressed: () => Navigator.pop(ctx),
// //                                     child: Text('حسناً'),
// //                                   ),
// //                                 ],
// //                               ),
// //                         );
// //                       } else {
// //                         // final userId = await ;

// //                         final userId = int.tryParse(
// //                           await TokenStorage.getUserrId() ?? '',
// //                         );
// //                         final bid = Bid(
// //                           contractorId:
// //                               userId, //userId.toString(), //contractorId,
// //                           tenderId: widget.tenderId,
// //                           bidAmount: enteredBidAmount.toString(),
// //                           completionTimeExcepted: enterdCompletionTimeExcepted,
// //                           technicalMatchedCount: enteredTechnicalMatchedCount,
// //                         );
// //                         print(bid.contractorId.runtimeType);
// //                         log('${bid.toJson()}');
// //                         // يجب أن تكون int

// //                         try {
// //                           await BidService.addBid(bid);
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(content: Text('تمت الإضافة بنجاح')),
// //                           );
// //                           Navigator.pop(context);
// //                           // setState(() {
// //                           //   tendersFuture = TenderService.fetchTenders();
// //                           // });
// //                         } catch (e, stackTrace) {
// //                           log('خطأ في الاضافة : $e');
// //                           log('Stack trace : $stackTrace');
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(content: Text('فشل في الإضافة :$e')),
// //                           );
// //                           // print(bid.contractorId);
// //                           // print(bid.tenderId);
// //                           Navigator.pop(context);
// //                         }
// //                         // BidService.addBid(
// //                         //   bidAmount: ,
// //                         //   completionTime: enterdCompletionTimeExcepted,
// //                         //   technicalMatched: enteredTechnicalMatchedCount,
// //                         //   // technicalProposalPdf: _selectedTechnicalProposalPdf,
// //                         //   // token: TokenStorage.getToken().toString(),
// //                         // );

// //                         // widget.addBid(
// //                         //   Bid(
// //                         //     tenderId: widget.tenderId,
// //                         //     bidAmount: enteredBidAmount,
// //                         //     completionTimeExcepted:
// //                         //         enterdCompletionTimeExcepted,
// //                         //     technicalMatchedCount: enteredTechnicalMatchedCount,
// //                         //     // contractorId:
// //                         //   ),
// //                         // );
// //                         Navigator.pop(context);
// //                       }
// //                     },
// //                     child: Text('Save'),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
