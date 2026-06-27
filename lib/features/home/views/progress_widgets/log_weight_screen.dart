part of '../progress.dart';

class LogWeightScreen extends ConsumerStatefulWidget {
  const LogWeightScreen({
    super.key,
    this.initialWeight,
    this.initialUnit = 'Kg',
    this.refreshFilter = 'daily',
  });

  final double? initialWeight;
  final String initialUnit;
  final String refreshFilter;

  @override
  ConsumerState<LogWeightScreen> createState() => _LogWeightScreenState();
}

class _LogWeightScreenState extends ConsumerState<LogWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late DateTime _selectedDate;
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedUnit = widget.initialUnit.toLowerCase() == 'lb' ? 'Lb' : 'Kg';
    _weightController = TextEditingController(
      text: widget.initialWeight == null
          ? ''
          : _formatInitialWeight(widget.initialWeight!),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  String _formatInitialWeight(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              surface: AppColors.surfaceColor,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text.trim());
    final entryDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      12,
    );
    final success =
        await ref.read(userProfileViewModelProvider.notifier).logWeight(
              weight: weight,
              unit: _selectedUnit,
              date: entryDate,
              refreshFilter: widget.refreshFilter,
            );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      final error = ref.read(userProfileViewModelProvider).errorMessage ??
          'Unable to log weight';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Weight'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Weight',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your latest weight so your progress chart stays accurate.',
                  style: TextStyle(
                    color: AppColors.textLightGrey,
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Weight',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter weight',
                    suffixText: _selectedUnit,
                    suffixStyle: const TextStyle(
                      color: AppColors.textLightGrey,
                      fontFamily: AppFonts.lato,
                      fontWeight: FontWeight.w700,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceGrey2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    if (parsed == null) {
                      return 'Enter a valid weight';
                    }
                    if (parsed <= 0) {
                      return 'Weight must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                UnitToggleWidget(
                  leftUnit: 'Kg',
                  rightUnit: 'Lb',
                  isLeftSelected: _selectedUnit == 'Kg',
                  onLeftTap: () => setState(() => _selectedUnit = 'Kg'),
                  onRightTap: () => setState(() => _selectedUnit = 'Lb'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Date',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey2,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMM d, yyyy').format(_selectedDate),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontFamily: AppFonts.lato,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textLightGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: CustomYafButton(
                    text: 'Save Weight',
                    width: double.infinity,
                    height: 54,
                    radius: 14,
                    isLoading: userState.isWeightLogSubmitting,
                    onPressed: userState.isWeightLogSubmitting ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
