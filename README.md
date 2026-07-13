# vasX UI

> A collection of beautiful, reusable Flutter widgets — smart dropdowns, date pickers, multi-step wizards, animated popup menus, and responsive data tables. Built for production-grade Flutter apps.

[![pub version](https://img.shields.io/badge/pub-0.0.1-blue)](https://pub.dev/packages/vasx_ui)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22-02569B)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Widgets

| Widget | Description |
|--------|-------------|
| `AppPopupMenu` | Animated scale+fade popup action menu |
| `CustomTable` | Responsive, horizontally-scrollable data table |
| `VerticalWizardShell` | Multi-step wizard with a vertical left stepper |
| `ScrollableWizardShell` | All-sections-visible scrollable form wizard |
| `SearchableDropdown` | Single-select dropdown with live search |
| `MultiSelectSearchableDropdown` | Multi-select dropdown with chip display |
| `CreatableDropdown` | Dropdown with inline item creation |
| `DropdownDatePicker` | Three-dropdown (Year / Month / Day) date picker |
| `CustomDateRangePickerDialog` | Dual-calendar date range picker |

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  vasx_ui: ^0.0.1
```

Then run:

```bash
flutter pub get
```

Import anywhere in your project:

```dart
import 'package:vasx_ui/vasx_ui.dart';
```

---

## Usage Examples

### AppPopupMenu

```dart
AppPopupMenu(
  onClose: () => overlayEntry.remove(),
  items: [
    AppPopupMenuItem(
      label: 'Edit',
      icon: Icons.edit_outlined,
      onTap: () => _onEdit(),
    ),
    AppPopupMenuItem(
      label: 'Delete',
      icon: Icons.delete_outline,
      isDestructive: true,
      onTap: () => _onDelete(),
    ),
  ],
)
```

---

### CustomTable

```dart
CustomTable(
  columns: const [
    CustomTableColumn(label: 'Name', flex: 2),
    CustomTableColumn(label: 'Email'),
    CustomTableColumn(label: 'Actions', alignment: Alignment.center),
  ],
  itemCount: students.length,
  rowBuilder: (context, index) {
    final s = students[index];
    return [
      Text(s.name),
      Text(s.email),
      IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
    ];
  },
)
```

---

### VerticalWizardShell

```dart
VerticalWizardShell(
  steps: const [
    WizardStepConfig(
      icon: Icons.person_outline_rounded,
      label: 'Personal Info',
      mobileLabel: 'Personal',
      subtitle: 'Name & contact',
    ),
    WizardStepConfig(
      icon: Icons.check_circle_outline,
      label: 'Review',
      mobileLabel: 'Review',
    ),
  ],
  currentStep: _currentStep,
  title: 'Registration',
  formContent: MyFormWidget(),
  onBack: _currentStep > 0 ? _prevStep : null,
  onNext: _nextStep,
  nextLabel: _currentStep == 1 ? 'Finish' : 'Next',
  onCancel: () => Navigator.pop(context),
)
```

---

### ScrollableWizardShell

```dart
ScrollableWizardShell(
  steps: _steps,
  title: 'Create Student',
  sectionContents: [
    CoreDetailsForm(),
    BasicDetailsForm(),
    AddressForm(),
  ],
  saving: _isSaving,
  onSave: _submitForm,
  onCancel: () => Navigator.pop(context),
)
```

---

### SearchableDropdown

```dart
SearchableDropdown(
  label: 'Country',
  value: _country,
  hint: 'Select a country',
  items: countries,
  onChanged: (val) => setState(() => _country = val),
)
```

---

### MultiSelectSearchableDropdown

```dart
MultiSelectSearchableDropdown(
  label: 'Subjects',
  values: _selectedSubjects,
  hint: 'Select subjects',
  items: allSubjects,
  onChanged: (vals) => setState(() => _selectedSubjects = vals),
)
```

---

### CreatableDropdown

```dart
CreatableDropdown(
  value: _selectedClass,
  items: _classes,
  onChanged: (val) => setState(() => _selectedClass = val),
  onAddItem: (newClass) => setState(() {
    _classes.add(newClass);
    _selectedClass = newClass;
  }),
)
```

---

### DropdownDatePicker

```dart
DropdownDatePicker(
  controller: _dobController,
  label: 'Date of Birth',
  startYear: 1950,
  endYear: 2010,
  dateFormat: 'dd/MM/yyyy',
  showExtendYears: true,
)
```

---

### CustomDateRangePickerDialog

```dart
final range = await showCustomDateRangePicker(
  context: context,
  initialDateRange: _selectedRange,
);
if (range != null) {
  setState(() => _selectedRange = range);
}
```

---

## Theming

All widgets accept an optional `primaryColor` parameter.  
You can also use `VasxColors` for consistent color tokens:

```dart
import 'package:vasx_ui/vasx_ui.dart';

// Use color tokens
Container(color: VasxColors.primarySurface)
Text('Hello', style: TextStyle(color: VasxColors.textPrimary))
```

---

## Example App

A complete example app demonstrating all widgets is in the [`example/`](example/) folder.

```bash
cd example
flutter run
```

---

## License

[MIT](LICENSE) © 2026 Harvee Designs
