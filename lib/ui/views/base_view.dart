import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../core/util/logger.dart';
import '../../core/viewmodels/base_model.dart';
import '../../locator.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;

  BaseView({this.builder, this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  final Logger _logger = getLogger();

  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(create: (context) => model, child: Consumer<T>(builder: widget.builder));
  }

  @override
  void dispose() {
    Type type = T;
    _logger.d("Disposing '${type.toString()}'");
    super.dispose();
  }
}
