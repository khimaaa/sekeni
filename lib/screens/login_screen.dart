import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../services/app_state.dart';
import '../services/locale_service.dart';
import '../widgets/mauritania_logo.dart';
import 'hotel_shell.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hotelNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool get isHotel => widget.role == UserRole.hotel;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _phoneController.dispose();
    _hotelNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final l = context.read<LocaleService>();
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _snack(l.t('Entrez votre numéro de téléphone', 'أدخل رقم هاتفك'));
      return;
    }

    if (isHotel) {
      final name = _hotelNameController.text.trim();
      if (name.isEmpty) {
        _snack(l.t('Entrez le nom de l\'hôtel', 'أدخل اسم الفندق'));
        return;
      }
      context.read<AppState>().loginHotel(
            name: name,
            email: _emailController.text.trim(),
            phone: phone,
          );
      _go(const HotelShell());
    } else {
      final prenom = _prenomController.text.trim();
      final nom = _nomController.text.trim();
      if (prenom.isEmpty || nom.isEmpty) {
        _snack(l.t('Entrez votre prénom et nom', 'أدخل الاسم واللقب'));
        return;
      }
      context.read<AppState>().loginPerson(
            prenom: prenom,
            nom: nom,
            phone: phone,
            userRole: widget.role,
          );
      _go(const MainShell());
    }
  }

  void _go(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.watch<LocaleService>();
    final roleTitle = l.t(
      widget.role.title,
      widget.role == UserRole.tenant
          ? 'إيواء'
          : widget.role == UserRole.owner
              ? 'مالك'
              : 'فندق',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(l.t('Connexion', 'تسجيل الدخول') + ' — $roleTitle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              MauritaniaLogo(size: isHotel ? 72 : 64),
              const SizedBox(height: 16),
              Text(
                isHotel
                    ? l.t('Espace Hôtel', 'مساحة الفندق')
                    : l.t('Espace $roleTitle', 'مساحة $roleTitle'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007A3D),
                ),
              ),
              const SizedBox(height: 28),
              if (isHotel) ...[
                _field(l.t('Nom de l\'hôtel', 'اسم الفندق'), _hotelNameController, Icons.hotel),
                const SizedBox(height: 14),
                _field(l.t('Email', 'البريد الإلكتروني'), _emailController, Icons.email_outlined),
                const SizedBox(height: 14),
                _field(l.t('Téléphone', 'الهاتف'), _phoneController, Icons.phone_outlined),
              ] else ...[
                _field(l.t('Prénom', 'الاسم'), _prenomController, Icons.person_outline),
                const SizedBox(height: 14),
                _field(l.t('Nom', 'اللقب'), _nomController, Icons.badge_outlined),
                const SizedBox(height: 14),
                _field(l.t('Téléphone', 'الهاتف'), _phoneController, Icons.phone_outlined),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHotel
                        ? Colors.red
                        : const Color(0xFF007A3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l.t('Entrer', 'دخول'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController c, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: c,
        keyboardType: icon == Icons.phone_outlined
            ? TextInputType.phone
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
