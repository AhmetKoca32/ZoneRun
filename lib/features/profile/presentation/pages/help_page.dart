import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final subject = Uri.encodeComponent(_subjectController.text.trim());
      final body = Uri.encodeComponent(_messageController.text.trim());
      final email = 'support@zonerun.com'; // TODO: Replace with actual support email
      
      final mailtoUri = Uri.parse('mailto:$email?subject=$subject&body=$body');
      
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
        if (mounted) {
          final theme = context.appTheme;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mail uygulamanız açıldı',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textPrimary,
                ),
              ),
              backgroundColor: theme.surface,
            ),
          );
        }
      } else {
        if (mounted) {
          final theme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mail gönderilemedi. Lütfen mail uygulamanızı kontrol edin.',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textPrimary,
                ),
              ),
              backgroundColor: theme.secondaryBackground,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final theme = context.appTheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bir hata oluştu: $e',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textPrimary,
              ),
            ),
            backgroundColor: theme.secondaryBackground,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button and Header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: theme.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Yardım',
                      style: AppTypography.headlineSmall.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hero Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.surface,
                      theme.surface.withOpacity(0.8),
                      theme.secondaryBackground.withOpacity(0.3),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.textPrimary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.primaryBackground.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.support_agent,
                        color: theme.textPrimary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Bize Ulaşın',
                        style: AppTypography.headlineSmall.copyWith(
                          color: theme.textPrimary,
                          fontWeight: AppTypography.bold,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Sorularınız veya önerileriniz için bize mail gönderebilirsiniz',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.textSecondary,
                            fontWeight: AppTypography.light,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject Field
                    Text(
                      'Konu',
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _subjectController,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Örn: Uygulama hatası, öneri...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: theme.textSecondary,
                        ),
                        filled: true,
                        fillColor: theme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.border,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.border,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.accent,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lütfen bir konu girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Message Field
                    Text(
                      'Mesaj',
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 8,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Mesajınızı buraya yazın...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: theme.textSecondary,
                        ),
                        filled: true,
                        fillColor: theme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.border,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.border,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.accent,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lütfen bir mesaj girin';
                        }
                        if (value.trim().length < 10) {
                          return 'Mesaj en az 10 karakter olmalıdır';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Send Button
                    GestureDetector(
                      onTap: _isSending ? null : _sendEmail,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.accent,
                              theme.accent.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isSending
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primaryBackground,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: theme.primaryBackground,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Mail Gönder',
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: theme.primaryBackground,
                                        fontWeight: AppTypography.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

