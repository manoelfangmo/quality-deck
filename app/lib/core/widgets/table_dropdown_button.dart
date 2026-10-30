import 'package:app/core/widgets/extensions.dart';
import 'package:flutter/material.dart';

class DropDownAction {
  String actionName;
  Function onClick;
  bool isDestructive;
  DropDownAction({
    required this.actionName,
    required this.onClick,
    this.isDestructive = false,
  });
}

class TableDropdownButton extends StatelessWidget {
  const TableDropdownButton({required this.actions, super.key});
  final List<DropDownAction> actions;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          context.colors.onSurface.withValues(alpha: 0.1),
        ),
        minimumSize: WidgetStateProperty.all(const Size(44, 44)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      icon: const Icon(Icons.more_horiz),
      // Open below the button so items stay in the table viewport on web.
      position: PopupMenuPosition.under,
      onSelected: (String actionName) {
        actions
            .firstWhere(
              (DropDownAction action) => action.actionName == actionName,
            )
            .onClick();
      },
      itemBuilder: (BuildContext context) => actions
          .map(
            (DropDownAction action) => PopupMenuItem<String>(
              key: ValueKey<String>(action.actionName),
              value: action.actionName,
              child: Text(
                action.actionName,
                style: action.isDestructive
                    ? TextStyle(color: Theme.of(context).colorScheme.error)
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }
}
