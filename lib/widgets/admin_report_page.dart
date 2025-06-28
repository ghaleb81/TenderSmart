import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tendersmart/services/report_service.dart';

// class SuperAdminReportScreen extends StatefulWidget {
//   const SuperAdminReportScreen({Key? key}) : super(key: key);

//   @override
//   State<SuperAdminReportScreen> createState() => _SuperAdminReportScreenState();
// }

// class _SuperAdminReportScreenState extends State<SuperAdminReportScreen>
//     with SingleTickerProviderStateMixin {
//   late Future<Map<String, dynamic>> summaryFuture;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     summaryFuture = ReportService.getSummaryReport();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Color get _primaryColor => Colors.indigo.shade700;
//   Color get _secondaryColor => Colors.orange.shade600;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: _primaryColor,
//         elevation: 10,
//         title: const Text('لوحة تحكم المشرف الفاخرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
//         centerTitle: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
//         ),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: summaryFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 5,
//                 color: Colors.indigo,
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'حدث خطأ: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//               ),
//             );
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text('لا توجد بيانات'));
//           }

//           final data = snapshot.data!;
//           final int totalTenders = data['totalTenders'] ?? 0;
//           final int totalBids = data['totalBids'] ?? 0;
//           final double avgBids = (data['averageBidsPerTender'] ?? 0).toDouble();

//           final double minPrice =
//               double.tryParse(data['minBidPrice']?.toString() ?? '') ?? 0.0;
//           final double avgPrice =
//               double.tryParse(data['avgBidPrice']?.toString() ?? '') ?? 0.0;
//           final double maxPrice =
//               double.tryParse(data['maxBidPrice']?.toString() ?? '') ?? 0.0;

//           final List<dynamic> topContractors = data['topContractors'] ?? [];

//           return ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//             children: [
//               // بطاقة الإحصائيات الرئيسية مع تأثير الظل المتدرج + تلاشي دخول
//               FadeTransition(
//                 opacity: _animationController,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _glowingStatCard('المناقصات', totalTenders.toString(), Icons.gavel, _primaryColor),
//                     _glowingStatCard('العروض', totalBids.toString(), Icons.description_outlined, _secondaryColor),
//                     _glowingStatCard('متوسط العروض', avgBids.toStringAsFixed(2), Icons.show_chart, Colors.deepPurpleAccent),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // عنوان متحرك مع خط أفقى نابض بالحياة
//               AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (_, __) => Opacity(
//                   opacity: _animationController.value,
//                   child: _fancySectionTitle('تحليل الأسعار'),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // كرت الرسم البياني متدرج مع ظل داخلي وبارز
//               FadeTransition(
//                 opacity: _animationController,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                     gradient: LinearGradient(
//                       colors: [_primaryColor.withOpacity(0.15), _secondaryColor.withOpacity(0.12)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _primaryColor.withOpacity(0.35),
//                         offset: const Offset(0, 10),
//                         blurRadius: 30,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: AspectRatio(
//                     aspectRatio: 1.9,
//                     child: BarChart(
//                       BarChartData(
//                         maxY: (maxPrice * 1.4).ceilToDouble(),
//                         barGroups: [
//                           BarChartGroupData(
//                             x: 0,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: minPrice,
//                                 color: _primaryColor,
//                                 width: 34,
//                                 borderRadius: BorderRadius.circular(10),
//                                 backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxPrice * 1.4, color: Colors.indigo.shade100),
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 1,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: avgPrice,
//                                 color: _secondaryColor,
//                                 width: 34,
//                                 borderRadius: BorderRadius.circular(10),
//                                 backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxPrice * 1.4, color: Colors.orange.shade100),
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 2,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: maxPrice,
//                                 color: Colors.red.shade400,
//                                 width: 34,
//                                 borderRadius: BorderRadius.circular(10),
//                                 backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxPrice * 1.4, color: Colors.red.shade100),
//                               ),
//                             ],
//                           ),
//                         ],
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 40,
//                               getTitlesWidget: (val, meta) {
//                                 final style = const TextStyle(
//                                   color: Colors.black87,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 );
//                                 switch (val.toInt()) {
//                                   case 0:
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 6),
//                                       child: Text('أدنى', style: style),
//                                     );
//                                   case 1:
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 6),
//                                       child: Text('متوسط', style: style),
//                                     );
//                                   case 2:
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 6),
//                                       child: Text('أعلى', style: style),
//                                     );
//                                 }
//                                 return const SizedBox.shrink();
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: maxPrice / 5,
//                               reservedSize: 48,
//                               getTitlesWidget: (val, meta) {
//                                 return Text(
//                                   val.toInt().toString(),
//                                   style: const TextStyle(
//                                     color: Colors.black54,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 13,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawHorizontalLine: true,
//                           horizontalInterval: maxPrice / 5,
//                           getDrawingHorizontalLine: (val) => FlLine(
//                             color: Colors.grey.withOpacity(0.2),
//                             strokeWidth: 1,
//                           ),
//                           drawVerticalLine: false,
//                         ),
//                         borderData: FlBorderData(show: false),
//                       ),
//                       swapAnimationDuration: const Duration(milliseconds: 800),
//                       swapAnimationCurve: Curves.easeOutCubic,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 44),

