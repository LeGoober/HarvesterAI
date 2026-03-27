import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

void main() {
  runApp(const HarvesterAiApp());
}

class HarvesterAiApp extends StatelessWidget {
  const HarvesterAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HarvesterAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DC578),
          surface: Color(0xFF0A1F15),
        ),
        useMaterial3: true,
      ),
      home: const AuthSelectionScreen(),
    );
  }
}

// ============= AUTH SELECTION SCREEN =============
class AuthSelectionScreen extends StatefulWidget {
  const AuthSelectionScreen({super.key});

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen> {
  static const List<String> _languages = ['EN', 'ZU', 'XH', 'AF'];
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: _LanguageSelector(
                      languages: _languages,
                      selectedLanguage: _selectedLanguage,
                      onSelected: (value) {
                        setState(() => _selectedLanguage = value);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _BrandMark(),
                          const SizedBox(height: 18),
                          const Text(
                            'HarvesterAI',
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1,
                              height: 0.95,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Intelligent farming for a\nfood-secure South Africa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                              color: Color(0xFFF5F5F5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          const _PagerDots(),
                          const SizedBox(height: 24),
                          _AuthButton(
                            label: 'Sign in with phone number',
                            icon: Icons.call_rounded,
                            backgroundColor: const Color(0xFF1DC578),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PhoneLoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _AuthButton(
                            label: 'Continue with email',
                            icon: Icons.email_rounded,
                            backgroundColor: const Color(0x33FFFFFF),
                            foregroundColor: Colors.white,
                            borderColor: const Color(0x88FFFFFF),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailLoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _AuthButton(
                            label: 'Continue with Google',
                            icon: Icons.g_mobiledata_rounded,
                            backgroundColor: const Color(0xFFF2F2F2),
                            foregroundColor: const Color(0xFF131313),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GoogleLoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GuestAccessScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: Color(0xFFF4F4F4),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: _OfflinePill(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= PHONE LOGIN SCREEN =============
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignup = false;
  String? _errorMessage;
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleAuth() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
        _isLoading = false;
      });
      return;
    }

    if (!phone.startsWith('+27') && !phone.startsWith('27')) {
      setState(() {
        _errorMessage = 'Please enter a valid South African number';
        _isLoading = false;
      });
      return;
    }

    if (_isSignup) {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your name';
          _isLoading = false;
        });
        return;
      }

      if (password != _confirmPasswordController.text.trim()) {
        setState(() {
          _errorMessage = 'Passwords do not match';
          _isLoading = false;
        });
        return;
      }
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FarmOnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          splashColor: Colors.white.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Icon(
                      Icons.phone_rounded,
                      size: 80,
                      color: Color(0xFFE9D8A6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isSignup ? 'Create Account' : 'Sign in with Phone',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignup
                          ? 'Create your account with phone number'
                          : 'Enter your phone number and password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    if (_isSignup)
                      ...[
                        _AuthTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Your name',
                          icon: Icons.person_rounded,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                      ],
                    _AuthTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: '+27 (Your number)',
                      icon: Icons.phone_rounded,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),
                    _AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                      enabled: !_isLoading,
                    ),
                    if (_isSignup)
                      ...[
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          icon: Icons.lock_rounded,
                          obscureText: true,
                          enabled: !_isLoading,
                        ),
                      ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.6),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade200,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1DC578),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                _isSignup ? 'Create Account' : 'Sign In',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isSignup = !_isSignup;
                            _errorMessage = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _isSignup
                                ? 'Already have an account? Sign In'
                                : 'Don\'t have an account? Create One',
                            style: const TextStyle(
                              color: Color(0xFF1DC578),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= EMAIL LOGIN SCREEN =============
class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignup = false;
  String? _errorMessage;
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleAuth() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
        _isLoading = false;
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email';
        _isLoading = false;
      });
      return;
    }

