import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/service/service_model.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../constantes.dart';

Widget logo(CategoryModel map, BuildContext context) {
  if (map.imageBlack != '' && map.imageWhite != '') {
    return context.watch<ThemeBloc>().state.theme.brightness == AppTheme.light.brightness
        ? Image.asset(map.imageBlack!, scale: map.imageBlackSize)
        : Image.asset(map.imageWhite!, scale: map.imageWhiteSize);
  } else {
    return FaIcon(map.icon, size: 50);
  }
}
