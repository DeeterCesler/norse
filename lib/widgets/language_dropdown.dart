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

class LanguageDropdown extends StatefulWidget {
  final RuneSet selectedSet;
  final Function(RuneSet) onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedSet,
    required this.onChanged,
  });

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  // Manually show popup to control its position
  void _showPopupMenu() async {
    // Get the render box from the context
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    
    // Calculate position: center of button, at the bottom
    final buttonCenter = button.size.width / 2;
    final buttonBottom = button.size.height;
    
    // Show the menu and get the selected value
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(buttonCenter - 140, buttonBottom - 10), ancestor: overlay),
        button.localToGlobal(Offset(buttonCenter + 140, buttonBottom - 50), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    
    final result = await showMenu<RuneSet>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: RuneSet.values.map((RuneSet set) {
        return PopupMenuItem<RuneSet>(
          value: set,
          child: Text(
            set.displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
    
    // Call onChanged with the result if one was selected
    if (result != null) {
      widget.onChanged(result);
    }
  }

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
        child: InkWell(
          onTap: _showPopupMenu,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.selectedSet.displayName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
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
