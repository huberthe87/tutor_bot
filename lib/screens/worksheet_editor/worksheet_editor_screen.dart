import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/worksheet_editor/image_region_selector.dart';
import '../../widgets/worksheet_editor/region_controls.dart';
import '../../widgets/worksheet_editor/worksheet_editor_state.dart';
import 'package:provider/provider.dart';

class WorksheetEditorScreen extends StatefulWidget {
  final File? imageFile;

  const WorksheetEditorScreen({
    super.key,
    this.imageFile,
  });

  @override
  State<WorksheetEditorScreen> createState() => _WorksheetEditorScreenState();
}

class _WorksheetEditorScreenState extends State<WorksheetEditorScreen> {
  late final WorksheetEditorState _editorState;
  String _selectedLanguage = 'English';
  String _selectedSubject = 'Math';

  final List<String> _languages = ['English', 'Chinese'];
  final List<String> _subjects = ['Math', 'English', 'Chinese Literature'];

  @override
  void initState() {
    super.initState();
    _editorState = WorksheetEditorState();

    // Initialize with the initial image if provided
    if (widget.imageFile != null) {
      _editorState.setImage(widget.imageFile!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we have arguments from the route
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is File && _editorState.image == null) {
      _editorState.setImage(args);
    }
  }

  void _sendForGrading() {
    if (_editorState.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/grading',
      arguments: {
        'imageFile': _editorState.image!,
        'subject': _selectedSubject,
        'language': _selectedLanguage,
      },
    );
  }

  Widget _buildSettingsBar() {
    final dropdownWidth =
        MediaQuery.of(context).size.width * 0.4; // 40% of screen width

    final dropdownDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).dividerColor,
      ),
      color: Theme.of(context).cardColor,
    );

    Widget buildStyledDropdown({
      required String value,
      required List<String> items,
      required String hint,
      required ValueChanged<String?> onChanged,
    }) {
      return Container(
        width: dropdownWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: dropdownDecoration,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(hint),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // Ensure proper font for Chinese characters
                  fontFamily: 'Noto Sans SC',
                ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // Use a font that supports Chinese characters
                    fontFamily:
                        item == 'Chinese' || item == 'Chinese Literature'
                            ? 'Noto Sans SC'
                            : null,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildStyledDropdown(
            value: _selectedLanguage,
            items: _languages,
            hint: 'Language',
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
          ),
          buildStyledDropdown(
            value: _selectedSubject,
            items: _subjects,
            hint: 'Subject',
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedSubject = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _editorState,
      child: Consumer<WorksheetEditorState>(
        builder: (context, editorState, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Worksheet Editor'),
              actions: [
                if (editorState.image != null) ...[
                  IconButton(
                    icon:
                        Icon(editorState.isEditMode ? Icons.check : Icons.edit),
                    onPressed: editorState.toggleEditMode,
                    tooltip: editorState.isEditMode
                        ? 'Finish Editing'
                        : 'Edit Regions',
                    color: editorState.isEditMode ? Colors.green : null,
                  ),
                  if (!editorState.isEditMode)
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendForGrading,
                      tooltip: 'Send for Grading',
                    ),
                  if (editorState.selectedRegions.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.crop),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/regionDebug',
                          arguments: {
                            'imageFile': editorState.image!,
                            'regions': editorState.selectedRegions,
                            'screenSize': editorState.imageContainerSize,
                          },
                        );
                      },
                      tooltip: 'View Cropped Regions',
                    ),
                ],
              ],
            ),
            body: Expanded(
              child: InteractiveViewer(
                transformationController: editorState.transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: editorState.image == null
                      ? const Text('No image selected')
                      : ImageRegionSelector(
                          image: editorState.image!,
                          isEditMode: editorState.isEditMode,
                          imageContainerKey: editorState.imageContainerKey,
                          onRegionAdded: editorState.addRegion,
                          onContainerMeasured: editorState.setContainerSize,
                          selectedRegions: editorState.selectedRegions,
                        ),
                ),
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!editorState.isEditMode) _buildSettingsBar(),
                if (editorState.isEditMode &&
                    editorState.selectedRegions.isNotEmpty)
                  BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: RegionControls(
                        isEditMode: editorState.isEditMode,
                        regionCount: editorState.selectedRegions.length,
                        onUndo: editorState.undoLastRegion,
                        onClear: editorState.clearRegions,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _editorState.dispose();
    super.dispose();
  }
}
