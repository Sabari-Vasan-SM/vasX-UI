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
