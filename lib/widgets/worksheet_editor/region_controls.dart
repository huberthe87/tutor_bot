import 'package:flutter/material.dart';

class RegionControls extends StatelessWidget {
  final bool isEditMode;
  final int regionCount;
  final VoidCallback onUndo;
  final VoidCallback onClear;

  const RegionControls({
    super.key,
    required this.isEditMode,
    required this.regionCount,
    required this.onUndo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Row(
            children: [
              if (isEditMode && regionCount > 0)
                IconButton(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo Last Region',
                ),
              if (!isEditMode)
                Row(
                  children: [
                    IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.clear_all),
                      tooltip: 'Clear All Regions',
                    ),
                    Text('$regionCount regions selected'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
} 