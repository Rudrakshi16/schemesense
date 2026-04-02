import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _incomeController = TextEditingController();

  String? _selectedOccupation;
  String? _selectedGender;
  String? _selectedState;
  bool _isLoading = false;

  final List<String> _occupations = [
    'Salaried Employee', 'Self-Employed', 'Farmer', 'Freelancer',
    'Student', 'Retired', 'Homemaker', 'Business Owner', 'Other',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  final List<String> _states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar',
    'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh',
    'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra',
    'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _handleFindSchemes() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoadingScreen(
                age: int.parse(_ageController.text),
                income: int.parse(_incomeController.text),
                occupation: _selectedOccupation!,
                gender: _selectedGender!,
                state: _selectedState!,
              ),
            ),
          );
          setState(() => _isLoading = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SchemeAssist AI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.lg),
            const Text(
              'AI Scheme Navigator',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Find government schemes you are eligible for in seconds.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: Spacing.xxl),
            _buildForm(),
            const SizedBox(height: Spacing.xxl),
            _buildSubmitButton(),
            const SizedBox(height: Spacing.lg),
            Center(
              child: Text(
                'Powered by AI to simplify government policies',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(_ageController, 'Age', 'Enter your age',
              TextInputType.number, (v) {
            if (v == null || v.isEmpty) return 'Required';
            final n = int.tryParse(v);
            if (n == null || n < 18 || n > 100) return 'Enter valid age (18-100)';
            return null;
          }),
          const SizedBox(height: Spacing.lg),
          _buildTextField(_incomeController, 'Annual Income (₹)',
              'Enter your annual income', TextInputType.number, (v) {
            if (v == null || v.isEmpty) return 'Required';
            if (int.tryParse(v) == null) return 'Enter valid number';
            return null;
          }),
          const SizedBox(height: Spacing.lg),
          _buildDropdown('Occupation', 'Select occupation', _selectedOccupation,
              _occupations, (v) => setState(() => _selectedOccupation = v)),
          const SizedBox(height: Spacing.lg),
          _buildDropdown('Gender', 'Select gender', _selectedGender, _genders,
              (v) => setState(() => _selectedGender = v)),
          const SizedBox(height: Spacing.lg),
          _buildDropdown('State', 'Select state', _selectedState, _states,
              (v) => setState(() => _selectedState = v)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint,
      TextInputType type, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.sm),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, String? value,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.sm),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleFindSchemes,
        child: _isLoading
            ? const SizedBox(
                height: 22, width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Find Eligible Schemes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }
}
