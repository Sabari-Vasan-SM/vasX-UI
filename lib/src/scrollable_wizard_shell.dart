import 'package:flutter/material.dart';
import 'vasx_colors.dart';
import 'vertical_wizard_shell.dart';

/// A responsive wizard layout that shows **all sections at once** in a
/// single scrollable page, with a sidebar (or top bar on mobile) acting
/// as an in-page navigation anchor.
///
/// **Desktop (≥ 768 px):** Fixed left sidebar with clickable step tiles.
/// The active section is detected from scroll position and highlighted.
/// **Mobile (< 600 px):** Horizontal scrollable step indicator pinned to
/// the top.
///
/// Unlike [VerticalWizardShell] which shows one step at a time, this shell
/// renders every [sectionContents] widget simultaneously — ideal for long
/// forms where users benefit from seeing the full context.
///
/// Example:
/// ```dart
/// ScrollableWizardShell(
///   steps: kStudentWizardSteps,
///   title: 'Create Student',
///   sectionContents: [
///     CoreDetailsForm(),
///     BasicDetailsForm(),
///     AddressForm(),
///   ],
///   onSave: _submitForm,
///   onCancel: () => Navigator.pop(context),
/// )
/// ```
class ScrollableWizardShell extends StatefulWidget {
  /// Step configs (icon, label, subtitle) — one per [sectionContents] entry.
  final List<WizardStepConfig> steps;

  /// Title shown at the top of the sidebar / mobile bar.
  final String title;

  /// Widgets for each section's form content. Length must equal [steps].
  final List<Widget> sectionContents;

  /// Called when the Save / Finish button is pressed.
  final VoidCallback? onSave;

  /// Label for the primary action button. Defaults to `'Save'`.
  final String saveLabel;

  /// Called when the Cancel button is pressed.
  final VoidCallback? onCancel;

  /// When `true`, the Save button shows a [CircularProgressIndicator].
  final bool saving;

  /// Called whenever a form field within any section is interacted with.
  /// Useful for marking the form as "dirty".
  final VoidCallback? onFormChanged;

  /// Primary brand color for active highlights and buttons.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [ScrollableWizardShell].
  const ScrollableWizardShell({
    super.key,
    required this.steps,
    required this.title,
    required this.sectionContents,
    this.onSave,
    this.saveLabel = 'Save',
    this.onCancel,
    this.saving = false,
    this.onFormChanged,
    this.primaryColor,
  });

  @override
  State<ScrollableWizardShell> createState() =>
      _ScrollableWizardShellState();
}

class _ScrollableWizardShellState extends State<ScrollableWizardShell> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _sectionKeys;
  int _activeSection = 0;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _sectionKeys =
        List.generate(widget.steps.length, (_) => GlobalKey());
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ScrollableWizardShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.steps.length != oldWidget.steps.length) {
      _sectionKeys =
          List.generate(widget.steps.length, (_) => GlobalKey());
      if (_activeSection >= widget.steps.length) {
        _activeSection = widget.steps.length - 1;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ───────────────────── Scroll tracking ─────────────────

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10) {
      final last = _sectionKeys.length - 1;
      if (_activeSection != last) setState(() => _activeSection = last);
      return;
    }

    const threshold = 200.0;
    int active = 0;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy <= threshold) active = i;
    }
    if (_activeSection != active) setState(() => _activeSection = active);
  }

  void _scrollToSection(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  // ───────────────────── Build ─────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) return _buildMobileLayout(context);
          return _buildDesktopLayout(context, constraints.maxWidth < 768);
        },
      ),
    );
  }

  // ───────────────────── Desktop / Tablet ─────────────────

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet ? 220 : 260,
          child: Material(
            color: Colors.white,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SingleChildScrollView(child: _buildSidebar(context)),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBreadcrumbs(context),
                const SizedBox(height: 16),
                for (int i = 0; i < widget.sectionContents.length; i++) ...[
                  _buildSectionCard(i),
                  if (i < widget.sectionContents.length - 1)
                    const SizedBox(height: 24),
                ],
                const SizedBox(height: 32),
                _buildSaveBar(isMobile: false),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────── Mobile ─────────────────

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildMobileStepBar(context),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < widget.sectionContents.length; i++) ...[
                  _buildSectionCard(i),
                  if (i < widget.sectionContents.length - 1)
                    const SizedBox(height: 16),
                ],
                const SizedBox(height: 24),
                _buildSaveBar(isMobile: true),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────── Sidebar ─────────────────

  Widget _buildSidebar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28, left: 4),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: VasxColors.textPrimary,
              ),
            ),
          ),
          ...List.generate(widget.steps.length, (i) {
            return _buildSidebarItem(
              widget.steps[i],
              i,
              i == _activeSection,
              i == widget.steps.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      WizardStepConfig step, int index, bool isActive, bool isLast) {
    final primary = _primary;
    final iconBg = isActive ? primary : VasxColors.surface;
    final iconFg = isActive ? Colors.white : VasxColors.textHint;
    final labelColor = isActive ? primary : VasxColors.textPrimary;
    final labelWeight = isActive ? FontWeight.w600 : FontWeight.w500;

    return InkWell(
      onTap: () => _scrollToSection(index),
      borderRadius: BorderRadius.circular(8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(step.icon, size: 20, color: iconFg),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: VasxColors.borderLight,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: labelWeight,
                        color: labelColor,
                      ),
                    ),
                    if (step.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────── Mobile Step Bar ─────────────────

  Widget _buildMobileStepBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: VasxColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.steps.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final isActive = i == _activeSection;
                return GestureDetector(
                  onTap: () => _scrollToSection(i),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isActive ? _primary : VasxColors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.steps[i].icon,
                          size: 18,
                          color: isActive ? Colors.white : VasxColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.steps[i].label.split(' ').first,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? _primary : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────── Section Card ─────────────────

  Widget _wrapWithChangeDetector(Widget child) {
    if (widget.onFormChanged == null) return child;
    return Listener(
      onPointerUp: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onFormChanged?.call();
        });
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  Widget _buildSectionCard(int index) {
    final step = widget.steps[index];
    final isActive = index == _activeSection;
    final primary = _primary;

    return Container(
      key: _sectionKeys[index],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive
              ? primary.withValues(alpha: 0.3)
              : VasxColors.borderLight,
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? primary : VasxColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  step.icon,
                  size: 18,
                  color: isActive ? Colors.white : VasxColors.textHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isActive ? primary : VasxColors.textPrimary,
                      ),
                    ),
                    if (step.subtitle.isNotEmpty)
                      Text(
                        step.subtitle,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: VasxColors.borderLight),
          const SizedBox(height: 20),
          _wrapWithChangeDetector(widget.sectionContents[index]),
        ],
      ),
    );
  }

  // ───────────────────── Breadcrumbs ─────────────────

  Widget _buildBreadcrumbs(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Home',
            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        Text(' / ',
            style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        Text(
          widget.title,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _primary),
        ),
      ],
    );
  }

  // ───────────────────── Save Bar ─────────────────

  Widget _buildSaveBar({required bool isMobile}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.onCancel != null)
          OutlinedButton.icon(
            onPressed: widget.onCancel,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 20,
                vertical: isMobile ? 10 : 14,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: widget.saving ? null : widget.onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 28,
              vertical: isMobile ? 10 : 14,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: widget.saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.saveLabel),
                    const SizedBox(width: 6),
                    const Icon(Icons.check_rounded, size: 18),
                  ],
                ),
        ),
      ],
    );
  }
}