    if (_isSignup) {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your name';
          _isLoading = false;
        });
        return;
      }

      if (password != _confirmPasswordController.text.trim()) {
        setState(() {
          _errorMessage = 'Passwords do not match';
          _isLoading = false;
        });
        return;
      }
    }

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FarmOnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          splashColor: Colors.white.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Icon(
                      Icons.email_rounded,
                      size: 80,
                      color: Color(0xFFE9D8A6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isSignup ? 'Create Account' : 'Sign in with Email',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignup
                          ? 'Create your account with email'
                          : 'Enter your email and password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    if (_isSignup)
                      ...[
                        _AuthTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Your name',
                          icon: Icons.person_rounded,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                      ],
                    _AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'your@email.com',
                      icon: Icons.email_rounded,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),
                    _AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                      enabled: !_isLoading,
                    ),
                    if (_isSignup)
                      ...[
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          icon: Icons.lock_rounded,
                          obscureText: true,
                          enabled: !_isLoading,
                        ),
                      ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.6),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade200,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1DC578),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                _isSignup ? 'Create Account' : 'Sign In',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isSignup = !_isSignup;
                            _errorMessage = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _isSignup
                                ? 'Already have an account? Sign In'
                                : 'Don\'t have an account? Create One',
                            style: const TextStyle(
                              color: Color(0xFF1DC578),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= GOOGLE LOGIN SCREEN =============
class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  bool _isLoading = false;

  void _handleGoogleAuth(bool isSignup) {
    setState(() => _isLoading = true);

    // Simulate OAuth call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FarmOnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      splashColor: Colors.white.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.security_rounded,
                  size: 80,
                  color: Color(0xFFE9D8A6),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Quick and secure authentication',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed:
                              _isLoading ? null : () => _handleGoogleAuth(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F1419),
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0F1419),
                                    ),
                                  ),
                                )
                              : const Icon(Icons.g_mobiledata_rounded, size: 24),
                          label: const Text(
                            'Sign In with Google',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'or',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed:
                              _isLoading ? null : () => _handleGoogleAuth(true),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 24),
                          label: const Text(
                            'Create with Google',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============= GUEST ACCESS SCREEN =============
class GuestAccessScreen extends StatefulWidget {
  const GuestAccessScreen({super.key});

  @override
  State<GuestAccessScreen> createState() => _GuestAccessScreenState();
}

class _GuestAccessScreenState extends State<GuestAccessScreen> {
  bool _isLoading = false;

  void _handleGuestAccess() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FarmOnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        splashColor: Colors.white.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 120,
                    color: Color(0xFFE9D8A6),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Browse as Guest',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Explore HarvesterAI Features\nwithout signing in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGuestAccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DC578),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= REUSABLE WIDGETS =============

class _FarmBackdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7B9B7A),
            Color(0xFF5E7D5D),
            Color(0xFF4A6348),
            Color(0xFF2D3F2D),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _FieldPainter(),
      ),
    );
  }
}

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
 
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFD4A574).withAlpha(180),
          const Color(0xFFB8956A).withAlpha(200),
          const Color(0xFF9A8A7A).withAlpha(180),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.3, size.width, 80));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.35),
        width: size.width * 0.5,
        height: size.height * 0.15,
      ),
      skyPaint,
    );

  
    final darkGreen = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1E3A1E).withAlpha(100);

    final glowPaint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..color = const Color(0xFF2D5A2D).withAlpha(60);

    for (int i = 0; i < 12; i++) {
      final t = i / 11;
      final startX = size.width * (0.05 + t * 0.9);
      final endX = size.width * 0.5;
      final endY = size.height * 0.5;

      final path = Path()
        ..moveTo(startX, size.height)
        ..quadraticBezierTo(
          startX + (endX - startX) * 0.3,
          size.height * 0.65,
          endX,
          endY,
        );

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, darkGreen);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: CustomPaint(
        painter: _CropIconPainter(),
      ),
    );
  }
}

