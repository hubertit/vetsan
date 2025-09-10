import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../providers/tab_index_provider.dart';
import 'edit_profile_screen.dart';
import 'about_screen.dart';
import 'help_support_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../merchant/presentation/screens/transactions_screen.dart';
import '../../../merchant/presentation/screens/wallets_screen.dart' show WalletCard, WalletsScreen;
import '../../../../shared/widgets/transaction_item.dart';
import '../../../../shared/models/transaction.dart';
import 'package:d_chart/d_chart.dart';
import '../../../../shared/models/wallet.dart';
import 'request_payment_screen.dart';
import 'pay_screen.dart';
import 'payouts_screen.dart';
import 'search_screen.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../chat/presentation/screens/chat_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabIndexProvider);
    final tabs = [
      const _DashboardTab(),
      const TransactionsScreen(),
      const WalletsScreen(), // Restore the merchant WalletsScreen as the tab
      const ChatListScreen(),
      const ProfileTab(),
    ];
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(tabIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallets',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  // State to track balance visibility for each wallet
  final Map<String, bool> _walletBalanceVisibility = {};

  // Method to handle balance visibility changes
  void _onBalanceVisibilityChanged(String walletId, bool showBalance) {
    setState(() {
      _walletBalanceVisibility[walletId] = showBalance;
    });
  }

  // Mock wallets for PageView
  List<Wallet> get homeWallets => [
    Wallet(
      id: 'WALLET-1',
      name: 'Main Wallet',
      balance: 250000,
      currency: 'RWF',
      type: 'individual',
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      owners: ['You'],
      isDefault: true,
    ),
    Wallet(
      id: 'WALLET-2',
      name: 'Joint Wallet',
      balance: 1200000,
      currency: 'RWF',
      type: 'joint',
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      owners: ['You', 'Alice', 'Eric'],
      isDefault: false,
      description: 'Joint savings for family expenses',
      targetAmount: 2000000,
      targetDate: DateTime.now().add(const Duration(days: 180)),
    ),
    Wallet(
      id: 'WALLET-3',
      name: 'Vacation Fund',
      balance: 350000,
      currency: 'RWF',
      type: 'individual',
      status: 'inactive',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      owners: ['You'],
      isDefault: false,
      description: 'Vacation savings',
      targetAmount: 500000,
      targetDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  // Mock metrics
  Map<String, dynamic> get metrics => {
    'Today\'s Revenue': 150000,
    'Total Transactions': 42,
    'Pending Settlements': 3,
  };

  // Mock recent transactions
  List<Transaction> get mockTransactions => [
    Transaction(
      id: 'TXN-1001',
      amount: 25000,
      currency: 'RWF',
      type: 'payment',
      status: 'success',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'TXN #1234',
      paymentMethod: 'Mobile Money',
      customerName: 'Alice Umutoni',
      customerPhone: '0788123456',
      reference: 'PMT-20240601-001',
    ),
    Transaction(
      id: 'TXN-1002',
      amount: 120000,
      currency: 'RWF',
      type: 'payment',
      status: 'pending',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      description: 'TXN #1235',
      paymentMethod: 'Card',
      customerName: 'Eric Niyonsaba',
      customerPhone: '0722123456',
      reference: 'PMT-20240601-002',
    ),
    Transaction(
      id: 'TXN-1003',
      amount: 50000,
      currency: 'RWF',
      type: 'refund',
      status: 'success',
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Refund for TXN #1232',
      paymentMethod: 'Bank',
      customerName: 'Claudine Mukamana',
      customerPhone: '0733123456',
      reference: 'REF-20240530-001',
    ),
  ];

  // Mock chart data
  Map<String, double> get paymentMethodBreakdown => {
    'Mobile Money': 60,
    'Card': 25,
    'Bank': 10,
    'QR/USSD': 5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/images/logo-name.png',
            height: 32, // reduced by 20%
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimaryColor),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Default Wallet Card
            SizedBox(
              height: 180, // increased to fix overflow issue
              child: PageView.builder(
                itemCount: homeWallets.length,
                controller: PageController(viewportFraction: 0.92),
                itemBuilder: (context, index) {
                  final isFirst = index == 0;
                  final isLast = index == homeWallets.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: isFirst ? 0 : AppTheme.spacing8,
                      right: isLast ? 0 : AppTheme.spacing8,
                    ),
                    child: WalletCard(
                      wallet: homeWallets[index], 
                      showBalance: _walletBalanceVisibility[homeWallets[index].id] ?? true,
                      onShowBalanceChanged: (showBalance) => _onBalanceVisibilityChanged(homeWallets[index].id, showBalance),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacing4), // further reduced space between wallet card and quick actions
            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16, horizontal: AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.qr_code,
                        label: 'Request',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const RequestPaymentScreen()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.send,
                        label: 'Pay',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const PayScreen()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.account_balance_wallet,
                        label: 'Top Up',
                        onTap: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => const _TopUpSheet(),
                          );
                          if (result == true && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(message: 'Top up successful!'),
        );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.history,
                        label: 'Payouts',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const PayoutsScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            // Chart title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Text(
                'Cash In & Out (This Week)',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            // Area chart section with legends
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                  border: Border.all(color: AppTheme.thinBorderColor, width: AppTheme.thinBorderWidth),
                ),
                child: Container(
                  height: 162,
                  width: double.infinity,
                  child: DChartComboO(
                    groupList: [
                      OrdinalGroup(
                        id: 'Cash In',
                        data: [
                          OrdinalData(domain: 'Mon', measure: 120),
                          OrdinalData(domain: 'Tue', measure: 150),
                          OrdinalData(domain: 'Wed', measure: 100),
                          OrdinalData(domain: 'Thu', measure: 180),
                          OrdinalData(domain: 'Fri', measure: 90),
                          OrdinalData(domain: 'Sat', measure: 200),
                          OrdinalData(domain: 'Sun', measure: 170),
                        ],
                        color: AppTheme.primaryColor.withOpacity(0.85),
                        chartType: ChartType.bar,
                      ),
                      OrdinalGroup(
                        id: 'Cash Out',
                        data: [
                          OrdinalData(domain: 'Mon', measure: 80),
                          OrdinalData(domain: 'Tue', measure: 60),
                          OrdinalData(domain: 'Wed', measure: 120),
                          OrdinalData(domain: 'Thu', measure: 90),
                          OrdinalData(domain: 'Fri', measure: 110),
                          OrdinalData(domain: 'Sat', measure: 70),
                          OrdinalData(domain: 'Sun', measure: 130),
                        ],
                        color: Color(0xFFBDBDBD), // Gray
                        chartType: ChartType.bar,
                      ),
                    ],
                    animate: true,
                    domainAxis: DomainAxis(
                      showLine: true,
                      labelStyle: const LabelStyle(
                        color: AppTheme.textSecondaryColor, // Slightly lighter for reduced visibility
                        fontSize: 12, // Larger font size
                        fontWeight: FontWeight.w600, // Bold weight
                      ),
                    ),
                    measureAxis: MeasureAxis(
                      showLine: true,
                      labelStyle: const LabelStyle(
                        color: AppTheme.textSecondaryColor, // Slightly lighter for reduced visibility
                        fontSize: 12, // Larger font size
                        fontWeight: FontWeight.w600, // Bold weight
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            // Recent transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Text(
                'Recent Transactions',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            ...mockTransactions.map((tx) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: TransactionItem(transaction: tx),
            )),
          ],
        ),
      ),
    );
  }

  Color _getChartColor(String method) {
    switch (method) {
      case 'Mobile Money':
        return const Color(0xFF43A047); // green
      case 'Card':
        return const Color(0xFF1976D2); // blue
      case 'Bank':
        return const Color(0xFFFBC02D); // yellow
      case 'QR/USSD':
        return const Color(0xFF8E24AA); // purple
      default:
        return AppTheme.primaryColor;
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing4),
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: AppTheme.spacing8),
            Text(label, style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is a placeholder for $title.')),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Transactions'));
  }
}
class _WalletsTab extends StatelessWidget {
  const _WalletsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Wallets'));
  }
}
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
      data: (user) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppTheme.spacing32),
                          // Profile Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage: (user?.profileImg != null && user?.profileImg != ''
                                ? NetworkImage(user!.profileImg)
                                : (user?.profilePicture != null && user?.profilePicture != ''
                                  ? NetworkImage(user!.profilePicture)
                                  : null)) as ImageProvider<Object>?,
                              child: ((user?.profileImg == null || user?.profileImg == '') && (user?.profilePicture == null || user?.profilePicture == ''))
                                  ? Text(
                                      (user?.name != null && user?.name != '' ? user!.name[0].toUpperCase() : 'U'),
                                      style: AppTheme.headlineLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing16),
                          // User Name
                          Text(
                            user?.name ?? 'User',
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (user?.about != null && user?.about != '')
                            Padding(
                              padding: const EdgeInsets.only(top: AppTheme.spacing8),
                              child: Text(
                                user!.about,
                                style: AppTheme.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: 'Edit Profile',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppTheme.spacing16),
                      
                      // Account Information Section
                      _buildSection(
                        title: 'Account Information',
                        icon: Icons.account_circle_outlined,
                        children: [
                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            subtitle: user?.email ?? 'Not provided',
                            iconColor: AppTheme.primaryColor,
                          ),
                          if (user?.phoneNumber != null && user?.phoneNumber != '')
                            _buildInfoTile(
                              icon: Icons.phone_outlined,
                              title: 'Phone',
                              subtitle: user!.phoneNumber,
                              iconColor: AppTheme.successColor,
                            ),
                          if (user?.address != null && user?.address != '')
                            _buildInfoTile(
                              icon: Icons.location_on_outlined,
                              title: 'Address',
                              subtitle: user!.address,
                              iconColor: AppTheme.warningColor,
                            ),
                          _buildInfoTile(
                            icon: Icons.verified_user_outlined,
                            title: 'Status',
                            subtitle: (user?.isActive ?? false) ? 'Active' : 'Inactive',
                            iconColor: (user?.isActive ?? false) ? AppTheme.successColor : AppTheme.errorColor,
                            subtitleColor: (user?.isActive ?? false) ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                          _buildInfoTile(
                            icon: Icons.badge_outlined,
                            title: 'Role',
                            subtitle: user?.role ?? 'User',
                            iconColor: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing24),
                      
                      // Account Actions Section
                      _buildSection(
                        title: 'Account Actions',
                        icon: Icons.settings_outlined,
                        children: [
                          _buildActionTile(
                            icon: Icons.edit_outlined,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            subtitle: 'Update your account password',
                            onTap: () {
                              // TODO: Implement change password
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppTheme.infoSnackBar(message: 'Change password feature coming soon'),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing24),
                      
                      // Support & Settings Section
                      _buildSection(
                        title: 'Support & Settings',
                        icon: Icons.help_outline,
                        children: [
                          _buildActionTile(
                            icon: Icons.info_outline,
                            title: 'About',
                            subtitle: 'Learn more about the app',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AboutScreen(),
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact support',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HelpSupportScreen(),
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage your notifications',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            subtitle: 'App preferences and configuration',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing24),
                      
                      // Account Management Section
                      _buildSection(
                        title: 'Account Management',
                        icon: Icons.security_outlined,
                        children: [
                          _buildActionTile(
                            icon: Icons.logout,
                            title: 'Logout',
                            subtitle: 'Sign out of your account',
                            onTap: () async {
                              await ref.read(authProvider.notifier).signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            textColor: AppTheme.warningColor,
                          ),
                          _buildActionTile(
                            icon: Icons.delete_forever,
                            title: 'Delete Account',
                            subtitle: 'Permanently delete your account',
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppTheme.surfaceColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning, color: AppTheme.errorColor),
                                      const SizedBox(width: AppTheme.spacing8),
                                      Text(
                                        'Delete Account',
                                        style: AppTheme.titleMedium.copyWith(color: AppTheme.errorColor),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                    style: AppTheme.bodyMedium,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text(
                                        'Cancel',
                                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text(
                                        'Delete',
                                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                try {
                                  await ref.read(authProvider.notifier).deleteAccount();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      AppTheme.errorSnackBar(message: 'Error: $e'),
                                    );
                                  }
                                }
                              }
                            },
                            textColor: AppTheme.errorColor,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        border: Border.all(color: AppTheme.thinBorderColor, width: AppTheme.thinBorderWidth),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  title,
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Color? subtitleColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.thinBorderColor,
            width: AppTheme.thinBorderWidth,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodySmall.copyWith(
            color: subtitleColor ?? AppTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.thinBorderColor,
            width: AppTheme.thinBorderWidth,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: (textColor ?? AppTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
          ),
          child: Icon(icon, color: textColor ?? AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodySmall.copyWith(
            color: textColor?.withOpacity(0.7) ?? AppTheme.textSecondaryColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: textColor ?? AppTheme.textSecondaryColor,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _TopUpSheet extends StatefulWidget {
  const _TopUpSheet();
  @override
  State<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<_TopUpSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String? _selectedMethod = 'Mobile Money';
  final List<String> _methods = ['Mobile Money', 'Card', 'Bank'];

  // Mock wallets (same as homeWallets)
  final List<Wallet> _wallets = [
    Wallet(
      id: 'WALLET-1',
      name: 'Main Wallet',
      balance: 250000,
      currency: 'RWF',
      type: 'individual',
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      owners: ['You'],
      isDefault: true,
    ),
    Wallet(
      id: 'WALLET-2',
      name: 'Joint Wallet',
      balance: 1200000,
      currency: 'RWF',
      type: 'joint',
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      owners: ['You', 'Alice', 'Eric'],
      isDefault: false,
    ),
    Wallet(
      id: 'WALLET-3',
      name: 'Vacation Fund',
      balance: 350000,
      currency: 'RWF',
      type: 'individual',
      status: 'inactive',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      owners: ['You'],
      isDefault: false,
      description: 'Vacation savings',
      targetAmount: 500000,
      targetDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];
  Wallet? _selectedWallet;

  @override
  void initState() {
    super.initState();
    _selectedWallet = _wallets.firstWhere((w) => w.isDefault, orElse: () => _wallets.first);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(left: AppTheme.spacing16, right: AppTheme.spacing16, bottom: bottom + AppTheme.spacing16, top: AppTheme.spacing16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Top Up Wallet', style: AppTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.spacing16),
            Text('To Wallet', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppTheme.spacing8),
            DropdownButtonFormField<Wallet>(
              value: _selectedWallet,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(),
              ),
              items: _wallets.map((w) => DropdownMenuItem(
                value: w,
                child: Text('${w.name} (${w.balance.toStringAsFixed(0)} ${w.currency})'),
              )).toList(),
              onChanged: (w) => setState(() => _selectedWallet = w),
              validator: (w) => w == null ? 'Select a wallet' : null,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text('Amount', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppTheme.spacing8),
            TextFormField(
              controller: _amountController,
              style: AppTheme.bodySmall,
              decoration: const InputDecoration(
                hintText: 'Enter amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount required';
                final n = num.tryParse(v);
                if (n == null || n <= 0) return 'Enter a valid amount';
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text('Payment Method', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppTheme.spacing8),
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.payment),
                border: OutlineInputBorder(),
              ),
              items: _methods.map((m) => DropdownMenuItem(
                value: m,
                child: Text(m),
              )).toList(),
              onChanged: (m) => setState(() => _selectedMethod = m),
              validator: (m) => m == null ? 'Select a method' : null,
            ),
            const SizedBox(height: AppTheme.spacing16),
            PrimaryButton(
              label: 'Submit',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ),
            const SizedBox(height: AppTheme.actionSheetBottomSpacing),
          ],
        ),
      ),
    );
  }
} 