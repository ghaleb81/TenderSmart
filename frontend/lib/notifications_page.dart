import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _loading = true;
  List<NotificationItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _loading = true);

    // استبدل بـ: استرجاع التوكن المحفوظ بعد تسجيل الدخول
    final token = await _getSanctumToken();

    try {
      final res = await Dio().get(
        'http://192.168.1.107:8000/api/notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _items =
          (res.data as List)
              .map((n) => NotificationItem.fromJson(n['data']))
              .toList();
    } catch (e) {
      // التعامل مع الخطأ
      debugPrint('Notification fetch error: $e');
    }

    setState(() => _loading = false);
  }

  Future<String> _getSanctumToken() async {
    // TODO: استرجاع التوكن المخزَّن في SharedPreferences أو SecureStorage
    return 'YOUR_TOKEN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchNotifications,
                child:
                    _items.isEmpty
                        ? const Center(child: Text('لا توجد إشعارات بعد.'))
                        : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 0),
                          itemBuilder: (_, i) {
                            final n = _items[i];
                            return ListTile(
                              leading: const Icon(
                                Icons.notifications_active_outlined,
                              ),
                              title: Text(n.title),
                              subtitle: Text(n.body),
                              onTap:
                                  n.tenderId == null
                                      ? null
                                      : () {
                                        // انتقل إلى تفاصيل المناقصة مثلًا
                                        // Navigator.push(...);
                                      },
                            );
                          },
                        ),
              ),
    );
  }
}
