import 'package:flutter/material.dart';

import 'section_header.dart';
import 'settings_list_item.dart';

class ProfileEditSection extends StatelessWidget {
  final bool isProMember;
  final VoidCallback? onNameEdit;
  final VoidCallback? onAvatarEdit;
  final VoidCallback? onUpgradeToPro;

  const ProfileEditSection({
    super.key,
    required this.isProMember,
    this.onNameEdit,
    this.onAvatarEdit,
    this.onUpgradeToPro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Profil Ayarları'),
        SettingsListItem(
          icon: Icons.person_outline,
          title: 'İsim Düzenle',
          onTap: onNameEdit,
        ),
        SettingsListItem(
          icon: Icons.camera_alt_outlined,
          title: 'Avatar Değiştir',
          onTap: onAvatarEdit,
        ),
        if (!isProMember)
          SettingsListItem(
            icon: Icons.star_outline,
            title: 'Pro\'ya Geç',
            badgeText: 'Yeni',
            badgeColor: const Color(0xFFD4AF37),
            onTap: onUpgradeToPro,
          )
        else
          SettingsListItem(
            icon: Icons.star,
            title: 'Pro Üyelik',
            badgeText: 'Aktif',
            badgeColor: const Color(0xFFD4AF37),
            onTap: () {
              // Show Pro membership details
            },
          ),
      ],
    );
  }
}