//               // أفضل المقاولين مع بطاقات متحركة متدرجة الظل واللون
//               AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (_, __) => Opacity(
//                   opacity: _animationController.value,
//                   child: _fancySectionTitle('أفضل المقاولين'),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               ...topContractors.asMap().entries.map((entry) {
//                 final idx = entry.key;
//                 final contractor = entry.value;
//                 final name = contractor['user']?['name'] ?? 'غير معروف';
//                 final company = contractor['company_name'] ?? '';
//                 final bidsCount = contractor['bids_count'] ?? 0;

//                 // حركة دخول متدرجة لكل بطاقة حسب الترتيب
//                 final animationValue = (_animationController.value - (idx * 0.15)).clamp(0.0, 1.0);

//                 return Transform(
//                   transform: Matrix4.translationValues(0, 30 * (1 - animationValue), 0),
//                   child: Opacity(
//                     opacity: animationValue,
//                     child: Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                       elevation: 5,
//                       shadowColor: _primaryColor.withOpacity(0.25),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: _primaryColor.withOpacity(0.85),
//                           radius: 28,
//                           child: Text(
//                             name.isNotEmpty ? name[0] : '?',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 28,
//                               shadows: [
//                                 Shadow(
//                                   offset: Offset(1, 1),
//                                   blurRadius: 3,
//                                   color: Colors.black38,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           name,
//                           style: ui.theme.textTheme.headline6?.copyWith(
//                             fontWeight: FontWeight.w800,
//                             color: _primaryColor,
//                           ),
//                         ),
//                         subtitle: Text(
//                           company,
//                           style: theme.textTheme.bodyText2?.copyWith(
//                             fontWeight: FontWeight.w600,
//                             color: _primaryColor.withOpacity(0.7),
//                           ),
//                         ),
//                         trailing: Container(
//                           decoration: BoxDecoration(
//                             color: _secondaryColor.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                           child: Text(
//                             '$bidsCount عروض',
//                             style: TextStyle(
//                               color: _secondaryColor.shade900,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                               shadows: const [
//                                 Shadow(
//                                   offset: Offset(0.5, 0.5),
//                                   blurRadius: 1,
//                                   color: Colors.black12,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _glowingStatCard(String title, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.4),
//               blurRadius: 24,
//               spreadRadius: 3,
//               offset: const Offset(0, 10),
//             ),
//             BoxShadow(
//               color: color.withOpacity(0.15),
//               blurRadius: 40,
//               spreadRadius: 15,
//               offset: const Offset(0, 20),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 46, color: color),
//             const SizedBox(height: 18),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: color.shade900,
//                 shadows: [
//                   Shadow(
//                     color: color.withOpacity(0.6),
//                     offset: const Offset(0, 2),
//                     blurRadius: 6,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: color.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _fancySectionTitle(String text) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 30,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [_primaryColor, _secondaryColor],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: _primaryColor,
//             shadows: const [
//               Shadow(
//                 color: Colors.black26,
//                 offset: Offset(2, 2),
//                 blurRadius: 6,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AdminReportScreen extends StatefulWidget {
//   const AdminReportScreen({Key? key}) : super(key: key);

