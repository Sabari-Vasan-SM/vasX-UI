import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Describes a single text input field inside a [VasxFormCard].
///
/// Example:
/// ```dart
/// VasxFormFieldConfig(
///   label: 'Host URL',
///   hintText: 'db.example.com',
///   prefixIcon: Icons.dns_outlined,
///   controller: _hostController,
/// )
/// ```
class VasxFormFieldConfig {
  /// Label displayed above the input field.
  final String label;

  /// Placeholder hint text shown when the input is empty.
  final String? hintText;

  /// Controller managing the text value of this field.
  final TextEditingController? controller;

  /// Icon displayed at the left side inside the input box.
  final IconData? prefixIcon;

  /// Icon displayed at the right side inside the input box.
  final IconData? suffixIcon;

  /// Callback when [suffixIcon] is tapped.
  final VoidCallback? onSuffixIconTap;

  /// Whether text input is obscured (e.g. passwords). Defaults to `false`.
  final bool obscureText;

  /// Keyboard type for text input (e.g. [TextInputType.emailAddress]).
  final TextInputType? keyboardType;

  /// Optional validator callback.
  final FormFieldValidator<String>? validator;

  /// Callback invoked whenever text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the field is enabled. Defaults to `true`.
  final bool enabled;

  /// Creates a [VasxFormFieldConfig].
  const VasxFormFieldConfig({
    required this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });
}

/// A sleek, production-ready form card widget matching modern SaaS admin design systems.
///
/// Includes a badge icon header, optional description, soft rounded input fields
/// with prefix/suffix icons, and a full-width primary submit button.
///
/// Example:
/// ```dart
/// VasxFormCard(
///   title: 'Database Settings',
///   subtitle: 'Configure primary SQL connection parameters',
///   headerIcon: Icons.storage_outlined,
///   fields: [
///     VasxFormFieldConfig(
///       label: 'Database Host',
///       hintText: 'db.internal.net',
///       prefixIcon: Icons.dns_outlined,
///     ),
///     VasxFormFieldConfig(
///       label: 'Port Number',
///       hintText: '5432',
///       prefixIcon: Icons.numbers_outlined,
///     ),
///   ],
///   submitButtonLabel: 'Save Database Settings',
///   onSubmit: () => _saveSettings(),
/// )
/// ```
class VasxFormCard extends StatefulWidget {
  /// Title shown at the top of the card.
  final String title;

  /// Optional description subtitle displayed below [title].
  final String? subtitle;

  /// Icon displayed inside the header's badge badge container.
  final IconData? headerIcon;

  /// Badge background color. Defaults to [VasxColors.primarySurface].
  final Color? badgeColor;

  /// Badge icon color. Defaults to [VasxColors.primary].
  final Color? badgeIconColor;

  /// List of field configurations to render inside the form.
  final List<VasxFormFieldConfig> fields;

  /// Primary action button label rendered below the form fields.
  final String? submitButtonLabel;

  /// Callback invoked when the primary action button is pressed.
  final VoidCallback? onSubmit;

  /// Whether the submit button is in a loading state. Defaults to `false`.
  final bool isLoading;

  /// Optional custom footer widget below the form.
  final Widget? customFooter;

  /// Primary brand color. Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Optional [GlobalKey<FormState>] for field validation.
  final GlobalKey<FormState>? formKey;

  /// Creates a [VasxFormCard].
  const VasxFormCard({
    super.key,
    required this.title,
    this.subtitle,
    this.headerIcon,
    this.badgeColor,
    this.badgeIconColor,
    required this.fields,
    this.submitButtonLabel,
    this.onSubmit,
    this.isLoading = false,
    this.customFooter,
    this.primaryColor,
    this.formKey,
  });

  @override
  State<VasxFormCard> createState() => _VasxFormCardState();
}

class _VasxFormCardState extends State<VasxFormCard> {
  final Map<int, bool> _obscureStateMap = {};

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: VasxColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                for (int i = 0; i < widget.fields.length; i++) ...[
                  _buildField(widget.fields[i], i),
                  if (i < widget.fields.length - 1) const SizedBox(height: 18),
                ],
                if (widget.customFooter != null) ...[
                  const SizedBox(height: 20),
                  widget.customFooter!,
                ],
              ],
            ),
          ),
        ),
        if (widget.submitButtonLabel != null && widget.onSubmit != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.submitButtonLabel!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.headerIcon != null) ...[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.badgeColor ?? _primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.headerIcon,
              color: widget.badgeIconColor ?? _primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: VasxColors.textPrimary,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(VasxFormFieldConfig field, int index) {
    final isPassword = field.obscureText;
    final isCurrentlyObscured = _obscureStateMap[index] ?? isPassword;

    Widget? suffixWidget;
    if (isPassword) {
      suffixWidget = IconButton(
        icon: Icon(
          isCurrentlyObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: Colors.grey[500],
        ),
        onPressed: () {
          setState(() {
            _obscureStateMap[index] = !isCurrentlyObscured;
          });
        },
      );
    } else if (field.suffixIcon != null) {
      suffixWidget = IconButton(
        icon: Icon(field.suffixIcon, size: 20, color: Colors.grey[500]),
        onPressed: field.onSuffixIconTap,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: field.controller,
          obscureText: isCurrentlyObscured,
          keyboardType: field.keyboardType,
          enabled: field.enabled,
          validator: field.validator,
          onChanged: field.onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: VasxColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: field.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: field.prefixIcon != null
                ? Icon(field.prefixIcon, size: 20, color: Colors.grey[400])
                : null,
            suffixIcon: suffixWidget,
            filled: true,
            fillColor: field.enabled ? const Color(0xFFF9FAFB) : const Color(0xFFF0F0F0),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }
}
