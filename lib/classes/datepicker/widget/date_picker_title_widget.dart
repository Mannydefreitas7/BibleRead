import 'package:flutter/material.dart';

import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import '../i18n/date_picker_i18n.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DatePickerTitleWidget extends StatelessWidget {
  DatePickerTitleWidget({
    Key key,
    this.pickerTheme,
    this.locale,
    this.title,
    @required this.onCancel,
    @required this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;
  final DateTimePickerLocale locale;
  final String title;
  final DateVoidCallback onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.title != null) {
      return pickerTheme.title;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: pickerTheme.titleHeight,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color:pickerTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: pickerTheme.titleHeight,
            child: FlatButton(
                padding: EdgeInsets.all(5),
                child: _renderCancelWidget(context),
                onPressed: () => this.onCancel()),
          ),
          Container(
            height: pickerTheme.titleHeight,
            padding: EdgeInsets.all(15),
            child: Text(title,
            
            style: TextStyle(
              color: Theme.of(context).textTheme.title.color,
              fontSize: 22.0,
              fontWeight: FontWeight.w600
            ),
                ),
          ),
          Container(
            height: pickerTheme.titleHeight,
            child: FlatButton(
                child: _renderConfirmWidget(context),
                onPressed: () => this.onConfirm()),
          ),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    Widget cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
              color: Theme.of(context).errorColor, fontSize: 20.0);
      cancelWidget =
          Text(DatePickerI18n.getLocaleCancel(locale), style: textStyle);
    }
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0);
      confirmWidget =
          Text(DatePickerI18n.getLocaleDone(locale), style: textStyle);
    }
    return confirmWidget;
  }
}
