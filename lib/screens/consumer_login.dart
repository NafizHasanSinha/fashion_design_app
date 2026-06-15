import 'package:flutter/material.dart';
import '../consumer/ai_scanning_screen.dart';
import '../screens/auth_service.dart';

class ConsumerLoginForm extends StatefulWidget {
  final Color textColor;
  final Color subTextColor;
  final VoidCallback? onLoginSuccess;

  const ConsumerLoginForm({
    super.key,
    required this.textColor,
    required this.subTextColor,
    this.onLoginSuccess,
  });

  @override
  State<ConsumerLoginForm> createState() => _ConsumerLoginFormState();
}

class _ConsumerLoginFormState extends State<ConsumerLoginForm> {
  bool isSignUp = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _submitConsumerForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (isSignUp && fullName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all required fields.')),
      );
      return;
    }

    if (isSignUp && password != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isSignUp) {
        // Run database registration via Supabase Auth
        await _authService.signUp(
          email: email,
          password: password,
          metadata: {'full_name': fullName, 'role': 'consumer'},
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Processing entry...'),
            ),
          );
        }
      } else {
        // Authenticate existing records
        await _authService.signIn(email: email, password: password);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AiScanningScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // <--- এখানে 'final' পরিবর্তন করে 'finally' করা হয়েছে (FIXED)
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // কিবোর্ড স্ক্রিন ঢেকে ফেললে যেন Bottom Overflow না হয়, তাই SingleChildScrollView ব্যবহার করা হয়েছে
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSignUp) ...[
            Text(
              'Full Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'John Doe',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.person_outline,
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
          Text(
            'Consumer Email',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'consumer@email.com',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.mail_outline, color: widget.subTextColor),
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
            text: isSignUp ? 'Sign Up as Consumer' : 'Continue as Consumer',
            isLoading: _isLoading,
            onTap: _isLoading ? () {} : _submitConsumerForm,
          ),
          const SizedBox(height: 20),

          // Row এর বদলে Wrap ব্যবহার করা হয়েছে সেফটির জন্য
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  isSignUp
                      ? "Already have an account? "
                      : "Don't have an account? ",
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
                    isSignUp ? "Login" : "Register",
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
