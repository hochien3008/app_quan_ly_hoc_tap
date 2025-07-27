import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/shared/widgets/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Study Session Reminder',
      'message': 'Your Math study session starts in 30 minutes',
      'type': 'reminder',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'icon': Icons.schedule,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'New Group Invitation',
      'message': 'You have been invited to join "Physics Lab Team"',
      'type': 'invitation',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.group_add,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Quiz Results Available',
      'message': 'Your Math quiz results are ready to view',
      'type': 'result',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.quiz,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Document Uploaded',
      'message': 'New study material uploaded to Math group',
      'type': 'document',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.file_upload,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'Study Goal Achieved',
      'message': 'Congratulations! You completed your daily study goal',
      'type': 'achievement',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.emoji_events,
      'color': Colors.amber,
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Unread',
    'Reminders',
    'Invitations',
    'Results',
  ];

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

  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Unread':
        return _notifications
            .where((notification) => !notification['isRead'])
            .toList();
      case 'Reminders':
        return _notifications
            .where((notification) => notification['type'] == 'reminder')
            .toList();
      case 'Invitations':
        return _notifications
            .where((notification) => notification['type'] == 'invitation')
            .toList();
      case 'Results':
        return _notifications
            .where((notification) => notification['type'] == 'result')
            .toList();
      default:
        return _notifications;
    }
  }

  void _markAsRead(String notificationId) {
    if (!mounted) return;
    setState(() {
      final notification = _notifications.firstWhere(
        (n) => n['id'] == notificationId,
      );
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    if (!mounted) return;
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    _showSuccessMessage('All notifications marked as read');
  }

  void _deleteNotification(String notificationId) {
    if (!mounted) return;
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    _showSuccessMessage('Notification deleted');
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

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
            actions: [
              IconButton(
                icon: const Icon(Icons.done_all, color: Colors.white),
                onPressed: _markAllAsRead,
                tooltip: 'Mark all as read',
              ),
            ],
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
                    _buildFilterChips(),
                    const SizedBox(height: 20),
                    _buildNotificationsList(),
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
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stay Updated',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unreadCount unread notifications',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.notifications_active,
                  title: 'Total',
                  value: _notifications.length.toString(),
                  color: Colors.blue,
                ),
                _buildStatCard(
                  icon: Icons.mark_email_unread,
                  title: 'Unread',
                  value: unreadCount.toString(),
                  color: Colors.red,
                ),
                _buildStatCard(
                  icon: Icons.schedule,
                  title: 'Today',
                  value:
                      _notifications
                          .where(
                            (n) => n['timestamp'].day == DateTime.now().day,
                          )
                          .length
                          .toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (!mounted) return;
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              backgroundColor: Colors.grey.shade100,
              side: BorderSide(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children:
          _filteredNotifications.map((notification) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildNotificationCard(notification),
            );
          }).toList(),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = !notification['isRead'];

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? Colors.blue.withOpacity(0.2) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification['id']),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.w600 : FontWeight.w500,
                              color:
                                  isUnread
                                      ? Colors.black
                                      : Colors.grey.shade800,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getTimeAgo(notification['timestamp']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      _markAsRead(notification['id']);
                      break;
                    case 'delete':
                      _deleteNotification(notification['id']);
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(
                              Icons.mark_email_read,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('Mark as read'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            const Text('Delete'),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