class _CropIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    

    final cropPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFE066),
          const Color(0xFFD4A537),
        ],
      ).createShader(
        Rect.fromCenter(center: center, width: size.width, height: size.height),
      )
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final shadePaint = Paint()
      ..color = const Color(0xFF8B7355).withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final stalkCount = 5;
    final startAngle = -0.6;
    final angleSpread = 1.2;

    for (int i = 0; i < stalkCount; i++) {
      final progress = i / (stalkCount - 1);
      final angle = startAngle + (angleSpread * progress);
      
      // Main stalk
      final stalkLength = size.width * 0.35;
      final angleSin = sin(angle);
      
      final stalkEnd = Offset(
        center.dx + (stalkLength * 0.7 * angleSin),
        center.dy - (stalkLength * (1.0 - angleSin.abs() * 0.3)),
      );

      // Draw shadow stalk
      canvas.drawLine(center, stalkEnd, shadePaint);
      
      // Draw main stalk
      canvas.drawLine(center, stalkEnd, cropPaint);

      // Draw grain heads (wheat grains)
      const grainCount = 6;
      for (int j = 0; j < grainCount; j++) {
        final grainProgress = j / grainCount;
        final grainPoint = Offset(
          center.dx + (stalkLength * 0.7 * grainProgress * angleSin),
          center.dy - (stalkLength * grainProgress * (1.0 - angleSin.abs() * 0.3)),
        );

        // Small grain circles
        canvas.drawCircle(
          grainPoint,
          2.0 + (grainProgress * 1.5),
          cropPaint,
        );

        // Add some small offshoots
        if (j % 2 == 0) {
          final offsetX = 4.0 * (j % 2 == 0 ? 1 : -1);
          canvas.drawLine(
            grainPoint,
            Offset(grainPoint.dx + offsetX, grainPoint.dy - 3),
            shadePaint,
          );
        }
      }
    }

    // Draw decorative circle border
    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFE066).withValues(alpha: 0.6),
          const Color(0xFFD4A537).withValues(alpha: 0.3),
        ],
      ).createShader(
        Rect.fromCenter(center: center, width: size.width, height: size.height),
      )
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, size.width * 0.48, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PagerDots extends StatelessWidget {
  const _PagerDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == 1 ? 12 : 8,
          height: index == 1 ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index == 1 ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.languages,
    required this.selectedLanguage,
    required this.onSelected,
  });

  final List<String> languages;
  final String selectedLanguage;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages
                  .map(
                    (language) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Material(
                        color: language == selectedLanguage
                            ? const Color(0x4DFFFFFF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () => onSelected(language),
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 56,
                            height: 48,
                            child: Center(
                              child: Text(
                                language,
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha:
                                        language == selectedLanguage ? 1.0 : 0.85,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatefulWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final bool enabled;

  @override
  State<_AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<_AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _obscureText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF1DC578),
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            prefixIcon: Icon(
              widget.icon,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            suffixIcon: widget.obscureText
                ? GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  )
                : null,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 16,
            ),
            labelText: widget.label,
            labelStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _OfflinePill extends StatelessWidget {
  const _OfflinePill();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
              SizedBox(width: 8),
              Text(
                'Offline ready',
                style: TextStyle(
                  color: Color(0xFFE6E6E6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FarmOnboardingScreen extends StatefulWidget {
  const FarmOnboardingScreen({super.key});

  @override
  State<FarmOnboardingScreen> createState() => _FarmOnboardingScreenState();
}

class _FarmOnboardingScreenState extends State<FarmOnboardingScreen> {
  String _selectedLocation = 'Mpumalanga';
  double _landSize = 5.0;
  String _selectedSoilType = '';

  void _handleNext() {
    if (_selectedSoilType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a soil type'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _FarmBackdrop(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            splashColor: Colors.white.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        const OnboardingLanguageSelector(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FarmProfileHeader(userName: 'Thandi'),
                    const SizedBox(height: 32),
                    const OnboardingProgressIndicator(currentStep: 0),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tell us about your farm',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FarmLocationSelector(
                      value: _selectedLocation,
                      onChanged: (value) {
                        setState(() => _selectedLocation = value);
                      },
                    ),
                    const SizedBox(height: 32),
                    LandSizeSlider(
                      value: _landSize,
                      onChanged: (value) {
                        setState(() => _landSize = value);
                      },
                    ),
                    const SizedBox(height: 32),
                    SoilTypeSelector(
                      selectedType: _selectedSoilType,
                      onSelected: (type) {
                        setState(() => _selectedSoilType = type);
                      },
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1DC578),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FarmProfileHeader extends StatelessWidget {
  final String userName;

  const FarmProfileHeader({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome, $userName!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Let\'s grow smarter',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1DC578),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentStep;

  const OnboardingProgressIndicator({required this.currentStep, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${currentStep + 1} / 3',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: List.generate(3, (index) {
            final isCurrent = index == currentStep;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: isCurrent ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFF1DC578)
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class FarmLocationSelector extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const FarmLocationSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locations = [
      'Mpumalanga',
      'Gauteng',
      'Limpopo',
      'KwaZulu-Natal',
      'Western Cape',
      'Eastern Cape',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF0A1F15),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            icon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.expand_more,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            items: locations.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(location),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on, size: 16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class LandSizeSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const LandSizeSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Land size',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)} hectares',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: const Color(0xFF1DC578),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: value,
            min: 0.5,
            max: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class SoilTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelected;

  const SoilTypeSelector({
    required this.selectedType,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final soilTypes = ['Clay', 'Loam', 'Sand'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Soil type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: soilTypes.map((type) {
            final isSelected = selectedType == type;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => onSelected(type),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1DC578)
                            : Colors.white.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage(_getSoilImage(type)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withValues(
                          alpha: isSelected ? 0.3 : 0.4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF1DC578)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getSoilImage(String type) {
    return 'assets/soil_$type.png';
  }
}

class OnboardingLanguageSelector extends StatefulWidget {
  const OnboardingLanguageSelector({super.key});

  @override
  State<OnboardingLanguageSelector> createState() =>
      _OnboardingLanguageSelectorState();
}

class _OnboardingLanguageSelectorState extends State<OnboardingLanguageSelector> {
  static const List<String> _languages = ['EN', 'ZU', 'XH', 'AF'];
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((lang) {
              final isSelected = _selectedLanguage == lang;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
