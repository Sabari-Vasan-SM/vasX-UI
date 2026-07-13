import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Describes one step in a [VerticalWizardShell] or [ScrollableWizardShell].
///
/// Example:
/// ```dart
/// const WizardStepConfig(
///   icon: Icons.person_outline_rounded,
///   label: 'Personal Details',
///   mobileLabel: 'Personal',
///   subtitle: 'Name & contact info',
/// )
/// ```
class WizardStepConfig {
  /// Icon shown in the stepper circle / tile.
  final IconData icon;

  /// Full label used in the desktop sidebar.
  final String label;

  /// Abbreviated label used in the compact mobile stepper.
  final String mobileLabel;

  /// Optional subtitle shown below [label] in the sidebar.
  final String subtitle;

  /// Creates a [WizardStepConfig].
  const WizardStepConfig({
    required this.icon,
    required this.label,
    required this.mobileLabel,
    this.subtitle = '',
  });
}

/// Internal state of a step in [VerticalWizardShell].
enum StepState {
  /// The step has been completed (shows a checkmark icon).
  completed,

  /// The currently active step (highlighted in [primaryColor]).
  active,

  /// A future step not yet reached (muted style).
  upcoming,
}

/// A responsive multi-step wizard layout with a vertical left stepper.
///
/// **Desktop (≥ 768 px wide):**
/// - Fixed 260 px left panel with a vertical stepper showing completed ✓,
///   active (filled), and upcoming (muted) steps connected by animated lines.
/// - Scrollable right panel with breadcrumbs, step title, form card, and
///   action buttons.
///
/// **Mobile (< 768 px):**
/// - Compact horizontal progress-bar stepper pinned to the top.
/// - Scrollable content below with the same form card and action buttons.
///
/// The wizard does **not** manage navigation internally — you control which
/// [currentStep] to show and handle [onNext] / [onBack] yourself.
///
/// Example:
/// ```dart
/// VerticalWizardShell(
///   steps: kStudentWizardSteps,
///   currentStep: _step,
///   title: 'Create Student',
///   formContent: _buildStepForm(),
///   onBack: _step > 0 ? _prevStep : null,
///   onNext: _nextStep,
///   nextLabel: _step == steps.length - 1 ? 'Finish' : 'Next',
/// )
/// ```
class VerticalWizardShell extends StatelessWidget {
  /// All steps for this wizard.
  final List<WizardStepConfig> steps;

  /// Zero-based index of the currently active step.
  final int currentStep;

  /// Title displayed at the top of the left stepper panel and in breadcrumbs.
  final String title;

  /// Optional description shown below the step title on the right panel.
  final String? stepDescription;

  /// The form widget rendered for the current step.
  final Widget formContent;

  /// Called when the Back button is pressed. `null` hides the Back button.
  final VoidCallback? onBack;

  /// Called when the Next / Finish button is pressed.
  final VoidCallback? onNext;

  /// Label for the forward action button. Defaults to `'Next'`.
  final String nextLabel;

  /// When `true`, only the primary action button is shown (no Back button).
  /// Useful for the very first page of a wizard flow.
  final bool isFirstPage;

  /// Called when the Cancel button is pressed. Shown only when not `null`.
  final VoidCallback? onCancel;

  /// Optional widget rendered below the form card (e.g. terms checkbox).
  final Widget? bottomExtra;

  /// Primary brand color for active steps and buttons.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [VerticalWizardShell].
  const VerticalWizardShell({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.title,
    this.stepDescription,
    required this.formContent,
    this.onBack,
    this.onNext,
    this.nextLabel = 'Next',
    this.isFirstPage = false,
    this.onCancel,
    this.bottomExtra,
    this.primaryColor,
  });

  StepState _stepState(int index) {
    if (index < currentStep) return StepState.completed;
    if (index == currentStep) return StepState.active;
    return StepState.upcoming;
  }

