import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../services/locale_service.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _goLogin(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.watch<LocaleService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l.t('Sekeni', 'سكني'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007A3D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.t('Qui êtes-vous ?', 'من أنت؟'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                l.t(
                  'Choisissez votre profil pour continuer',
                  'اختر ملفك للمتابعة',
                ),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              _card(
                context,
                title: l.t('Allongement', 'إيواء / مستأجر'),
                subtitle: l.t(
                  'Chercher maison, appartement ou hôtel',
                  'البحث عن منزل أو شقة أو فندق',
                ),
                icon: Icons.person_search,
                color: Colors.orange,
                role: UserRole.tenant,
              ),
              const SizedBox(height: 14),
              _card(
                context,
                title: l.t('Propriétaire', 'مالك'),
                subtitle: l.t(
                  'Gérer biens, demandes et paiements',
                  'إدارة العقارات والطلبات والمدفوعات',
                ),
                icon: Icons.home_work,
                color: const Color(0xFF2C3E50),
                role: UserRole.owner,
              ),
              const SizedBox(height: 14),
              _card(
                context,
                title: l.t('Hôtel', 'فندق'),
                subtitle: l.t(
                  'Chambres, réservations, conférences',
                  'الغرف والحجوزات وقاعات المؤتمرات',
                ),
                icon: Icons.hotel,
                color: Colors.red,
                role: UserRole.hotel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required UserRole role,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => _goLogin(context, role),
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
