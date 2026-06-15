import 'package:flutter/material.dart';
import '../admin/admin_dashboard.dart';
import '../screens/auth_service.dart';

class AdministratorLoginForm extends StatefulWidget {
  final Color textColor;
  final Color subTextColor;

  const AdministratorLoginForm({
    super.key,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  State<AdministratorLoginForm> createState() => _AdministratorLoginFormState();
}

class _AdministratorLoginFormState extends State<AdministratorLoginForm> {
  final _adminIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _loginAdmin() async {
    final email = _adminIdController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all administrator credentials.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.signIn(email: email, password: password);
      if (response.user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          (route) => false,
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _adminIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin ID / Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _adminIdController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'admin@studio.com',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.shield_outlined, color: widget.subTextColor),
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
          'Secure Password',
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
            hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
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
        const SizedBox(height: 28),
        _FormActionButton(
          text: 'Access Admin Dashboard',
          isLoading: _isLoading,
          onTap: _isLoading ? () {} : _loginAdmin,
        ),
      ],
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
      cursor: widget.isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFF1F2937) : const Color(0xFF111827),
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
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                const Icon(Icons.lock_open, color: Colors.white, size: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }
}