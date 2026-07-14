import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // সুপাবেস ক্লায়েন্ট ব্যবহারের জন্য যুক্ত করা হলো
import '../Industrial_Client/design_studio.dart';
import '../screens/auth_service.dart';

class IndustrialLoginForm extends StatefulWidget {
  final Color textColor;
  final Color subTextColor;

  const IndustrialLoginForm({
    super.key,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  State<IndustrialLoginForm> createState() => _IndustrialLoginFormState();
}

class _IndustrialLoginFormState extends State<IndustrialLoginForm> {
  bool isSignUp = false;
  bool _isLoading = false;

  final _companyNameController = TextEditingController();
  final _businessIdController = TextEditingController();
  final _companyEmailController =
      TextEditingController(); // ডুয়াল লগইন (ইমেইল অথবা কোম্পানি নেম) ও সাইন-আপ উভয়ের ইনপুট ফিল্ড
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final SupabaseClient _supabase =
      Supabase.instance.client; // সুপাবেস ইনস্ট্যান্স

  void _submitIndustrialForm() async {
    final emailOrCompany = _companyEmailController.text.trim();
    final password = _passwordController.text.trim();
    final companyName = _companyNameController.text.trim();
    final businessId = _businessIdController.text.trim();

    if (emailOrCompany.isEmpty ||
        password.isEmpty ||
        (isSignUp && (companyName.isEmpty || businessId.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required field data points.'),
        ),
      );
      return;
    }

    if (isSignUp && password != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification failure: Passwords mismatch.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String targetEmail = emailOrCompany;

      if (isSignUp) {
        // সুপাবেস মেটাডাটাসহ সাইন-আপ প্রসেস (রোল: industrial_client)
        await _authService.signUp(
          email: targetEmail,
          password: password,
          metadata: {
            'company_name': companyName,
            'business_tax_id': businessId,
            'role': 'industrial_client',
          },
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Corporate registration sequence validated. Please login!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // সাইন-আপ সফল হলে ফ্রন্টএন্ড স্টেট লগইন মোডে নিয়ে যাওয়া হচ্ছে
          setState(() {
            isSignUp = false;
            _passwordController.clear();
            _confirmPasswordController.clear();
          });
        }
      } else {
        // ডুয়াল লগইন লজিক: ইনপুটটি ইমেইল নাকি কোম্পানি নেম তা চেক করা হচ্ছে
        if (!targetEmail.contains('@')) {
          // কোম্পানি নেম হলে ডাটাবেজের 'industrial_clients' টেবিল থেকে ইমেইল কুয়েরি করা হচ্ছে
          final response = await _supabase
              .from('industrial_clients')
              .select('email')
              .eq('company_name', targetEmail)
              .maybeSingle();

          if (response != null && response['email'] != null) {
            targetEmail = response['email'];
          } else {
            throw Exception(
              'Company name not found! Please check or register first.',
            );
          }
        }

        // প্রাপ্ত ইমেইল এবং পাসওয়ার্ড দিয়ে সুপাবেস সাইন-ইন
        await _authService.signIn(email: targetEmail, password: password);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductionDesignSystemScreen(),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        // সুপাবেস থেকে আসা র-ইরর মেসেজ ক্লিন করে দেখানো
        String cleanMessage = error.toString().replaceAll('Exception: ', '');
        if (cleanMessage.contains('Invalid login credentials')) {
          cleanMessage =
              'Incorrect password or account details. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cleanMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _businessIdController.dispose();
    _companyEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSignUp) ...[
            Text(
              'Company Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyNameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'XYZ Garments Ltd.',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.domain_outlined,
                  color: widget.subTextColor,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.textColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Business Registration / TAX ID',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _businessIdController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'BRN-123456789',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.receipt_long_outlined,
                  color: widget.subTextColor,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.textColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          // ডুয়াল হিন্ট টেক্সট সেটআপ করা হলো যাতে ইউজার বোঝে কোম্পানি নেমও দেওয়া যাবে
          Text(
            isSignUp ? 'Company Email Address' : 'Company Name / Email Address',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _companyEmailController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: isSignUp
                  ? 'corporate@company.com'
                  : 'Enter Company Name or Email',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                isSignUp ? Icons.business : Icons.domain_verification_outlined,
                color: widget.subTextColor,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.textColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Password',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                letterSpacing: 2,
              ),
              prefixIcon: Icon(Icons.lock_outline, color: widget.subTextColor),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.textColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (isSignUp) ...[
            Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  letterSpacing: 2,
                ),
                prefixIcon: Icon(
                  Icons.lock_clock_outlined,
                  color: widget.subTextColor,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.textColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 8),
          _FormActionButton(
            text: isSignUp
                ? 'Register Corporate Account'
                : 'Continue as Industrial',
            isLoading: _isLoading,
            onTap: _isLoading ? () {} : _submitIndustrialForm,
          ),
          const SizedBox(height: 24),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  isSignUp
                      ? "Already have a business account? "
                      : "New Business Client? ",
                  style: TextStyle(
                    color: widget.subTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () => setState(() => isSignUp = !isSignUp),
                  child: Text(
                    isSignUp ? "Login here" : "Register Business",
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const _FormActionButton({
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  State<_FormActionButton> createState() => _FormActionButtonState();
}

class _FormActionButtonState extends State<_FormActionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: isHovered
                ? const Color(0xFF1F2937)
                : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isHovered && !widget.isLoading)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else ...[
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
