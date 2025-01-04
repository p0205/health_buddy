import 'dart:math';
import 'package:flutter/material.dart';


class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.dataList,
    required this.containerHeight,
    required this.columnLabel,
    required this.donutSizePercentage,
    this.centerText,
    this.centerTextColor
  });

  final List<ChartData> dataList;
  final double containerHeight;
  final String columnLabel;
  final double donutSizePercentage;
  final String? centerText;
  final Color? centerTextColor;

  @override
  Widget build(BuildContext context) {
    double valueTotal = dataList.fold(0, (sum, item) => sum + item.value);

    for (var data in dataList) {
     data.value == 0 ? data.percentage = 0  : data.percentage = data.value / valueTotal;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth =screenWidth * 0.85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(8.0, 10.0,),
                    blurRadius: 15,
                    spreadRadius: 1,
                    blurStyle: BlurStyle.normal
                )
              ]
          ),
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            children:
            [
              CustomPaint(
              painter: MultiSegmentPainter(dataList: dataList,containerHeight: containerHeight,containerWidth: containerWidth,donutSize: donutSizePercentage),
            ),

              Center(
                child: Text(
                    centerText ?? "",
                    style:  TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: centerTextColor,
                    ),
                    textAlign: TextAlign.center
                ),
              ),
            ]
          ),
        ),
        const SizedBox(height: 25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
               children: [
                 TableRow(
                   children: [
                     Container(
                       color: Colors.white,
                     ),
                     const Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 22),
                       child: const Text("Percentage"),
                     ),
                     Text(columnLabel),
                   ]
                 ),

                 // Data rows with spacer
                 ...dataList.map((data) => _buildTableRow(data)),

               ],
          ),
        )
      ],
    );
  }

}

TableRow _buildTableRow(ChartData data) {

  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 12,
              decoration: BoxDecoration(
                color: data.color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width:4),
            Text(
              data.name,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Itim",
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 70,
        decoration: BoxDecoration(
          color: data.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          '${(data.percentage! * 100).toStringAsFixed(1)}%',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Itim",
            color: Colors.black,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          data.value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Itim",
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

class MultiSegmentPainter extends CustomPainter {
  MultiSegmentPainter({
    required this.containerWidth,
    required this.containerHeight,
    required this.donutSize,
    required this.dataList,
  });

  final double containerWidth;
  final double containerHeight;
  final List<ChartData> dataList;
  final double donutSize;

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final center = Offset(containerWidth / 2, containerHeight / 2);
    final radius = containerHeight/ 2 - 15;

    for (var data in dataList) {
      double sweepAngle = 2 * pi * data.percentage!;
      paint.color = data.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center hole (for donut effect)
    paint.color = Colors.white;
    canvas.drawCircle(
      center,
      radius * donutSize, // Adjust this value to change the size of the hole
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChartData {
  final String name;
  final num value;
  final Color color;
  double? percentage;

  ChartData({
    required this.name,
    required this.value,
    required this.color,
  });
}