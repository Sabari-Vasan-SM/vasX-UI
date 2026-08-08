import 'package:flutter_test/flutter_test.dart';
import 'package:vasx_ui/vasx_ui.dart';
import 'package:flutter/material.dart';

void main() {
  // ───── VasxColors ─────
  group('VasxColors', () {
    test('primary color has correct hex value', () {
      expect(VasxColors.primary.toARGB32(), equals(const Color(0xFF2D4FCB).toARGB32()));
    });

    test('textPrimary is near-black', () {
      expect(VasxColors.textPrimary.toARGB32(),
          equals(const Color(0xFF111827).toARGB32()));
    });

    test('borderLight is a very light grey', () {
      expect(VasxColors.borderLight.toARGB32(),
          equals(const Color(0xFFE5E7EB).toARGB32()));
    });
  });

  // ───── AppPopupMenuItem ─────
  group('AppPopupMenuItem', () {
    test('default isDestructive is false', () {
      const item = AppPopupMenuItem(label: 'Edit', onTap: _noop);
      expect(item.isDestructive, isFalse);
    });

    test('isDestructive flag is set correctly', () {
      const item =
          AppPopupMenuItem(label: 'Delete', onTap: _noop, isDestructive: true);
      expect(item.isDestructive, isTrue);
    });
  });

  // ───── CustomTableColumn ─────
  group('CustomTableColumn', () {
    test('default flex is 1', () {
      const col = CustomTableColumn(label: 'Name');
      expect(col.flex, equals(1));
    });

    test('default alignment is centerLeft', () {
      const col = CustomTableColumn(label: 'Name');
      expect(col.alignment, equals(Alignment.centerLeft));
    });

    test('custom flex is stored', () {
      const col = CustomTableColumn(label: 'Name', flex: 3);
      expect(col.flex, equals(3));
    });
  });

  // ───── WizardStepConfig ─────
  group('WizardStepConfig', () {
    test('default subtitle is empty string', () {
      const step = WizardStepConfig(
        icon: Icons.person,
        label: 'Step 1',
        mobileLabel: 'S1',
      );
      expect(step.subtitle, equals(''));
    });

    test('subtitle is stored correctly', () {
      const step = WizardStepConfig(
        icon: Icons.person,
        label: 'Step 1',
        mobileLabel: 'S1',
        subtitle: 'Enter name',
      );
      expect(step.subtitle, equals('Enter name'));
    });
  });

  // ───── Widget smoke tests ─────
  testWidgets('AppPopupMenu renders items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPopupMenu(
            onClose: () {},
            items: const [
              AppPopupMenuItem(label: 'Edit', onTap: _noop),
              AppPopupMenuItem(label: 'Delete', onTap: _noop, isDestructive: true),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('CustomTable renders header and rows', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTable(
            columns: const [
              CustomTableColumn(label: 'Name'),
              CustomTableColumn(label: 'Email'),
            ],
            itemCount: 2,
            minWidth: 200,
            rowBuilder: (context, index) => [
              Text('Name $index'),
              Text('email$index@test.com'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Name 0'), findsOneWidget);
    expect(find.text('Name 1'), findsOneWidget);
  });

  testWidgets('SearchableDropdown renders label and hint', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchableDropdown(
            label: 'Country',
            value: null,
            hint: 'Select country',
            items: const ['India', 'USA'],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Select country'), findsOneWidget);
  });

  testWidgets('DropdownDatePicker renders without label', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DropdownDatePicker(controller: controller),
        ),
      ),
    );
    expect(find.text('Year'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('CreatableDropdown renders trigger field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreatableDropdown(
            value: 'Class 10',
            items: const ['Class 9', 'Class 10'],
            onChanged: (_) {},
            onAddItem: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Class 10'), findsOneWidget);
  });

  testWidgets('MultiSelectSearchableDropdown renders hint and label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiSelectSearchableDropdown(
            label: 'Subjects',
            values: const [],
            hint: 'Select subjects',
            items: const ['Math', 'Science'],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Subjects'), findsOneWidget);
    expect(find.text('Select subjects'), findsOneWidget);
  });

  testWidgets('VerticalWizardShell renders step titles and form', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    const steps = [
      WizardStepConfig(icon: Icons.person, label: 'Personal', mobileLabel: 'P'),
      WizardStepConfig(icon: Icons.home, label: 'Address', mobileLabel: 'A'),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: VerticalWizardShell(
          steps: steps,
          currentStep: 0,
          title: 'Student Registration',
          formContent: Text('Form content step 1'),
        ),
      ),
    );

    expect(find.text('Student Registration'), findsNWidgets(2)); // Sidebar title + Breadcrumbs
    expect(find.text('Form content step 1'), findsOneWidget);
    expect(find.text('Personal'), findsNWidgets(2)); // Stepper + Header
  });

  testWidgets('ScrollableWizardShell renders sections simultaneously', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    const steps = [
      WizardStepConfig(icon: Icons.person, label: 'Basic Info', mobileLabel: 'Basic'),
      WizardStepConfig(icon: Icons.contact_mail, label: 'Contact Details', mobileLabel: 'Contact'),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: ScrollableWizardShell(
          steps: steps,
          title: 'Wizard Scroll Shell',
          sectionContents: [
            Text('Section 1 Content'),
            Text('Section 2 Content'),
          ],
        ),
      ),
    );

    expect(find.text('Wizard Scroll Shell'), findsNWidgets(2)); // Sidebar title + Breadcrumbs
    expect(find.text('Section 1 Content'), findsOneWidget);
    expect(find.text('Section 2 Content'), findsOneWidget);
  });

  testWidgets('CustomDateRangePickerDialog renders FROM and TO calendars', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: CustomDateRangePickerDialog(
          initialDateRange: DateTimeRange(
            start: DateTime(2026, 8, 1),
            end: DateTime(2026, 8, 10),
          ),
        ),
      ),
    );

    expect(find.text('FROM'), findsOneWidget);
    expect(find.text('TO'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('CrmCalendar renders calendar grid and event items', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final events = [
      CrmCalendarEvent(
        id: '1',
        name: 'John Doe',
        date: DateTime.now(),
        stage: 'New Lead',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CrmCalendar(events: events),
        ),
      ),
    );

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('John Doe'), findsWidgets);
  });

  testWidgets('CrmStatsDashboard renders header, top cards, and charts', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CrmStatsDashboard(
            totalLeads: 100,
            archivedLeadsCount: 15,
            leadsByStage: const {'New Lead': 40, 'Contacted': 60},
            trendData: const [
              CrmTrendData(date: '2026-08-01', value: 10),
              CrmTrendData(date: '2026-08-02', value: 20),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Dashboard Stats'), findsOneWidget);
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Admission Funnel'), findsOneWidget);
    expect(find.text('Archived Leads'), findsOneWidget);
  });

  testWidgets('VasxFormCard renders header, fields, and submit button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VasxFormCard(
            title: 'Server Settings',
            subtitle: 'Configure host and port',
            headerIcon: Icons.dns,
            fields: const [
              VasxFormFieldConfig(
                label: 'Server Host',
                hintText: '127.0.0.1',
              ),
            ],
            submitButtonLabel: 'Save Server Settings',
            onSubmit: () {},
          ),
        ),
      ),
    );

    expect(find.text('Server Settings'), findsOneWidget);
    expect(find.text('Configure host and port'), findsOneWidget);
    expect(find.text('Server Host'), findsOneWidget);
    expect(find.text('127.0.0.1'), findsOneWidget);
    expect(find.text('Save Server Settings'), findsOneWidget);
  });

  // ───── CrmStageColors ─────
  group('CrmStageColors', () {
    test('resolves colors for valid stages', () {
      final cols = CrmStageColors.forStage('New Lead');
      expect(cols['color'], isNotNull);
      expect(cols['bg'], isNotNull);
      expect(cols['textColor'], isNotNull);
    });

    test('falls back to grey for unknown stage', () {
      final cols = CrmStageColors.forStage('Unknown Stage');
      expect(cols['color'], equals(Colors.grey));
    });
  });
}

void _noop() {}
