import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/view/widgets/LoginFormWidget.dart';
import 'package:green_biller/features/auth/login/view/widgets/LogoHeaderWidget.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
          final isDesktop = constraints.maxWidth >= 1200;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.05),
                  primaryColor.withOpacity(0.15),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 100 : 24,
                      vertical: 24,
                    ),
                    child: isDesktop
                        ? _buildDesktopLayout()
                        : isTablet
                            ? _buildTabletLayout()
                            : _buildMobileLayout(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child: LogoHeaderWidget(),
        ),
        SizedBox(width: 48),
        Expanded(
          flex: 1,
          child: LoginFormWidget(),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return const Row(
      children: [
        Expanded(
          flex: 1,
          child: LogoHeaderWidget(),
        ),
        SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: LoginFormWidget(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return const Column(
      children: [
        SizedBox(height: 32),
        LoginFormWidget(),
      ],
    );
  }
}
