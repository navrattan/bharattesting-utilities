import 'package:flutter/material.dart';
import 'package:bharattesting_core/core.dart';

class PasswordDialog extends StatefulWidget {
  final Function(String) onPasswordSet;
  final VoidCallback onCancel;

  const PasswordDialog({
    super.key,
    required this.onPasswordSet,
    required this.onCancel,
  });

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  PasswordStrengthResult? _strengthResult;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Set PDF Password',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onChanged: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password is required';
                    }
                    if (_strengthResult?.isValid != true) {
                      return 'Password is too weak';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // Password strength indicator
                if (_strengthResult != null)
                  _buildStrengthIndicator(),

                const SizedBox(height: 16),

                // Confirm password field
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Generate password button
                TextButton.icon(
                  onPressed: _generatePassword,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate Secure Password'),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _setPassword,
                      child: const Text('Set Password'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator() {
    final theme = Theme.of(context);
    final result = _strengthResult!;

    Color indicatorColor;
    switch (result.strength) {
      case PasswordStrength.weak:
        indicatorColor = theme.colorScheme.error;
        break;
      case PasswordStrength.medium:
        indicatorColor = Colors.orange;
        break;
      case PasswordStrength.strong:
        indicatorColor = Colors.green;
        break;
    }

    double strength;
    switch (result.strength) {
      case PasswordStrength.weak:
        strength = 0.3;
        break;
      case PasswordStrength.medium:
        strength = 0.6;
        break;
      case PasswordStrength.strong:
        strength = 1.0;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              result.strength.displayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: indicatorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          result.message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _validatePassword(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _strengthResult = PdfEncryptor.validatePasswordStrength(value);
      });
    } else {
      setState(() {
        _strengthResult = null;
      });
    }
  }

  void _generatePassword() {
    final password = PdfEncryptor.generateSecurePassword(length: 16);
    setState(() {
      _passwordController.text = password;
      _confirmController.text = password;
      _validatePassword(password);
    });
  }

  void _setPassword() {
    if (_formKey.currentState?.validate() == true) {
      widget.onPasswordSet(_passwordController.text);
    }
  }
}