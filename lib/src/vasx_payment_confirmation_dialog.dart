import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Describes a single item breakdown allocation in [VasxPaymentConfirmationDialog].
class VasxPaymentConfirmationItem {
  /// Description label of the item or fee.
  final String label;

  /// Cost or fee amount for this item.
  final double amount;

  /// Whether the payment allocation for this item is verified/completed.
  final bool isCompleted;

  /// Creates a [VasxPaymentConfirmationItem].
  const VasxPaymentConfirmationItem({
    required this.label,
    required this.amount,
    this.isCompleted = true,
  });
}

/// Helper function to display the [VasxPaymentConfirmationDialog] as a modal popup.
Future<double?> showVasxPaymentConfirmationDialog({
  required BuildContext context,
  String title = 'Payment Details',
  required String description,
  required double totalAmount,
  double alreadyPaidAmount = 0.0,
  String currencySymbol = '₹',
  List<VasxPaymentConfirmationItem> breakdownItems = const [],
  Color? primaryColor,
}) {
  return showDialog<double>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: VasxPaymentConfirmationDialog(
        title: title,
        description: description,
        totalAmount: totalAmount,
        alreadyPaidAmount: alreadyPaidAmount,
        currencySymbol: currencySymbol,
        breakdownItems: breakdownItems,
        primaryColor: primaryColor,
        onConfirmPayment: (paid) => Navigator.of(context).pop(paid),
        onCancel: () => Navigator.of(context).pop(null),
      ),
    ),
  );
}

/// A modern, styled payment confirmation dialog component matching SaaS billing design systems.
///
/// Features a key-value breakdown (Net Amount, Already Paid, Balance Due), an editable
/// "Pay Now" input box, an item allocation preview card, an interactive "Slide to Pay" button,
/// and cancel action.
class VasxPaymentConfirmationDialog extends StatefulWidget {
  /// Header title text (e.g. `'Payment Details'`).
  final String title;

  /// Payment description line (e.g. `'Supermarket Checkout (5 items)'`).
  final String description;

  /// Total gross amount before previous payments.
  final double totalAmount;

  /// Amount previously paid or credited. Defaults to `0.0`.
  final double alreadyPaidAmount;

  /// Currency symbol string prefix. Defaults to `'₹'`.
  final String currencySymbol;

  /// Item breakdown list shown in the light blue allocation preview box.
  final List<VasxPaymentConfirmationItem> breakdownItems;

  /// Callback when payment is confirmed with the final amount to pay.
  final ValueChanged<double>? onConfirmPayment;

  /// Callback when the dialog is cancelled.
  final VoidCallback? onCancel;

  /// Primary color used for header icon, titles, and slider background.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [VasxPaymentConfirmationDialog].
  const VasxPaymentConfirmationDialog({
    super.key,
    this.title = 'Payment Details',
    required this.description,
    required this.totalAmount,
    this.alreadyPaidAmount = 0.0,
    this.currencySymbol = '₹',
    this.breakdownItems = const [],
    this.onConfirmPayment,
    this.onCancel,
    this.primaryColor,
  });

  @override
  State<VasxPaymentConfirmationDialog> createState() =>
      _VasxPaymentConfirmationDialogState();
}

class _VasxPaymentConfirmationDialogState
    extends State<VasxPaymentConfirmationDialog> {
  late TextEditingController _payNowController;
  double _dragPosition = 0.0;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;
  double get _balanceDue => widget.totalAmount - widget.alreadyPaidAmount;

  @override
  void initState() {
    super.initState();
    _payNowController = TextEditingController(
      text: '${widget.currencySymbol} ${_balanceDue.toStringAsFixed(2)}',
    );
  }

  @override
  void dispose() {
    _payNowController.dispose();
    super.dispose();
  }

  void _triggerPayment() {
    final rawText = _payNowController.text
        .replaceAll(widget.currencySymbol, '')
        .replaceAll(',', '')
        .trim();
    final parsed = double.tryParse(rawText) ?? _balanceDue;
    widget.onConfirmPayment?.call(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Material(
          color: const Color(0xFFF1F1F6),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSummarySection(),
                const SizedBox(height: 20),
                _buildPayNowInput(),
                if (widget.breakdownItems.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildAllocationPreview(),
                ],
                const SizedBox(height: 24),
                _buildSlideToPayButton(),
                const SizedBox(height: 12),
                _buildCancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.credit_card_rounded,
          color: _primary,
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: _primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.description,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: VasxColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amount',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '${widget.currencySymbol}${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: VasxColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(height: 1, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Net Amount',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '${widget.currencySymbol}${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: VasxColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Already Paid',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '${widget.currencySymbol}${widget.alreadyPaidAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A), // Green
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance Due',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '${widget.currencySymbol}${_balanceDue.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDC2626), // Red
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayNowInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pay Now:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: VasxColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 46,
          child: TextFormField(
            controller: _payNowController,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: VasxColors.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE5E7EB),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allocation Preview',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: VasxColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE), // Light sky blue
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < widget.breakdownItems.length; i++) ...[
                _buildBreakdownRow(widget.breakdownItems[i]),
                if (i < widget.breakdownItems.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(VasxPaymentConfirmationItem item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          '${widget.currencySymbol}${item.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: VasxColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        if (item.isCompleted)
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF22C55E), // Vibrant green
            size: 18,
          ),
      ],
    );
  }

  Widget _buildSlideToPayButton() {
    const double buttonHeight = 54.0;
    const double thumbSize = 44.0;
    const double padding = 5.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - thumbSize - (padding * 2);

        return Container(
          height: buttonHeight,
          width: double.infinity,
          padding: const EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Slide to Pay ${widget.currencySymbol}${_balanceDue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ),
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx)
                          .clamp(0.0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition >= maxDrag * 0.75) {
                      setState(() => _dragPosition = maxDrag);
                      _triggerPayment();
                    } else {
                      setState(() => _dragPosition = 0.0);
                    }
                  },
                  onTap: () {
                    _triggerPayment();
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: _primary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCancelButton() {
    return Center(
      child: TextButton(
        onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
