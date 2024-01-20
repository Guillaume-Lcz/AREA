import 'package:flutter/material.dart';
import 'package:reactobot/constantes.dart';

import '../../../bloc/service/service_model.dart';
import '../../../widgets/display_logo/display_logo.dart';
import '../../service_category_page/pages/service_category_page.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.map,
    required this.index,
  });

  final List<CategoryModel> map;
  final int index;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.borderColor;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        showModalBottomSheet(
          elevation: 5,
          showDragHandle: true,
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return ServiceCategoryPage(
              map: map,
              index: index,
            );
          },
        );
      },
      child: Card(
        color: map[index].color == Colors.transparent
            ? Theme.of(context).primaryColor
            : map[index].color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 4),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(map[index].service),
            logo(map[index], context),
          ],
        ),
      ),
    );
  }
}
