import 'package:flutter/material.dart';

import 'section_header.dart';
import 'settings_list_item.dart';

class ProfileEditSection extends StatelessWidget {
  final VoidCallback? onNameEdit;
  final VoidCallback? onAvatarEdit;

  const ProfileEditSection({
    super.key,
    this.onNameEdit,
    this.onAvatarEdit,
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
      ],
    );
  }
}

