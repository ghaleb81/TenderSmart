import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';

class TenderItem extends StatelessWidget {
  const TenderItem({super.key, required this.tender});
  final Tender tender;

  // final List<Tender> tenders;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              tender.title,
            ), //, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 4),
            Row(
              children: [
                Text('\$${tender.budget.toString()}'),
                const Spacer(), //لابعاد العناصر عن بعضها اقصى ما يمكن
                Row(
                  children: [
                    // const Icon(Icons.alarm),
                    // Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 4),
                    Text(tender.descripe),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
