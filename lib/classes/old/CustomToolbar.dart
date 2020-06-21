// import 'dart:math' as math;

// import 'package:extended_text/extended_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// class CustomToolbar
//     extends ExtendedMaterialTextSelectionControls {
//   CustomToolbar();
//   @override
//   Widget buildToolbar(
//     BuildContext context,
//     Rect globalEditableRegion,
//     double textLineHeight,
//     Offset position,
    
//     List<TextSelectionPoint> endpoints,
//     TextSelectionDelegate delegate,
//   ) {
//     assert(debugCheckHasMediaQuery(context));
//     assert(debugCheckHasMaterialLocalizations(context));

//     // The toolbar should appear below the TextField
//     // when there is not enough space above the TextField to show it.
//     final TextSelectionPoint startTextSelectionPoint = endpoints[0];
//     final TextSelectionPoint endTextSelectionPoint =
//         (endpoints.length > 1) ? endpoints[1] : null;
//     final double x = (endTextSelectionPoint == null)
//         ? startTextSelectionPoint.point.dx
//         : (startTextSelectionPoint.point.dx + endTextSelectionPoint.point.dx) /
//             2.0;
//     final double availableHeight = globalEditableRegion.top -
//         MediaQuery.of(context).padding.top;
//     final double y = (availableHeight < 150)
//         ? startTextSelectionPoint.point.dy +
//             globalEditableRegion.height +
//             150 +
//             20
//         : startTextSelectionPoint.point.dy - textLineHeight * 2.0;
//     final Offset preciseMidpoint = Offset(x, y);
//    final ClipboardStatusNotifier clipboardStatusNotifier = ClipboardStatusNotifier();
//     return ConstrainedBox(
//       constraints: BoxConstraints.tight(globalEditableRegion.size),
//       child: CustomSingleChildLayout(
//         delegate: ExtendedMaterialTextSelectionToolbarLayout(
//           MediaQuery.of(context).size,
//           globalEditableRegion,
//           preciseMidpoint,
//         ),
//         child: _TextSelectionToolbar(
//           handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
//           handleCopy: canCopy(delegate) ? () => handleCopy(delegate, clipboardStatusNotifier) : null,
//           handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
//           handleSelectAll:
//               canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
//           handleLike: () {
//             //mailto:<email address>?subject=<subject>&body=<body>, e.g.
          
//             delegate.hideToolbar();
//             //clear selecction
//             delegate.textEditingValue = delegate.textEditingValue.copyWith(
//                 selection: TextSelection.collapsed(
//                     offset: delegate.textEditingValue.selection.end));
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget buildHandle(
//       BuildContext context, TextSelectionHandleType type, double textHeight) {
//     final Widget handle = SizedBox(
//       width: 30,
//       height: 30,
//       child: Image.asset("assets/love.png"),
//     );

//     // [handle] is a circle, with a rectangle in the top left quadrant of that
//     // circle (an onion pointing to 10:30). We rotate [handle] to point
//     // straight up or up-right depending on the handle type.
//     switch (type) {
//       case TextSelectionHandleType.left: // points up-right
//         return Transform.rotate(
//           angle: math.pi / 4.0,
//           child: handle,
//         );
//       case TextSelectionHandleType.right: // points up-left
//         return Transform.rotate(
//           angle: -math.pi / 4.0,
//           child: handle,
//         );
//       case TextSelectionHandleType.collapsed: // points up
//         return handle;
//     }
//     assert(type != null);
//     return null;
//   }
// }

// /// Manages a copy/paste text selection toolbar.
// class _TextSelectionToolbar extends StatelessWidget {
//   const _TextSelectionToolbar({
//     Key key,
//     this.handleCopy,
//     this.handleSelectAll,
//     this.handleCut,
//     this.handlePaste,
//     this.handleLike,
//   }) : super(key: key);

//   final VoidCallback handleCut;
//   final VoidCallback handleCopy;
//   final VoidCallback handlePaste;
//   final VoidCallback handleSelectAll;
//   final VoidCallback handleLike;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> items = <Widget>[];
//     final MaterialLocalizations localizations =
//         MaterialLocalizations.of(context);
//   final TextStyle style = TextStyle(
//     color: Theme.of(context).textTheme.headline6.color
//   );
//     if (handleCut != null)
//       items.add(FlatButton(
//           child: Text(localizations.cutButtonLabel), onPressed: handleCut));
//     if (handleCopy != null)
//       items.add(FlatButton(
//           child: Text(localizations.copyButtonLabel,
//             style: style,
//           ), onPressed: handleCopy));
//     if (handlePaste != null)
//       items.add(FlatButton(
//         child: Text(localizations.pasteButtonLabel,
//         style:style,
//         ),
//         onPressed: handlePaste,
//       ));
//     if (handleSelectAll != null)
//       items.add(FlatButton(
//           child: Text(localizations.selectAllButtonLabel,
//           style: style,
//           ),
//           onPressed: handleSelectAll));

//     if (handleLike != null)
//       items.add(FlatButton(child: Icon(Icons.favorite, color: Theme.of(context).textTheme.headline6.color,), onPressed: handleLike));

//     // If there is no option available, build an empty widget.
//     if (items.isEmpty) {
//       return Container(width: 0.0, height: 0.0);
//     }

//     return Material(
//       color: Theme.of(context).backgroundColor,
//       elevation: 2.0,
//       child: Wrap(children: items),
//       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//     );
//   }
// }
