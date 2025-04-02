import 'package:flutter/material.dart';

enum RuneSet {
  youngerLongBranch('Younger Futhark (Long Branch)', 'Younger', 'Long-Branch'),
  youngerShortTwig('Younger Futhark (Short Twig)', 'Younger', 'Short-Twig'),
  elderFuthark('Elder Futhark', 'Elder', '');

  final String displayName;
  final String era;
  final String subtype;

  const RuneSet(this.displayName, this.era, this.subtype);
}

class LanguageDropdown extends StatelessWidget {
  final RuneSet selectedSet;
  final Function(RuneSet) onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedSet,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<RuneSet>(
          initialValue: selectedSet,
          onSelected: onChanged,
          itemBuilder: (BuildContext context) {
            return RuneSet.values.map((RuneSet set) {
              return PopupMenuItem<RuneSet>(
                value: set,
                child: Text(
                  set.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedSet.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
