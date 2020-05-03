
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DateChangedCallback(dynamic data);

const double _kDatePickerHeight = 250.0;
const double _kDatePickerTitleHeight = 44.0;
const double _kDatePickerItemHeight = 44.0;
const double _kDatePickerFontSize = 22.0;

class DataPicker {
  static void showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    @required List<dynamic> datas,
    int selectedIndex: 0,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    suffix: '',
    title: '',
    locale: 'en',
  }) {
    Navigator.push(
        context,
        new _DatePickerRoute(
          showTitleActions: showTitleActions,
          initialData: selectedIndex,
          datas: datas,
          onChanged: onChanged,
          onConfirm: onConfirm,
          locale: locale,
          suffix: suffix,
          title: title,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.datas,
    this.initialData,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.locale,
    this.suffix,
    this.title,
    RouteSettings settings,
  }) : super(settings: settings);

  final List<dynamic> datas;
  final bool showTitleActions;
  final int initialData;
  final DateChangedCallback onChanged;
  final DateChangedCallback onConfirm;
  final ThemeData theme;
  final String locale;
  final String suffix;
  final String title;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DataPickerComponent(
        initialData: initialData,
        datas: datas,
        onChanged: onChanged,
        locale: locale,
        suffix: suffix,
        title: title,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DataPickerComponent extends StatefulWidget {
  _DataPickerComponent({
    Key key,
    @required this.route,
    this.initialData: 0,
    this.datas,
    this.onChanged,
    this.locale,
    this.suffix,
    this.title,
  });

  final DateChangedCallback onChanged;
  final int initialData;
  final List<dynamic> datas;

  final _DatePickerRoute route;

  final String locale;
  final String suffix;
  final String title;

  @override
  State<StatefulWidget> createState() => _DatePickerState(this.initialData);
}

class _DatePickerState extends State<_DataPickerComponent> {
  int _initialIndex;
  int _selectedColorIndex = 0;
  FixedExtentScrollController dataScrollCtrl;

  _DatePickerState(this._initialIndex) {
    if (this._initialIndex < 0) {
      this._initialIndex = 0;
    }
    dataScrollCtrl =
        new FixedExtentScrollController(initialItem: _selectedColorIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(widget.route.animation.value,
                  showTitleActions: widget.route.showTitleActions),
              child: new GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setData(int index) {
    if (_initialIndex != index) {
      _initialIndex = index;
      setState(() {});
      _notifyDateChanged();
    }
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.datas[_initialIndex]);
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();
    if (widget.route.showTitleActions) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderDataPickerComponent(String suffixAppend) {
    return new Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(10.0),
          height: _kDatePickerHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
           // borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
          ),
          child: CupertinoPicker(
            backgroundColor: Theme.of(context).cardColor,
            scrollController: dataScrollCtrl,
            itemExtent: _kDatePickerItemHeight,
            onSelectedItemChanged: (int index) {
              _setData(index);
            },
            children: List.generate(widget.datas.length, (int index) {
              return Container(
                height: _kDatePickerItemHeight,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    new Expanded(
                        child: Text(
                      '${widget.datas[index]}$suffixAppend',
                      style: TextStyle(
                          color: Color(0xFF000046),
                          fontSize: _kDatePickerFontSize),
                      textAlign: TextAlign.center,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ))
                  ],
                ),
              );
            }),
          )),
    );
  }

  Widget _renderItemView() {
    return _renderDataPickerComponent(widget.suffix);
  }

  // Title View
  Widget _renderTitleActionsView() {

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 40,
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontSize: 20.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            height: _kDatePickerTitleHeight,
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('done'),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm(widget.datas[_initialIndex]);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = _kDatePickerHeight;
    if (showTitleActions) {
      maxHeight += _kDatePickerTitleHeight;
    }

    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