//   @override
//   State<AdminReportScreen> createState() => _AdminReportScreenState();
// }

// class _AdminReportScreenState extends State<AdminReportScreen> {
//   late Future<Map<String, dynamic>> summaryFuture;

//   @override
//   void initState() {
//     super.initState();
//     summaryFuture = ReportService.getSummaryReport();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.indigo.shade700,
//         elevation: 5,
//         title: const Text(
//           'لوحة تحكم المشرف',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: summaryFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'حدث خطأ: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text('لا توجد بيانات'));
//           }

//           final data = snapshot.data!;
//           final int totalTenders = data['totalTenders'] ?? 0;
//           final int totalBids = data['totalBids'] ?? 0;
//           final double avgBids = (data['averageBidsPerTender'] ?? 0).toDouble();

//           final double minPrice =
//               double.tryParse(data['minBidPrice']?.toString() ?? '') ?? 0.0;
//           final double avgPrice =
//               double.tryParse(data['avgBidPrice']?.toString() ?? '') ?? 0.0;
//           final double maxPrice =
//               double.tryParse(data['maxBidPrice']?.toString() ?? '') ?? 0.0;

//           final List<dynamic> topContractors = data['topContractors'] ?? [];

//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // القسم العلوي - الإحصائيات
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _infoCard(
//                       'المناقصات',
//                       totalTenders.toString(),
//                       Icons.assignment,
//                       Colors.indigo,
//                     ),
//                     _infoCard(
//                       'العروض',
//                       totalBids.toString(),
//                       Icons.insert_drive_file,
//                       Colors.teal,
//                     ),
//                     _infoCard(
//                       'متوسط العروض',
//                       avgBids.toStringAsFixed(2),
//                       Icons.show_chart,
//                       Colors.orange,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 30),

//                 // العنوان مع خط تحت
//                 _sectionTitle('تحليل الأسعار'),

//                 const SizedBox(height: 12),

//                 // رسم بياني شريطي
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.indigo.shade50,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.indigo.withOpacity(0.12),
//                         blurRadius: 10,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: AspectRatio(
//                     aspectRatio: 1.7,
//                     child: BarChart(
//                       BarChartData(
//                         maxY: maxPrice * 1.3,
//                         barGroups: [
//                           BarChartGroupData(
//                             x: 0,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: minPrice,
//                                 color: Colors.indigo.shade400,
//                                 width: 26,
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 1,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: avgPrice,
//                                 color: Colors.orange.shade400,
//                                 width: 26,
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 2,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: maxPrice,
//                                 color: Colors.red.shade400,
//                                 width: 26,
//                               ),
//                             ],
//                           ),
//                         ],
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (val, _) {
//                                 switch (val.toInt()) {
//                                   case 0:
//                                     return _chartLabel('أدنى');
//                                   case 1:
//                                     return _chartLabel('متوسط');
//                                   case 2:
//                                     return _chartLabel('أعلى');
//                                   default:
//                                     return const SizedBox.shrink();
//                                 }
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 40,
//                               interval: maxPrice / 5,
//                               getTitlesWidget:
//                                   (val, _) => Text(
//                                     '${val.toInt()}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawHorizontalLine: true,
//                           horizontalInterval: maxPrice / 5,
//                           getDrawingHorizontalLine:
//                               (val) => FlLine(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 strokeWidth: 1,
//                               ),
//                           drawVerticalLine: false,
//                         ),
//                         borderData: FlBorderData(show: false),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // قسم أفضل المقاولين
//                 _sectionTitle('أفضل المقاولين'),

//                 const SizedBox(height: 16),

//                 topContractors.isEmpty
//                     ? const Center(
//                       child: Text(
//                         'لا توجد بيانات للمقاولين',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     )
//                     : ListView.separated(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: topContractors.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 14),
//                       itemBuilder: (context, index) {
//                         final contractor = topContractors[index];
//                         final name = contractor['user']?['name'] ?? 'غير معروف';
//                         final company = contractor['company_name'] ?? '';
//                         final bidsCount = contractor['bids_count'] ?? 0;

//                         return Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.indigo.shade300,
//                               child: Text(
//                                 name.isNotEmpty ? name[0] : '?',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                             title: Text(
//                               name,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               company,
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: Colors.indigo.shade200,
//                               ),
//                             ),
//                             trailing: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.shade50,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 6,
//                                 horizontal: 12,
//                               ),
//                               child: Text(
//                                 '$bidsCount عروض',
//                                 style: TextStyle(
//                                   color: Colors.orange.shade700,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _infoCard(String title, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
//         margin: const EdgeInsets.symmetric(horizontal: 6),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 26,
//               backgroundColor: color,
//               child: Icon(icon, color: Colors.white, size: 28),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               value,
//               // style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color.shade900),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               // style: TextStyle(fontSize: 16, color: color.shade700, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _sectionTitle(String text) {
//     return Row(
//       children: [
//         Container(width: 6, height: 26, color: Colors.indigo.shade700),
//         const SizedBox(width: 10),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.indigo.shade700,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _chartLabel(String text) => Padding(
//     padding: const EdgeInsets.only(top: 6),
//     child: Text(
//       text,
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Colors.black87,
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tendersmart/services/report_service.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({Key? key}) : super(key: key);

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  late Future<Map<String, dynamic>> summaryFuture;

  @override
  void initState() {
    super.initState();
    summaryFuture = ReportService.getSummaryReport();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.indigo.shade700,
      //   elevation: 5,
      //   title: const Text(
      //     'لوحة تحكم المشرف',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      // ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'تقارير المشرف  ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final data = snapshot.data!;
          final int totalTenders = data['totalTenders'] ?? 0;
          final int totalBids = data['totalBids'] ?? 0;
          final double avgBids = (data['averageBidsPerTender'] ?? 0).toDouble();

          final double minPrice =
              double.tryParse(data['minBidPrice']?.toString() ?? '') ?? 0.0;
          final double avgPrice =
              double.tryParse(data['avgBidPrice']?.toString() ?? '') ?? 0.0;
          final double maxPrice =
              double.tryParse(data['maxBidPrice']?.toString() ?? '') ?? 0.0;

          final List<dynamic> topContractors = data['topContractors'] ?? [];

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // القسم العلوي - الإحصائيات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoCard(
                        'المناقصات',
                        totalTenders.toString(),
                        Icons.assignment,
                        Colors.indigo,
                      ),
                      _infoCard(
                        'العروض',
                        totalBids.toString(),
                        Icons.insert_drive_file,
                        Colors.teal,
                      ),
                      _infoCard(
                        'متوسط العروض',
                        avgBids.toStringAsFixed(2),
                        Icons.show_chart,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // العنوان مع خط تحت
                  _sectionTitle('تحليل الأسعار'),

                  const SizedBox(height: 12),

                  // رسم بياني شريطي
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: BarChart(
                        BarChartData(
                          maxY: maxPrice * 1.3,
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: minPrice,
                                  color: Colors.indigo.shade400,
                                  width: 26,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: avgPrice,
                                  color: Colors.orange.shade400,
                                  width: 26,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: maxPrice,
                                  color: Colors.red.shade400,
                                  width: 26,
                                ),
                              ],
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, _) {
                                  switch (val.toInt()) {
                                    case 0:
                                      return _chartLabel('أدنى');
                                    case 1:
                                      return _chartLabel('متوسط');
                                    case 2:
                                      return _chartLabel('أعلى');
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60,
                                interval: maxPrice / 5 > 0 ? maxPrice / 5 : 1,
                                getTitlesWidget: (val, meta) {
                                  String text;
                                  if (val >= 1000) {
                                    text =
                                        '${(val / 1000).toStringAsFixed(1)}K';
                                  } else {
                                    text = val.toInt().toString();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval:
                                maxPrice / 5 > 0 ? maxPrice / 5 : 1,
                            getDrawingHorizontalLine:
                                (val) => FlLine(
                                  color: Colors.grey.withOpacity(0.2),
                                  strokeWidth: 1,
                                ),
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // قسم أفضل المقاولين
                  _sectionTitle('أفضل المقاولين'),

                  const SizedBox(height: 16),

                  topContractors.isEmpty
                      ? const Center(
                        child: Text(
                          'لا توجد بيانات للمقاولين',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                      : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: topContractors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final contractor = topContractors[index];
                          final name =
                              contractor['user']?['name'] ?? 'غير معروف';
                          final company = contractor['company_name'] ?? '';
                          final bidsCount = contractor['bids_count'] ?? 0;

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo.shade300,
                                child: Text(
                                  name.isNotEmpty ? name[0] : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                company,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.indigo.shade200,
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '$bidsCount عروض',
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                // color: color.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                // color: color.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(width: 6, height: 26, color: Colors.indigo.shade700),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade700,
          ),
        ),
      ],
    );
  }

  Widget _chartLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}

//  AdminReportScreen extends StatefulWidget {
//   const AdminReportScreen({Key? key}) : super(key: key);

//   @override
//   State<AdminReportScreen> createState() => _AdminReportScreenState();
// }

// class _AdminReportScreenState extends State<AdminReportScreen> {
//   late Future<Map<String, dynamic>> summaryFuture;

//   @override
//   void initState() {
//     super.initState();
//     summaryFuture = ReportService.getSummaryReport();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('لوحة تحكم المشرف'),
//         backgroundColor: Colors.deepPurple,
//         elevation: 6,
//         shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: summaryFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'حدث خطأ: ${snapshot.error}',
//                 style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
//               ),
//             );
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text('لا توجد بيانات'));
//           }

//           final data = snapshot.data!;
//           final int totalTenders = data['totalTenders'] ?? 0;
//           final int totalBids = data['totalBids'] ?? 0;
//           final double avgBids = (data['averageBidsPerTender'] ?? 0).toDouble();

//           final double minPrice =
//               double.tryParse(data['minBidPrice']?.toString() ?? '') ?? 0.0;
//           final double avgPrice =
//               double.tryParse(data['avgBidPrice']?.toString() ?? '') ?? 0.0;
//           final double maxPrice =
//               double.tryParse(data['maxBidPrice']?.toString() ?? '') ?? 0.0;

//           final topContractors = data['topContractors'] as List<dynamic>? ?? [];

//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // العنوان الكبير
//                 Text(
//                   'موجز الأداء',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // البطاقات الإحصائية
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _fancyStatCard(
//                       'المناقصات',
//                       totalTenders.toString(),
//                       Icons.gavel,
//                       color: Colors.deepPurple,
//                     ),
//                     _fancyStatCard(
//                       'العروض',
//                       totalBids.toString(),
//                       Icons.list_alt,
//                       color: Colors.teal,
//                     ),
//                     _fancyStatCard(
//                       'متوسط العروض',
//                       avgBids.toStringAsFixed(2),
//                       Icons.show_chart,
//                       color: Colors.orange,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 40),

//                 // رسم بياني الأسعار
//                 Text(
//                   'تحليل الأسعار',
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.deepPurple.withOpacity(0.15),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 30,
//                     horizontal: 20,
//                   ),
//                   child: AspectRatio(
//                     aspectRatio: 1.7,
//                     child: BarChart(
//                       BarChartData(
//                         maxY: maxPrice * 1.3,
//                         barGroups: [
//                           BarChartGroupData(
//                             x: 0,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: minPrice,
//                                 color: Colors.blue.shade400,
//                                 width: 28,
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.blue.shade300,
//                                     Colors.blue.shade600,
//                                   ],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 1,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: avgPrice,
//                                 color: Colors.orange.shade400,
//                                 width: 28,
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.orange.shade300,
//                                     Colors.orange.shade600,
//                                   ],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           BarChartGroupData(
//                             x: 2,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: maxPrice,
//                                 color: Colors.red.shade400,
//                                 width: 28,
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.red.shade300,
//                                     Colors.red.shade600,
//                                   ],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) {
//                                 switch (value.toInt()) {
//                                   case 0:
//                                     return const Text(
//                                       'أدنى',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87,
//                                       ),
//                                     );
//                                   case 1:
//                                     return const Text(
//                                       'متوسط',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87,
//                                       ),
//                                     );
//                                   case 2:
//                                     return const Text(
//                                       'أعلى',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87,
//                                       ),
//                                     );
//                                 }
//                                 return const SizedBox.shrink();
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 48,
//                               interval: maxPrice / 5,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   value.toInt().toString(),
//                                   style: const TextStyle(
//                                     color: Colors.black54,
//                                     fontSize: 12,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawHorizontalLine: true,
//                           horizontalInterval: maxPrice / 5,
//                           getDrawingHorizontalLine:
//                               (value) => FlLine(
//                                 color: Colors.grey.withOpacity(0.15),
//                                 strokeWidth: 1,
//                               ),
//                           drawVerticalLine: false,
//                         ),
//                         borderData: FlBorderData(show: false),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 // قائمة أفضل المقاولين
//                 Text(
//                   'أفضل المقاولين',
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 if (topContractors.isEmpty)
//                   const Center(
//                     child: Text(
//                       'لا توجد بيانات للمقاولين',
//                       style: TextStyle(fontSize: 16, color: Colors.black54),
//                     ),
//                   )
//                 else
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: topContractors.length,
//                     itemBuilder: (context, index) {
//                       final c = topContractors[index];
//                       final name = c['user']?['name'] ?? 'غير معروف';
//                       final company = c['company_name'] ?? '';
//                       final bidsCount = c['bids_count'] ?? 0;
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         shadowColor: Colors.deepPurple.withOpacity(0.15),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.deepPurple.shade200,
//                             child: Text(
//                               name.isNotEmpty ? name[0] : '?',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             name,
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple.shade900,
//                             ),
//                           ),
//                           subtitle: Text(
//                             company,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: Colors.deepPurple.shade300,
//                             ),
//                           ),
//                           trailing: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.teal.shade50,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Text(
//                               '$bidsCount عروض',
//                               style: TextStyle(
//                                 color: Colors.teal.shade700,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _fancyStatCard(
//     String title,
//     String value,
//     IconData icon, {
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 6),
//         padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.25),
//               blurRadius: 10,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.6),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(14),
//               child: Icon(icon, size: 38, color: Colors.white),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 // color: color.shade900,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 // color: color.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AdminReportScreen extends StatefulWidget {
//   const AdminReportScreen({Key? key}) : super(key: key);

//   @override
//   State<AdminReportScreen> createState() => _AdminReportScreenState();
// }

// class _AdminReportScreenState extends State<AdminReportScreen> {
//   late Future<Map<String, dynamic>> summaryFuture;

//   @override
//   void initState() {
//     super.initState();
//     summaryFuture = ReportService.getSummaryReport();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('لوحة تحكم المشرف'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: summaryFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text('لا توجد بيانات'));
//           }

//           final data = snapshot.data!;
//           final int totalTenders = data['totalTenders'] ?? 0;
//           final int totalBids = data['totalBids'] ?? 0;
//           final double avgBids = (data['averageBidsPerTender'] ?? 0).toDouble();

//           final double minPrice =
//               double.tryParse(data['minBidPrice']?.toString() ?? '') ?? 0.0;
//           final double avgPrice =
//               double.tryParse(data['avgBidPrice']?.toString() ?? '') ?? 0.0;
//           final double maxPrice =
//               double.tryParse(data['maxBidPrice']?.toString() ?? '') ?? 0.0;

//           final topContractors = data['topContractors'] as List<dynamic>? ?? [];

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // بطاقة إحصائيات رئيسية
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _statCard(
//                       'المناقصات',
//                       totalTenders.toString(),
//                       Colors.deepPurple,
//                     ),
//                     _statCard('العروض', totalBids.toString(), Colors.teal),
//                     _statCard(
//                       'متوسط العروض',
//                       avgBids.toStringAsFixed(2),
//                       Colors.orange,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 32),

//                 // رسم بياني شريطي لتحليل الأسعار
//                 Text(
//                   'تحليل الأسعار',
//                   style:
//                       Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ) ??
//                       const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   height: 250,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.deepPurple.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: BarChart(
//                     BarChartData(
//                       maxY: maxPrice * 1.2,
//                       barGroups: [
//                         BarChartGroupData(
//                           x: 0,
//                           barRods: [
//                             BarChartRodData(
//                               toY: minPrice,
//                               color: Colors.blueAccent,
//                               width: 22,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ],
//                         ),
//                         BarChartGroupData(
//                           x: 1,
//                           barRods: [
//                             BarChartRodData(
//                               toY: avgPrice,
//                               color: Colors.orangeAccent,
//                               width: 22,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ],
//                         ),
//                         BarChartGroupData(
//                           x: 2,
//                           barRods: [
//                             BarChartRodData(
//                               toY: maxPrice,
//                               color: Colors.redAccent,
//                               width: 22,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ],
//                         ),
//                       ],
//                       titlesData: FlTitlesData(
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               switch (value.toInt()) {
//                                 case 0:
//                                   return const Text('أدنى');
//                                 case 1:
//                                   return const Text('متوسط');
//                                 case 2:
//                                   return const Text('أعلى');
//                                 default:
//                                   return const SizedBox.shrink();
//                               }
//                             },
//                           ),
//                         ),
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             interval: maxPrice / 5,
//                             reservedSize: 42,
//                           ),
//                         ),
//                         rightTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         topTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                       gridData: FlGridData(show: true),
//                       borderData: FlBorderData(show: false),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // قائمة أفضل المقاولين
//                 Text(
//                   'أفضل المقاولين',
//                   style:
//                       Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ) ??
//                       const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 12),

//                 if (topContractors.isEmpty)
//                   const Text('لا توجد بيانات للمقاولين')
//                 else
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: topContractors.length,
//                     separatorBuilder: (context, index) => const Divider(),
//                     itemBuilder: (context, index) {
//                       final c = topContractors[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.deepPurple.shade100,
//                           child: Text(
//                             c['user']?['name'] != null &&
//                                     c['user']['name'].isNotEmpty
//                                 ? c['user']['name'][0]
//                                 : '?',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         title: Text(
//                           c['user']?['name'] ?? 'غير معروف',
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         subtitle: Text(c['company_name'] ?? ''),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.teal.shade100,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${c['bids_count'] ?? 0} عروض',
//                             style: const TextStyle(color: Colors.teal),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _statCard(String title, String value, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         color: color.withOpacity(0.15),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
//           child: Column(
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   // color: color[700] ?? color,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
