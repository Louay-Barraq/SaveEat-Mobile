import 'package:flutter/material.dart';
import 'package:save_eat/components/colored_button_widget.dart';

class QrResultWidget extends StatelessWidget {
  final String restaurant;
  final String tableId;
  final VoidCallback onSummon;
  final VoidCallback onScanAgain;

  const QrResultWidget({
    Key? key,
    required this.restaurant,
    required this.tableId,
    required this.onSummon,
    required this.onScanAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoField('Restaurant Name', restaurant),
        const SizedBox(height: 20),
        _buildInfoField('Table Number', tableId.replaceFirst('table_', '')),
        const SizedBox(height: 25),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      children: [
        // Header label (gray background)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inconsolata',
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),

        // Value container (white background)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inconsolata',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ColoredButtonWidget(
            text: 'Summon Robot',
            backgroundColor: Colors.green,
            onPressed: onSummon,
            height: 50,
            borderRadius: 10,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ColoredButtonWidget(
            text: 'Scan Again',
            backgroundColor: Colors.grey.shade600,
            onPressed: onScanAgain,
            height: 50,
            borderRadius: 10,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
