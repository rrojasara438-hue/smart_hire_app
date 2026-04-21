import 'dart:async';

import 'package:flutter/material.dart';
import 'services/firestore_service.dart';
import 'upload_resume.dart';
import 'models/user_model.dart';
import 'admin_resume upload.dart';

class CandidateLogin extends StatefulWidget {
  const CandidateLogin({super.key});

  @override
  State<CandidateLogin> createState() => _CandidateLoginState();
}

class _CandidateLoginState extends State<CandidateLogin> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _selectedRoleIndex = 0; // 0 = Candidate, 1 = Admin
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _extractName(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email.trim();
  }

  /// LOGIN FUNCTION
  Future<void> _handleLogin() async {
    if (_isLoggingIn) {
      return;
    }

    final isLoginFormComplete = _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    if (!isLoginFormComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );
      return;
    }

    if (_selectedRoleIndex == 0) {
      setState(() {
        _isLoggingIn = true;
      });

      try {
        final bool userExists =
            await _firestoreService.userExists(_emailController.text);

        if (!mounted) {
          return;
        }

        if (!userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("No registered account found. Please register first."),
            ),
          );
          return;
        }

        final userData = await _firestoreService.getUser(_emailController.text);

        if (!mounted) {
          return;
        }

        final name = (userData?['name'] as String?)?.trim().isNotEmpty == true
            ? (userData?['name'] as String).trim()
            : _extractName(_emailController.text);

        currentUserName.value = name;
        isUserRegistered.value = true;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResumeUploadPage(),
          ),
        );
      } on TimeoutException {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Firestore request timed out. Check that Firestore is enabled and your internet is working.",
            ),
          ),
        );
      } catch (error) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(FirestoreService.describeError(error)),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoggingIn = false;
          });
        }
      }
      return;
    }

    /// Candidate Login
    /// Admin Login
    if (_selectedRoleIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminResumeUpload(),
        ),
      );
    }
  }

  /// ROLE SELECT BUTTONS
  Widget _buildRoleToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Candidate'),
          selected: _selectedRoleIndex == 0,
          onSelected: (selected) {
            setState(() {
              _selectedRoleIndex = 0;
            });
          },
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('Admin'),
          selected: _selectedRoleIndex == 1,
          onSelected: (selected) {
            setState(() {
              _selectedRoleIndex = 1;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Smart Hire"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// ICON
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.work,
                  size: 40,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildRoleToggle(),

              const SizedBox(height: 18),

              Text(
                _selectedRoleIndex == 0
                    ? "Log in to your candidate account to manage your applications"
                    : "Log in to the admin portal to manage the platform",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedRoleIndex == 0 ? "Email Address" : "Admin Email",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "name@example.com",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedRoleIndex == 0 ? "Password" : "Admin Password",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: const Icon(Icons.visibility),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text("Keep me logged in"),
                ],
              ),

              const SizedBox(height: 20),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoggingIn ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isLoggingIn ? "Checking..." : "Log In",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              /// SOCIAL LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Google"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.facebook, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Facebook"),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
