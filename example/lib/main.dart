import 'package:flutter/material.dart';
import 'package:vasx_ui/vasx_ui.dart';

void main() {
  runApp(const VasxUiExampleApp());
}

class VasxUiExampleApp extends StatelessWidget {
  const VasxUiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vasX UI Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: VasxColors.primary,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

// ─────────────────────────────────────────────
// Home Page — widget gallery navigation
// ─────────────────────────────────────────────
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      _GalleryItem('AppPopupMenu', Icons.more_vert,
          const AppPopupMenuExample()),
      _GalleryItem(
          'CustomTable', Icons.table_chart_outlined, const CustomTableExample()),
      _GalleryItem('VerticalWizardShell', Icons.linear_scale,
          const VerticalWizardExample()),
      _GalleryItem('ScrollableWizardShell', Icons.view_stream_outlined,
          const ScrollableWizardExample()),
      _GalleryItem('SearchableDropdown', Icons.search,
          const SearchableDropdownExample()),
      _GalleryItem('MultiSelectDropdown', Icons.checklist,
          const MultiSelectDropdownExample()),
      _GalleryItem(
          'CreatableDropdown', Icons.add_box_outlined, const CreatableDropdownExample()),
      _GalleryItem('DropdownDatePicker', Icons.calendar_month_outlined,
          const DropdownDatePickerExample()),
      _GalleryItem('DateRangePicker', Icons.date_range,
          const DateRangePickerExample()),
      _GalleryItem('CrmCalendar', Icons.calendar_month,
          const CrmCalendarExample()),
      _GalleryItem('CrmStatsDashboard', Icons.dashboard_outlined,
          const CrmStatsDashboardExample()),
      _GalleryItem('Form', Icons.dynamic_form_outlined,
          const CustomFormExample()),
      _GalleryItem('Buttons & Action Bar', Icons.smart_button_outlined,
          const ButtonsExample()),
      _GalleryItem('Toggle Switch', Icons.toggle_on_outlined,
          const ToggleExample()),
      _GalleryItem('Checkbox', Icons.check_box_outlined,
          const CheckboxExample()),
      _GalleryItem('AI Assistant SearchBar', Icons.auto_awesome_outlined,
          const AiSearchBarExample()),
      _GalleryItem('Payment Confirmation Popup', Icons.receipt_long_outlined,
          const PaymentConfirmationExample()),
      _GalleryItem('Alert Banners', Icons.notifications_active_outlined,
          const AlertExample()),
      _GalleryItem('Side Menu (E-Commerce)', Icons.menu_open_rounded,
          const SideMenuExample()),
      _GalleryItem('Mobile Bottom NavBar', Icons.navigation_rounded,
          const BottomNavBarExample()),
    ];

    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(
        title: const Text('vasX UI Widget Gallery'),
        backgroundColor: VasxColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final item = sections[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(item.icon, color: VasxColors.primary),
              title: Text(item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: VasxColors.textPrimary)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.page),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GalleryItem {
  final String title;
  final IconData icon;
  final Widget page;
  const _GalleryItem(this.title, this.icon, this.page);
}

// ─────────────────────────────────────────────
// AppPopupMenu Example
// ─────────────────────────────────────────────
class AppPopupMenuExample extends StatefulWidget {
  const AppPopupMenuExample({super.key});

  @override
  State<AppPopupMenuExample> createState() => _AppPopupMenuExampleState();
}

class _AppPopupMenuExampleState extends State<AppPopupMenuExample> {
  String _lastAction = 'No action yet';

  void _showMenu(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 120,
        right: 24,
        child: AppPopupMenu(
          onClose: () => entry.remove(),
          items: [
            AppPopupMenuItem(
              label: 'Edit',
              icon: Icons.edit_outlined,
              onTap: () {
                if (mounted) setState(() => _lastAction = 'Edit tapped');
              },
            ),
            AppPopupMenuItem(
              label: 'Duplicate',
              icon: Icons.copy_outlined,
              onTap: () {
                if (mounted) setState(() => _lastAction = 'Duplicate tapped');
              },
            ),
            AppPopupMenuItem(
              label: 'Delete',
              icon: Icons.delete_outline,
              isDestructive: true,
              onTap: () {
                if (mounted) setState(() => _lastAction = 'Delete tapped');
              },
            ),
          ],
        ),
      ),
    );
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppPopupMenu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showMenu(context),
              icon: const Icon(Icons.more_vert),
              label: const Text('Show Popup Menu'),
            ),
            const SizedBox(height: 24),
            Text('Last: $_lastAction',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CustomTable Example
// ─────────────────────────────────────────────
class CustomTableExample extends StatelessWidget {
  const CustomTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      ['Alice Johnson', 'Class 10-A', 'alice@school.com'],
      ['Bob Smith', 'Class 9-B', 'bob@school.com'],
      ['Carol White', 'Class 11-C', 'carol@school.com'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('CustomTable')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomTable(
          columns: const [
            CustomTableColumn(label: 'Name', flex: 2),
            CustomTableColumn(label: 'Class'),
            CustomTableColumn(label: 'Email', flex: 2),
          ],
          itemCount: data.length,
          minWidth: 600,
          rowBuilder: (context, index) => [
            Text(data[index][0]),
            Text(data[index][1]),
            Text(data[index][2]),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VerticalWizardShell Example
// ─────────────────────────────────────────────
class VerticalWizardExample extends StatefulWidget {
  const VerticalWizardExample({super.key});

  @override
  State<VerticalWizardExample> createState() =>
      _VerticalWizardExampleState();
}

class _VerticalWizardExampleState extends State<VerticalWizardExample> {
  int _step = 0;

  static const _steps = [
    WizardStepConfig(
      icon: Icons.person_outline_rounded,
      label: 'Personal Info',
      mobileLabel: 'Personal',
      subtitle: 'Name & contact',
    ),
    WizardStepConfig(
      icon: Icons.location_on_outlined,
      label: 'Address',
      mobileLabel: 'Address',
      subtitle: 'Current address',
    ),
    WizardStepConfig(
      icon: Icons.check_circle_outline,
      label: 'Review',
      mobileLabel: 'Review',
      subtitle: 'Confirm details',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return VerticalWizardShell(
      steps: _steps,
      currentStep: _step,
      title: 'Registration Wizard',
      formContent: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'Step ${_step + 1} form content goes here.',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      onBack: _step > 0
          ? () => setState(() => _step--)
          : null,
      onNext: _step < _steps.length - 1
          ? () => setState(() => _step++)
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wizard complete!')),
              );
              Navigator.pop(context);
            },
      nextLabel: _step == _steps.length - 1 ? 'Finish' : 'Next',
      onCancel: () => Navigator.pop(context),
    );
  }
}

// ─────────────────────────────────────────────
// ScrollableWizardShell Example
// ─────────────────────────────────────────────
class ScrollableWizardExample extends StatefulWidget {
  const ScrollableWizardExample({super.key});

  @override
  State<ScrollableWizardExample> createState() =>
      _ScrollableWizardExampleState();
}

class _ScrollableWizardExampleState
    extends State<ScrollableWizardExample> {
  bool _saving = false;

  static const _steps = [
    WizardStepConfig(
      icon: Icons.person_outline_rounded,
      label: 'Core Details',
      mobileLabel: 'Core',
      subtitle: 'Name & roll number',
    ),
    WizardStepConfig(
      icon: Icons.description_outlined,
      label: 'Basic Details',
      mobileLabel: 'Basic',
      subtitle: 'Class & contact info',
    ),
    WizardStepConfig(
      icon: Icons.location_on_outlined,
      label: 'Address',
      mobileLabel: 'Address',
      subtitle: 'Current address',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollableWizardShell(
      steps: _steps,
      title: 'Create Student',
      sectionContents: List.generate(
        _steps.length,
        (i) => Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Section ${i + 1} — ${_steps[i].label}.\nAdd your form fields here.',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
      saving: _saving,
      onSave: () async {
        setState(() => _saving = true);
        await Future.delayed(const Duration(seconds: 2));
        if (!context.mounted) return;
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved!')),
        );
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}

// ─────────────────────────────────────────────
// SearchableDropdown Example
// ─────────────────────────────────────────────
class SearchableDropdownExample extends StatefulWidget {
  const SearchableDropdownExample({super.key});

  @override
  State<SearchableDropdownExample> createState() =>
      _SearchableDropdownExampleState();
}

class _SearchableDropdownExampleState
    extends State<SearchableDropdownExample> {
  String? _selected;

  static const _countries = [
    'India', 'United States', 'United Kingdom', 'Canada',
    'Australia', 'Germany', 'France', 'Japan', 'Brazil', 'South Africa',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchableDropdown')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdown(
              label: 'Country',
              value: _selected,
              hint: 'Select a country',
              items: _countries,
              onChanged: (val) => setState(() => _selected = val),
            ),
            const SizedBox(height: 24),
            if (_selected != null)
              Text('Selected: $_selected',
                  style: const TextStyle(
                      fontSize: 16, color: VasxColors.primary)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MultiSelectSearchableDropdown Example
// ─────────────────────────────────────────────
class MultiSelectDropdownExample extends StatefulWidget {
  const MultiSelectDropdownExample({super.key});

  @override
  State<MultiSelectDropdownExample> createState() =>
      _MultiSelectDropdownExampleState();
}

class _MultiSelectDropdownExampleState
    extends State<MultiSelectDropdownExample> {
  List<String> _selected = [];

  static const _subjects = [
    'Mathematics', 'Physics', 'Chemistry', 'Biology',
    'English', 'History', 'Geography', 'Computer Science',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiSelectSearchableDropdown')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiSelectSearchableDropdown(
              label: 'Subjects',
              values: _selected,
              hint: 'Pick subjects',
              items: _subjects,
              onChanged: (vals) => setState(() => _selected = vals),
            ),
            const SizedBox(height: 24),
            if (_selected.isNotEmpty)
              Text('Selected: ${_selected.join(', ')}',
                  style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CreatableDropdown Example
// ─────────────────────────────────────────────
class CreatableDropdownExample extends StatefulWidget {
  const CreatableDropdownExample({super.key});

  @override
  State<CreatableDropdownExample> createState() =>
      _CreatableDropdownExampleState();
}

class _CreatableDropdownExampleState
    extends State<CreatableDropdownExample> {
  final List<String> _classes = ['Class 10-A', 'Class 10-B', 'Class 11-A'];
  String _selected = 'Class 10-A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CreatableDropdown')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Class', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            CreatableDropdown(
              value: _selected,
              items: _classes,
              onChanged: (val) => setState(() => _selected = val),
              onAddItem: (newClass) =>
                  setState(() {
                    _classes.add(newClass);
                    _selected = newClass;
                  }),
              onRemoveItem: (cls) => setState(() {
                _classes.remove(cls);
                if (_selected == cls) _selected = _classes.first;
              }),
            ),
            const SizedBox(height: 24),
            Text('Selected: $_selected',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DropdownDatePicker Example
// ─────────────────────────────────────────────
class DropdownDatePickerExample extends StatefulWidget {
  const DropdownDatePickerExample({super.key});

  @override
  State<DropdownDatePickerExample> createState() =>
      _DropdownDatePickerExampleState();
}

class _DropdownDatePickerExampleState
    extends State<DropdownDatePickerExample> {
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DropdownDatePicker')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownDatePicker(
              controller: _dobController,
              label: 'Date of Birth',
              startYear: 1950,
              endYear: 2010,
              showExtendYears: true,
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: _dobController,
              builder: (_, val, __) => Text(
                'Controller value: ${val.text.isEmpty ? "—" : val.text}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DateRangePicker Example
// ─────────────────────────────────────────────
class DateRangePickerExample extends StatefulWidget {
  const DateRangePickerExample({super.key});

  @override
  State<DateRangePickerExample> createState() =>
      _DateRangePickerExampleState();
}

class _DateRangePickerExampleState
    extends State<DateRangePickerExample> {
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomDateRangePicker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range),
              label: const Text('Pick Date Range'),
              onPressed: () async {
                final result = await showCustomDateRangePicker(
                  context: context,
                  initialDateRange: _range,
                );
                if (result != null) setState(() => _range = result);
              },
            ),
            const SizedBox(height: 24),
            if (_range != null)
              Text(
                'From: ${_range!.start.toLocal().toString().split(' ').first}\n'
                'To:   ${_range!.end.toLocal().toString().split(' ').first}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CrmCalendar Example
// ─────────────────────────────────────────────
class CrmCalendarExample extends StatefulWidget {
  const CrmCalendarExample({super.key});

  @override
  State<CrmCalendarExample> createState() => _CrmCalendarExampleState();
}

class _CrmCalendarExampleState extends State<CrmCalendarExample> {
  final List<CrmCalendarEvent> _events = [
    CrmCalendarEvent(
      id: '1',
      name: 'Rahul Sharma',
      date: DateTime.now(),
      time: '10:30 AM',
      stage: 'Visit Scheduled',
      notes: 'Campus tour requested for Engineering program.',
    ),
    CrmCalendarEvent(
      id: '2',
      name: 'Priya Patel',
      date: DateTime.now(),
      time: '02:00 PM',
      stage: 'Interview Call',
      notes: 'MBA scholarship evaluation interview.',
    ),
    CrmCalendarEvent(
      id: '3',
      name: 'Aarav Kumar',
      date: DateTime.now().add(const Duration(days: 1)),
      time: '11:00 AM',
      stage: 'New Lead',
      notes: 'Enquired via website form.',
    ),
    CrmCalendarEvent(
      id: '4',
      name: 'Ananya Verma',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '03:30 PM',
      stage: 'Admission Offered',
      notes: 'Offer letter dispatched.',
    ),
    CrmCalendarEvent(
      id: '5',
      name: 'Vikram Singh',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '09:30 AM',
      stage: 'Follow-up Required',
      notes: 'Pending fee structure discussion.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CrmCalendar')),
      body: CrmCalendar(
        events: _events,
        onEventView: (id) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing event ID: $id')),
          );
        },
        onEventEdit: (id) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Editing event ID: $id')),
          );
        },
        onPickDate: () async {
          return await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CrmStatsDashboard Example
// ─────────────────────────────────────────────
class CrmStatsDashboardExample extends StatefulWidget {
  const CrmStatsDashboardExample({super.key});

  @override
  State<CrmStatsDashboardExample> createState() =>
      _CrmStatsDashboardExampleState();
}

class _CrmStatsDashboardExampleState extends State<CrmStatsDashboardExample> {
  final Map<String, int> _leadsByStage = {
    'New Lead': 45,
    'Contacted': 32,
    'Follow-up Required': 18,
    'Interested': 28,
    'Visit Scheduled': 14,
    'Application Started': 22,
    'Interview Call': 10,
    'Admission Offered': 16,
    'Waitlisted': 5,
    'Lost Lead': 8,
    'Re-engaged': 12,
    'Cold Lead': 9,
  };

  final List<CrmTrendData> _trendData = List.generate(
    15,
    (i) => CrmTrendData(
      date: '2026-08-${(i + 1).toString().padLeft(2, '0')}',
      value: (15 + (i * 7) % 35).toDouble(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CrmStatsDashboard')),
      body: CrmStatsDashboard(
        totalLeads: 219,
        archivedLeadsCount: 24,
        leadsByStage: _leadsByStage,
        trendData: _trendData,
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 15),
        onDateRangeTap: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Date range filter tapped')),
          );
        },
        onViewArchived: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Archived leads tapped')),
          );
        },
        onViewAllApplications: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('View all applications tapped')),
          );
        },
        onViewLogs: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('View logs tapped')),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Buttons & Action Bar Example
// ─────────────────────────────────────────────
class ButtonsExample extends StatefulWidget {
  const ButtonsExample({super.key});

  @override
  State<ButtonsExample> createState() => _ButtonsExampleState();
}

class _ButtonsExampleState extends State<ButtonsExample> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxButton & VasxSearchBar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action Bar (Reference Design)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VasxColors.borderLight),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    VasxSearchBar(
                      hintText: 'Search...',
                      width: 240,
                      onChanged: (q) => setState(() => _searchQuery = q),
                    ),
                    const SizedBox(width: 12),
                    VasxButton(
                      label: 'Filter',
                      icon: Icons.filter_list_rounded,
                      variant: VasxButtonVariant.secondary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filter pressed')),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    VasxButton(
                      label: 'Create Student',
                      icon: Icons.add_rounded,
                      variant: VasxButtonVariant.primary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Create Student pressed')),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    VasxButton(
                      label: 'Bulk PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      variant: VasxButtonVariant.outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bulk PDF pressed')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Search query: $_searchQuery', style: TextStyle(color: Colors.grey[600])),
            ],
            const SizedBox(height: 32),
            const Text(
              'Button Variants & Sizes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const VasxButton(label: 'Small', size: VasxButtonSize.small),
                const VasxButton(label: 'Medium', size: VasxButtonSize.medium),
                const VasxButton(label: 'Large', size: VasxButtonSize.large),
                const VasxButton(label: 'Loading', isLoading: true),
                VasxButton(
                  label: 'Disabled',
                  variant: VasxButtonVariant.outlined,
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Toggle Switch Example
// ─────────────────────────────────────────────
class ToggleExample extends StatefulWidget {
  const ToggleExample({super.key});

  @override
  State<ToggleExample> createState() => _ToggleExampleState();
}

class _ToggleExampleState extends State<ToggleExample> {
  bool _activeToggle = true;
  bool _inactiveToggle = false;
  bool _labeledToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxToggle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Toggle Switch States (Reference Design)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VasxColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Active State: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      VasxToggle(
                        value: _activeToggle,
                        onChanged: (val) => setState(() => _activeToggle = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Inactive State: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      VasxToggle(
                        value: _inactiveToggle,
                        onChanged: (val) => setState(() => _inactiveToggle = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  VasxToggle(
                    value: _labeledToggle,
                    label: 'Enable Automated Email Notifications',
                    onChanged: (val) => setState(() => _labeledToggle = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Checkbox Example
// ─────────────────────────────────────────────
class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _checked1 = true;
  bool _checked2 = false;
  bool _termsChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxCheckbox')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checkbox States (Reference Design)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VasxColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Checked State: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      VasxCheckbox(
                        value: _checked1,
                        onChanged: (val) => setState(() => _checked1 = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Unchecked State: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      VasxCheckbox(
                        value: _checked2,
                        onChanged: (val) => setState(() => _checked2 = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  VasxCheckbox(
                    value: _termsChecked,
                    label: 'I accept the Terms of Service and Privacy Policy',
                    onChanged: (val) => setState(() => _termsChecked = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CustomForm Example
// ─────────────────────────────────────────────
class CustomFormExample extends StatefulWidget {
  const CustomFormExample({super.key});

  @override
  State<CustomFormExample> createState() => _CustomFormExampleState();
}

class _CustomFormExampleState extends State<CustomFormExample> {
  final _hostController = TextEditingController(text: 'smtp.gmail.com');
  final _portController = TextEditingController(text: '587');
  final _usernameController =
      TextEditingController(text: 'admin@vasxui.com');
  final _passwordController = TextEditingController();
  final _fromNameController = TextEditingController(text: 'vasX Notification Portal');

  bool _isLoading = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fromNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxFormCard (Form)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: VasxFormCard(
              title: 'Email Credentials (SMTP)',
              subtitle: 'Configure email server for OTP delivery',
              headerIcon: Icons.email_outlined,
              badgeColor: const Color(0xFFEEF2FF),
              badgeIconColor: VasxColors.primary,
              isLoading: _isLoading,
              fields: [
                VasxFormFieldConfig(
                  label: 'SMTP Host',
                  hintText: 'e.g. smtp.gmail.com',
                  controller: _hostController,
                  prefixIcon: Icons.dns_outlined,
                ),
                VasxFormFieldConfig(
                  label: 'SMTP Port',
                  hintText: '587',
                  controller: _portController,
                  prefixIcon: Icons.tag_outlined,
                  keyboardType: TextInputType.number,
                ),
                VasxFormFieldConfig(
                  label: 'Username / Email',
                  hintText: 'user@domain.com',
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                VasxFormFieldConfig(
                  label: 'App Password',
                  hintText: 'Current: (leave blank to keep)',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),
                VasxFormFieldConfig(
                  label: 'From Name',
                  hintText: 'ID Card Portal',
                  controller: _fromNameController,
                  prefixIcon: Icons.badge_outlined,
                ),
              ],
              submitButtonLabel: 'Save Credentials',
              onSubmit: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credentials saved successfully!')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AI Assistant SearchBar Example
// ─────────────────────────────────────────────
class AiSearchBarExample extends StatefulWidget {
  const AiSearchBarExample({super.key});

  @override
  State<AiSearchBarExample> createState() => _AiSearchBarExampleState();
}

class _AiSearchBarExampleState extends State<AiSearchBarExample> {
  String _submittedQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxAiSearchBar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: Column(
            children: [
              VasxAiSearchBar(
                title: 'What are you looking for today?',
                subtitle: 'Ask anything about your students & staff',
                hintText: 'Search settings, students, staff...',
                attachmentItems: [
                  VasxAiAttachmentItem(
                    label: 'Add Photos',
                    icon: Icons.add_a_photo_outlined,
                    onTap: () {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add Photos tapped')),
                      );
                    },
                  ),
                  VasxAiAttachmentItem(
                    label: 'Students',
                    icon: Icons.people_outline_rounded,
                    onTap: () {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Students category tapped')),
                      );
                    },
                  ),
                  VasxAiAttachmentItem(
                    label: 'Staffs',
                    icon: Icons.badge_outlined,
                    onTap: () {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Staffs category tapped')),
                      );
                    },
                  ),
                ],
                onSubmitted: (query) {
                  setState(() => _submittedQuery = query);
                },
              ),
              if (_submittedQuery.isNotEmpty) ...[
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VasxColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: VasxColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Searching for: "$_submittedQuery"',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: VasxColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Payment Confirmation Example
// ─────────────────────────────────────────────
class PaymentConfirmationExample extends StatefulWidget {
  const PaymentConfirmationExample({super.key});

  @override
  State<PaymentConfirmationExample> createState() =>
      _PaymentConfirmationExampleState();
}

class _PaymentConfirmationExampleState
    extends State<PaymentConfirmationExample> {
  double? _lastPaidAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxPaymentConfirmationDialog')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VasxColors.borderLight),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_cart_checkout_rounded,
                        size: 48, color: VasxColors.primary),
                    const SizedBox(height: 12),
                    const Text(
                      'Supermarket Billing Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: VasxColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap below to trigger the payment confirmation dialog.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    VasxButton(
                      label: 'Open Payment Dialog',
                      icon: Icons.receipt_long_rounded,
                      onPressed: () async {
                        final paid = await showVasxPaymentConfirmationDialog(
                          context: context,
                          title: 'Supermarket Billing Details',
                          description: 'FreshMart Checkout (5 items)',
                          totalAmount: 2490.00,
                          alreadyPaidAmount: 490.00,
                          currencySymbol: '₹',
                          breakdownItems: const [
                            VasxPaymentConfirmationItem(
                              label: 'Fresh Organic Milk 2L',
                              amount: 180.00,
                            ),
                            VasxPaymentConfirmationItem(
                              label: 'Whole Wheat Bread',
                              amount: 60.00,
                            ),
                            VasxPaymentConfirmationItem(
                              label: 'Extra Virgin Olive Oil 1L',
                              amount: 850.00,
                            ),
                            VasxPaymentConfirmationItem(
                              label: 'Dark Chocolate Bar 100g',
                              amount: 200.00,
                            ),
                            VasxPaymentConfirmationItem(
                              label: 'Organic Wildflower Honey 500g',
                              amount: 700.00,
                            ),
                          ],
                        );
                        if (paid != null) {
                          setState(() => _lastPaidAmount = paid);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Payment of ₹$paid confirmed successfully!'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (_lastPaidAmount != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF16A34A), size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Last Payment Received: ₹${_lastPaidAmount!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Alert Banners Example
// ─────────────────────────────────────────────
class AlertExample extends StatefulWidget {
  const AlertExample({super.key});

  @override
  State<AlertExample> createState() => _AlertExampleState();
}

class _AlertExampleState extends State<AlertExample> {
  bool _showGreenAlert = true;
  bool _showYellowAlert = true;
  bool _showRedAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      appBar: AppBar(title: const Text('VasxAlert & Animated Toast')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Top-Right Alert Toasts (2s Auto-Hide)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Click any button below to trigger a smooth top-right animated alert toast that auto-hides after 2 seconds.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                VasxButton(
                  label: 'Success Toast (Green)',
                  icon: Icons.check_circle_rounded,
                  variant: VasxButtonVariant.primary,
                  primaryColor: const Color(0xFF15803D),
                  onPressed: () {
                    showVasxAlertToast(
                      context: context,
                      title: 'Logout Successful',
                      message: 'See you soon!',
                      type: VasxAlertType.success,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                VasxButton(
                  label: 'Warning Toast (Yellow)',
                  icon: Icons.warning_amber_rounded,
                  variant: VasxButtonVariant.primary,
                  primaryColor: const Color(0xFFD97706),
                  onPressed: () {
                    showVasxAlertToast(
                      context: context,
                      title: 'Storage Warning',
                      message: 'Cloud storage at 85% capacity.',
                      type: VasxAlertType.warning,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                VasxButton(
                  label: 'Error Toast (Red)',
                  icon: Icons.error_outline_rounded,
                  variant: VasxButtonVariant.primary,
                  primaryColor: const Color(0xFFDC2626),
                  onPressed: () {
                    showVasxAlertToast(
                      context: context,
                      title: 'Database Connection Failed',
                      message: 'Unable to reach primary server.',
                      type: VasxAlertType.error,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 36),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Solid Inline Alert Banners (Reference Design)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_showGreenAlert) ...[
              VasxAlert(
                title: 'Logout Successful',
                message: 'See you soon!',
                type: VasxAlertType.success,
                variant: VasxAlertVariant.solid,
                onDismiss: () => setState(() => _showGreenAlert = false),
              ),
              const SizedBox(height: 16),
            ],
            if (_showYellowAlert) ...[
              VasxAlert(
                title: 'Storage Warning',
                message: 'Your allocated cloud storage has reached 85% capacity.',
                type: VasxAlertType.warning,
                variant: VasxAlertVariant.solid,
                onDismiss: () => setState(() => _showYellowAlert = false),
              ),
              const SizedBox(height: 16),
            ],
            if (_showRedAlert) ...[
              VasxAlert(
                title: 'Database Connection Failed',
                message: 'Unable to synchronize with primary replica. Retrying in 10s.',
                type: VasxAlertType.error,
                variant: VasxAlertVariant.solid,
                onDismiss: () => setState(() => _showRedAlert = false),
              ),
              const SizedBox(height: 16),
            ],
            if (!_showGreenAlert || !_showYellowAlert || !_showRedAlert) ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Restore Dismissed Banners'),
                onPressed: () {
                  setState(() {
                    _showGreenAlert = true;
                    _showYellowAlert = true;
                    _showRedAlert = true;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 24),
            const Text(
              'Soft Outline Alert Banners',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const VasxAlert(
              title: 'Success: Payment Verified',
              message: 'Transaction #TXN-90218 completed.',
              type: VasxAlertType.success,
              variant: VasxAlertVariant.soft,
            ),
            const SizedBox(height: 12),
            const VasxAlert(
              title: 'Caution: Unsaved Modifications',
              message: 'You have pending changes that have not been published.',
              type: VasxAlertType.warning,
              variant: VasxAlertVariant.soft,
            ),
            const SizedBox(height: 12),
            const VasxAlert(
              title: 'Error: Authentication Timeout',
              message: 'Your session has expired. Please log in again.',
              type: VasxAlertType.error,
              variant: VasxAlertVariant.soft,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Side Menu (E-Commerce) Example
// ─────────────────────────────────────────────
class SideMenuExample extends StatefulWidget {
  const SideMenuExample({super.key});

  @override
  State<SideMenuExample> createState() => _SideMenuExampleState();
}

class _SideMenuExampleState extends State<SideMenuExample> {
  String _selectedId = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VasxSideMenu (Hover to Expand)')),
      body: Row(
        children: [
          VasxSideMenu(
            brandName: 'Test Shop',
            selectedId: _selectedId,
            expandOnHover: true,
            onItemSelected: (id) {
              setState(() => _selectedId = id);
              if (id == 'logout') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout clicked')),
                );
              }
            },
            items: const [
              VasxSideMenuItem(
                id: 'dashboard',
                label: 'Dashboard',
                icon: Icons.grid_view_rounded,
              ),
              VasxSideMenuItem(
                id: 'orders',
                label: 'My Orders',
                icon: Icons.shopping_bag_outlined,
                badgeText: '5',
              ),
              VasxSideMenuItem(
                id: 'products',
                label: 'Products & Catalog',
                icon: Icons.inventory_2_outlined,
                subItems: [
                  VasxSideMenuItem(
                    id: 'all_products',
                    label: 'All Products',
                    icon: Icons.list_alt_rounded,
                  ),
                  VasxSideMenuItem(
                    id: 'add_product',
                    label: 'Add Product',
                    icon: Icons.add_box_outlined,
                  ),
                  VasxSideMenuItem(
                    id: 'categories',
                    label: 'Categories',
                    icon: Icons.category_outlined,
                  ),
                ],
              ),
              VasxSideMenuItem(
                id: 'customers',
                label: 'Customers',
                icon: Icons.people_outline_rounded,
              ),
              VasxSideMenuItem(
                id: 'analytics',
                label: 'Sales & Analytics',
                icon: Icons.insights_rounded,
              ),
              VasxSideMenuItem(
                id: 'coupons',
                label: 'Discounts & Offers',
                icon: Icons.local_offer_outlined,
              ),
              VasxSideMenuItem(
                id: 'bulk_upload',
                label: 'Bulk Upload',
                icon: Icons.upload_file_outlined,
              ),
              VasxSideMenuItem(
                id: 'billing',
                label: 'Payments & Billing',
                icon: Icons.account_balance_wallet_outlined,
              ),
            ],
            bottomItems: const [
              VasxSideMenuItem(
                id: 'settings',
                label: 'Store Settings',
                icon: Icons.settings_outlined,
              ),
              VasxSideMenuItem(
                id: 'logout',
                label: 'Logout',
                icon: Icons.logout_rounded,
                isDestructive: true,
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: VasxColors.surface,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Section: ${_selectedId.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: VasxColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hover your mouse over the left sidebar to experience the smooth expansion from compact (72px) to full (250px) width mode!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mobile Bottom NavBar Example
// ─────────────────────────────────────────────
class BottomNavBarExample extends StatefulWidget {
  const BottomNavBarExample({super.key});

  @override
  State<BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  String _selectedTab = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(title: const Text('VasxMobileBottomNavBar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.phone_android_rounded, size: 48, color: VasxColors.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Active Tab: ${_selectedTab.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: VasxColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap any icon in the floating bottom navigation bar below.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: VasxMobileBottomNavBar(
        selectedId: _selectedTab,
        onItemSelected: (id) => setState(() => _selectedTab = id),
        items: const [
          VasxBottomNavItem(
            id: 'dashboard',
            label: 'Dashboard',
            icon: Icons.grid_view_rounded,
          ),
          VasxBottomNavItem(
            id: 'orders',
            label: 'My Orders',
            icon: Icons.shopping_bag_outlined,
            badgeText: '3',
          ),
          VasxBottomNavItem(
            id: 'students',
            label: 'Customers',
            icon: Icons.people_outline_rounded,
          ),
          VasxBottomNavItem(
            id: 'staffs',
            label: 'Staffs',
            icon: Icons.groups_outlined,
          ),
          VasxBottomNavItem(
            id: 'upload',
            label: 'Bulk Upload',
            icon: Icons.upload_file_outlined,
          ),
          VasxBottomNavItem(
            id: 'settings',
            label: 'Settings',
            icon: Icons.manage_accounts_outlined,
          ),
        ],
      ),
    );
  }
}
