import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoBackupEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';
  double _pomodoroDuration = 25.0;
  double _breakDuration = 5.0;

  final List<String> _languages = [
    'English',
    'Vietnamese',
    'Spanish',
    'French',
  ];
  final List<String> _themes = ['System', 'Light', 'Dark'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _languages.map((language) {
                    return ListTile(
                      title: Text(language),
                      trailing:
                          _selectedLanguage == language
                              ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          _selectedLanguage = language;
                        });
                        Navigator.of(context).pop();
                        _showSuccessMessage('Language changed to $language');
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Theme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _themes.map((theme) {
                    return ListTile(
                      title: Text(theme),
                      trailing:
                          _selectedTheme == theme
                              ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          _selectedTheme = theme;
                        });
                        Navigator.of(context).pop();
                        _showSuccessMessage('Theme changed to $theme');
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildGeneralSettings(),
                    const SizedBox(height: 20),
                    _buildNotificationSettings(),
                    const SizedBox(height: 20),
                    _buildStudySettings(),
                    const SizedBox(height: 20),
                    _buildDataSettings(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'App Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Customize your learning experience',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return _buildSettingsSection(
      title: 'General',
      icon: Icons.tune,
      children: [
        _buildSettingsTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: _selectedLanguage,
          onTap: _showLanguageDialog,
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.palette,
          title: 'Theme',
          subtitle: _selectedTheme,
          onTap: _showThemeDialog,
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSwitchTile(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          subtitle: 'Use dark theme',
          value: _darkModeEnabled,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_active,
          title: 'Push Notifications',
          subtitle: 'Receive study reminders and updates',
          value: _notificationsEnabled,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.volume_up,
          title: 'Sound',
          subtitle: 'Play notification sounds',
          value: _soundEnabled,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.vibration,
          title: 'Vibration',
          subtitle: 'Vibrate on notifications',
          value: _vibrationEnabled,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _vibrationEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStudySettings() {
    return _buildSettingsSection(
      title: 'Study Preferences',
      icon: Icons.school,
      children: [
        _buildSliderTile(
          icon: Icons.timer,
          title: 'Pomodoro Duration',
          subtitle: '${_pomodoroDuration.round()} minutes',
          value: _pomodoroDuration,
          min: 15.0,
          max: 60.0,
          divisions: 9,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _pomodoroDuration = value;
            });
          },
        ),
        _buildSliderTile(
          icon: Icons.coffee,
          title: 'Break Duration',
          subtitle: '${_breakDuration.round()} minutes',
          value: _breakDuration,
          min: 1.0,
          max: 15.0,
          divisions: 14,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _breakDuration = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDataSettings() {
    return _buildSettingsSection(
      title: 'Data & Storage',
      icon: Icons.storage,
      children: [
        _buildSwitchTile(
          icon: Icons.backup,
          title: 'Auto Backup',
          subtitle: 'Automatically backup your data',
          value: _autoBackupEnabled,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _autoBackupEnabled = value;
            });
          },
        ),
        _buildSettingsTile(
          icon: Icons.download,
          title: 'Export Data',
          subtitle: 'Download your study data',
          onTap: () {
            _showSuccessMessage('Data export started');
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.delete_forever,
          title: 'Clear Data',
          subtitle: 'Delete all app data',
          onTap: () {
            _showClearDataDialog();
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSettingsSection(
      title: 'About',
      icon: Icons.info,
      children: [
        _buildSettingsTile(
          icon: Icons.description,
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: () {
            // TODO: Navigate to terms of service
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          subtitle: 'Learn about data privacy',
          onTap: () {
            // TODO: Navigate to privacy policy
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            // TODO: Navigate to help section
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.star,
          title: 'Rate App',
          subtitle: 'Rate us on the app store',
          onTap: () {
            _showSuccessMessage('Thank you for your feedback!');
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        _buildSettingsTile(
          icon: Icons.share,
          title: 'Share App',
          subtitle: 'Share with friends and family',
          onTap: () {
            _showSuccessMessage('App shared successfully!');
          },
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Clear All Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: const Text(
              'This action cannot be undone. All your study data, progress, and settings will be permanently deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessMessage('All data cleared successfully');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear Data'),
              ),
            ],
          ),
    );
  }
}