  Color get _primary => primaryColor ?? VasxColors.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VasxColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          if (isMobile) return _buildMobileLayout(context);
          return _buildDesktopLayout(context);
        },
      ),
    );
  }

  // ─────────────────────── DESKTOP ───────────────────────

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left stepper panel
        Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: Colors.grey.shade200)),
          ),
          child: _buildVerticalStepper(context),
        ),

        // Right content panel
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBreadcrumbsWithCancel(context),
                const SizedBox(height: 8),

                Text(
                  'Step ${currentStep + 1}/${steps.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _primary,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  steps[currentStep].label,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: VasxColors.textPrimary,
                  ),
                ),

                if (stepDescription != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    stepDescription!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: VasxColors.borderLight),
                  ),
                  child: formContent,
                ),

                if (bottomExtra != null) ...[
                  const SizedBox(height: 16),
                  bottomExtra!,
                ],

                const SizedBox(height: 24),

                _buildActionButtons(context, isMobile: false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────── MOBILE ───────────────────────

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildMobileStepper(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${currentStep + 1}/${steps.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _primary,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  steps[currentStep].label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: VasxColors.textPrimary,
                  ),
                ),

                if (stepDescription != null) ...[
                  const SizedBox(height: 4),
                  Text(stepDescription!,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: VasxColors.borderLight),
                  ),
                  child: formContent,
                ),

                if (bottomExtra != null) ...[
                  const SizedBox(height: 12),
                  bottomExtra!,
                ],

                const SizedBox(height: 16),
                _buildActionButtons(context, isMobile: true),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────── COMPONENTS ───────────────────────

  Widget _buildVerticalStepper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28, left: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: VasxColors.textPrimary,
              ),
            ),
          ),
          ...List.generate(steps.length, (i) {
            final state = _stepState(i);
            final isLast = i == steps.length - 1;
            return _buildVerticalStepItem(steps[i], state, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildVerticalStepItem(
      WizardStepConfig step, StepState state, bool isLast) {
    final primary = _primary;

    Color iconBg;
    Color iconFg;
    Color lineColor;
    Color labelColor;
    FontWeight labelWeight;

    switch (state) {
      case StepState.completed:
        iconBg = primary.withValues(alpha: 0.12);
        iconFg = primary;
        lineColor = primary;
        labelColor = VasxColors.textPrimary;
        labelWeight = FontWeight.w500;
      case StepState.active:
        iconBg = primary;
        iconFg = Colors.white;
        lineColor = VasxColors.borderLight;
        labelColor = primary;
        labelWeight = FontWeight.w600;
      case StepState.upcoming:
        iconBg = VasxColors.surface;
        iconFg = VasxColors.textHint;
        lineColor = VasxColors.borderLight;
        labelColor = VasxColors.textHint;
        labelWeight = FontWeight.w400;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: state == StepState.completed
                      ? Icon(Icons.check_rounded, size: 20, color: iconFg)
                      : Icon(step.icon, size: 20, color: iconFg),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: lineColor,
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
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStepper(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: VasxColors.textPrimary,
                ),
              ),
              if (onCancel != null)
                OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.arrow_back_rounded, size: 14),
                  label:
                      const Text('Cancel', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(steps.length, (i) {
              final state = _stepState(i);
              final primary = _primary;
              final isActive = state == StepState.active;
              final isCompleted = state == StepState.completed;

              return Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: i < steps.length - 1 ? 4 : 0),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive
                              ? primary
                              : VasxColors.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isActive
                              ? primary
                              : isCompleted
                                  ? primary.withValues(alpha: 0.12)
                                  : VasxColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isCompleted
                            ? Icon(Icons.check_rounded,
                                size: 14, color: primary)
                            : Icon(steps[i].icon,
                                size: 14,
                                color: isActive
                                    ? Colors.white
                                    : VasxColors.textHint),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbsWithCancel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Dashboard',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            Text(' / ',
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
            Text(
              title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _primary),
            ),
          ],
        ),
        if (onCancel != null)
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context,
      {required bool isMobile}) {
    if (isFirstPage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 10 : 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(nextLabel),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onBack != null)
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 20,
                  vertical: isMobile ? 10 : 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 28,
                vertical: isMobile ? 10 : 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(nextLabel),
              if (nextLabel != 'Finish') ...[
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
