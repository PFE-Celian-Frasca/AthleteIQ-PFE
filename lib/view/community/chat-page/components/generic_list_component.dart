import 'package:flutter/material.dart';

class GenericListComponent<T> extends StatelessWidget {
  final void Function(T) onItemSelected;
  final List<String> selectedIds;
  final String excludeId;
  final List<T> items;
  final String Function(T) idExtractor;
  final Widget Function(BuildContext, T) buildItem;
  final Icon icon;

  const GenericListComponent({
    super.key,
    required this.onItemSelected,
    required this.selectedIds,
    required this.excludeId,
    required this.items,
    required this.idExtractor,
    required this.buildItem,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final itemId = idExtractor(item);

        if (itemId == excludeId) {
          return const SizedBox.shrink();
        }

        return ListTile(
          leading: icon,
          title: buildItem(context, item),
          trailing: Checkbox(
            value: selectedIds.contains(itemId),
            onChanged: (bool? value) {
              onItemSelected(item);
            },
          ),
        );
      },
    );
  }
}
