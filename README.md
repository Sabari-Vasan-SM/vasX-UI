<div align="center">

# vasX UI

<img src="https://blogger.googleusercontent.com/img/a/AVvXsEj5z00l8ryUmp-gmTCVZ2-IDj5wiCAxTnLWBhiqiSDPF2towXOyHbU0Auq4HkJOxqDxy8FHQFYUoa9yiWeq_vzg5-O2kXIVe41d6gkCzpG_65Ofa01OfoaLFzXegBU765wdScKtOgqPE95Lwrq4wbCtPuCV4c9AfZkm9fzllQB64JiysiZGP6Sqem6rFPyr" alt="vasX UI Banner" width="100%"/>

**A comprehensive collection of beautiful, reusable Flutter widgets built for production-grade applications.**

[![pub version](https://img.shields.io/pub/v/vasx_ui?color=blue)](https://pub.dev/packages/vasx_ui)
[![Live Demo](https://img.shields.io/badge/Live_Demo-vasxui.netlify.app-00C7B7?logo=netlify)](https://vasxui.netlify.app/)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Sabari-Vasan-SM/vasX-UI?style=social)](https://github.com/Sabari-Vasan-SM/vasX-UI)
[![Developer](https://img.shields.io/badge/Developer-Sabari_Vasan-02569B)](https://portfolio.sabari.me/)

<br/>

👉 **[Explore Live Interactive Web Demo 🌐](https://vasxui.netlify.app/)**

</div>

---

## 📖 Table of Contents
- [Description](#-description)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Widget Catalog](#-widget-catalog)
  - [AppPopupMenu](#apppopupmenu)
  - [CustomTable](#customtable)
  - [VerticalWizardShell](#verticalwizardshell)
  - [ScrollableWizardShell](#scrollablewizardshell)
  - [SearchableDropdown](#searchabledropdown)
  - [MultiSelectSearchableDropdown](#multiselectsearchabledropdown)
  - [CreatableDropdown](#creatabledropdown)
  - [DropdownDatePicker](#dropdowndatepicker)
  - [CustomDateRangePickerDialog](#customdaterangepickerdialog)
- [Folder Structure](#-folder-structure)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [Author](#-author)
- [License](#-license)

---

## 📝 Description

**vasX UI** is an extensively crafted UI library for Flutter. Instead of rewriting common complex UI components like multi-step wizards, searchable dropdowns, and customizable tables, `vasx_ui` provides highly polished, fully customizable, and deeply integrated widgets that you can plug directly into your production apps. It follows modern design principles out of the box with fluid animations, adaptive layouts, and a cohesive color system.

---

## ✨ Features

- 🎯 **Production Ready:** Built and tested for robust enterprise applications.
- 🎨 **Highly Customizable:** Easily override colors, typography, and behaviors.
- 🧩 **Modular Components:** Import only what you need.
- 📱 **Responsive:** Looks great on mobile, tablet, and desktop screens.
- 🚀 **Smooth Animations:** Integrated micro-interactions for a premium feel.
- 🌈 **Built-in Theming:** Consistent design language via `VasxColors`.

---

## 📸 Screenshots

![vasX UI Components](image/ui_image.png)

*(Above: A showcase of the versatile widgets included in vasX UI)*

### 🎬 Animated Demo
*(Coming soon)*
<!-- <img src="https://via.placeholder.com/800x400.gif?text=Demo+GIF" alt="vasX UI Demo" width="100%"/> -->

---

## 🚀 Installation

Add `vasx_ui` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  vasx_ui: ^0.0.1
```

Or run the following command in your terminal:

```bash
flutter pub add vasx_ui
```

---

## ⚡ Quick Start

Import the package anywhere in your project:

```dart
import 'package:vasx_ui/vasx_ui.dart';
```

Use the cohesive color tokens provided by the library to match your app's theme:

```dart
Container(
  color: VasxColors.primarySurface,
  child: Text(
    'Welcome to vasX UI',
    style: TextStyle(color: VasxColors.textPrimary),
  ),
);
```

---

## 🧩 Widget Catalog & Usage Examples

### AppPopupMenu
An animated scale and fade popup action menu, perfect for context actions.

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
      label: 'Duplicate',
      icon: Icons.copy,
      onTap: () => _onDuplicate(),
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
A responsive, horizontally-scrollable data table optimized for large datasets.

```dart
CustomTable(
  columns: const [
    CustomTableColumn(label: 'Name', flex: 2),
    CustomTableColumn(label: 'Email'),
    CustomTableColumn(label: 'Role'),
    CustomTableColumn(label: 'Action', alignment: Alignment.center),
  ],
  itemCount: users.length,
  rowBuilder: (context, index) {
    final user = users[index];
    return [
      Text(user.name),
      Text(user.email),
      Chip(label: Text(user.role)),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
        ],
      )
    ];
  },
)
```

---

### VerticalWizardShell
A multi-step wizard with a vertical left-hand stepper, ideal for complex desktop forms.

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
      icon: Icons.location_on_outlined,
      label: 'Address Details',
      mobileLabel: 'Address',
    ),
    WizardStepConfig(
      icon: Icons.check_circle_outline,
      label: 'Review & Confirm',
      mobileLabel: 'Review',
    ),
  ],
  currentStep: _currentStep,
  title: 'Registration',
  formContent: MyFormWidget(),
  onBack: _currentStep > 0 ? _prevStep : null,
  onNext: _nextStep,
  nextLabel: _currentStep == 2 ? 'Finish' : 'Next',
  onCancel: () => Navigator.pop(context),
)
```

---

### ScrollableWizardShell
An all-sections-visible scrollable form wizard with a progress tracker.

```dart
ScrollableWizardShell(
  steps: _steps,
  title: 'Create Profile',
  sectionContents: [
    PersonalDetailsForm(),
    AddressForm(),
    EducationForm(),
    EmploymentForm(),
    ReviewForm(),
  ],
  saving: _isSaving,
  onSave: _submitForm,
  onCancel: () => Navigator.pop(context),
)
```

---

### SearchableDropdown
A single-select dropdown with live search filtering.

```dart
SearchableDropdown(
  label: 'Country',
  value: _country,
  hint: 'Search country...',
  items: countries,
  onChanged: (val) => setState(() => _country = val),
)
```

---

### MultiSelectSearchableDropdown
A multi-select dropdown that displays selected items as visual chips.

```dart
MultiSelectSearchableDropdown(
  label: 'Frameworks',
  values: _selectedFrameworks,
  hint: 'Select frameworks',
  items: ['Flutter', 'React', 'Node.js', 'Vue', 'Angular'],
  onChanged: (vals) => setState(() => _selectedFrameworks = vals),
)
```

---

### CreatableDropdown
A versatile dropdown allowing users to select an existing item or create a new one inline.

```dart
CreatableDropdown(
  value: _selectedTag,
  items: _tags,
  hint: 'Search or create...',
  onChanged: (val) => setState(() => _selectedTag = val),
  onAddItem: (newTag) => setState(() {
    _tags.add(newTag);
    _selectedTag = newTag;
  }),
)
```

---

### DropdownDatePicker
A three-dropdown (Year / Month / Day) date picker, excellent for date of birth inputs.

```dart
DropdownDatePicker(
  controller: _dobController,
  label: 'Date of Birth',
  startYear: 1900,
  endYear: 2024,
  dateFormat: 'dd/MM/yyyy',
  showExtendYears: false,
)
```

---

### CustomDateRangePickerDialog
A beautifully designed dual-calendar date range picker dialogue.

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

## 📁 Folder Structure

```text
vasx_ui/
├── lib/
│   ├── src/
│   │   ├── widgets/        # All UI components
│   │   ├── theme/          # Color tokens and styling (VasxColors)
│   │   └── utils/          # Helpers and extensions
│   └── vasx_ui.dart        # Main export file
├── example/                # Full example app demonstrating all widgets
├── image/                  # Assets for README
├── test/                   # Unit and widget tests
└── pubspec.yaml            # Package configuration
```

---

## 🗺️ Roadmap

- [ ] Add `FileUploader` widget.
- [ ] Implement `Timeline` view component.
- [ ] Add dark mode explicit toggle support across all widgets.
- [x] Comprehensive widget tests coverage.
- [x] Publish interactive web demo: [vasxui.netlify.app](https://vasxui.netlify.app/)

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please [open an issue](https://github.com/Sabari-Vasan-SM/vasX-UI/issues). 

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👨‍💻 Author

**Sabari Vasan S M**
- Portfolio: [portfolio.sabari.me](https://portfolio.sabari.me/)
- GitHub: [@Sabari-Vasan-SM](https://github.com/Sabari-Vasan-SM)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
