import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/report_service.dart';

class PerformanceReportScreen extends StatefulWidget {
  const PerformanceReportScreen({super.key});

  @override
  State<PerformanceReportScreen> createState() =>
      _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    final result = await ReportService.getContractorPerformance();
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'تقرير الأداء',
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : data == null
              ? const Center(child: Text('فشل في تحميل البيانات'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTenderStatusChart(),
                    const SizedBox(height: 16),
                    _buildBidStatusChart(),
                    const SizedBox(height: 16),
                    _buildAverageDurationCard(),
                    const SizedBox(height: 16),
                    _buildContractorsTable(),
                  ],
                ),
              ),
    );
  }

  Widget _buildTenderStatusChart() {
    final tenderStats = data!['tendersStatusCount'] as List<dynamic>;
    return _buildPieChartSection("حالات المناقصات", tenderStats);
  }

  Widget _buildBidStatusChart() {
    final bidStats = data!['bidsStatusCount'] as List<dynamic>;
    return _buildPieChartSection("العروض المقبولة والمرفوضة", bidStats);
  }

  Widget _buildPieChartSection(String title, List<dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections:
                      stats.map((item) {
                        final statusRaw = item['status'];
                        final status =
                            statusRaw.toString().trim().toLowerCase();
                        final count = item['count'];

                        // ✅ تحديد اللون المخفف
                        Color color;
                        if (status.contains('مفتوحة') ||
                            status.contains('open') ||
                            status.contains('مقبول') ||
                            status.contains('accepted')) {
                          color = Colors.green.shade300;
                        } else if (status.contains('مغلقة') ||
                            status.contains('closed') ||
                            status.contains('مرفوض') ||
                            status.contains('rejected')) {
                          color = Colors.red.shade300;
                        } else {
                          color = Colors.blue.shade300;
                        }

                        return PieChartSectionData(
                          title: '${item['status']}\n$count',
                          value: (count as num).toDouble(),
                          color: color,
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageDurationCard() {
    final avg = data!['averageDuration'] ?? 0;
    return Card(
      color: Colors.blue.shade50,
      child: ListTile(
        leading: const Icon(Icons.timelapse, size: 40, color: Colors.blue),
        title: const Text('متوسط مدة التنفيذ'),
        subtitle: Text('$avg يوم'),
      ),
    );
  }

  Widget _buildContractorsTable() {
    final contractors = data!['contractors'] as List<dynamic>;
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'أداء المقاولين',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('المقاول')),
                DataColumn(label: Text('عدد العروض')),
                DataColumn(label: Text('عروض مقبولة')),
              ],
              rows:
                  contractors.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text(c['name'] ?? '')),
                        DataCell(Text('${c['total_bids']}')),
                        DataCell(Text('${c['accepted_bids']}')),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
