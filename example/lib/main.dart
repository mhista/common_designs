import 'package:common_designs/common_designs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendor Design System v1.1.0',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System v1.1.0'),
        // subtitle: const Text('60+ Animation Components'),
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            AppToast.success(context, 'Refreshed!');
          }
        },
        child: AnimatedListView(
          padding: AppSpacing.allSM,
          itemCount: _examples.length,
          itemBuilder: (context, index) {
            final example = _examples[index];
            return Pressable(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => example.screen),
              ),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: AppSpacing.allSM,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: example.color.withOpacity(0.1),
                          borderRadius: AppBorderRadius.sm,
                        ),
                        child: Icon(
                          example.icon,
                          color: example.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  example.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                if (example.isNew) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: AppBorderRadius.xs,
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              example.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Example {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget screen;
  final bool isNew;

  Example({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.screen,
    this.isNew = false,
  });
}

final List<Example> _examples = [
  Example(
    title: 'Buttons & Interactions',
    description: 'Pressable, like, shake, bounce animations',
    icon: Icons.touch_app,
    color: AppColors.primary,
    screen: const ButtonsExample(),
  ),
  Example(
    title: 'Loading States',
    description: 'Pull-to-refresh, skeleton, swipe actions',
    icon: Icons.refresh,
    color: AppColors.info,
    screen: const LoadingExample(),
    isNew: true,
  ),
  // Example(
  //   title: 'Hero & Progress',
  //   description: 'Transitions, counters, progress bars',
  //   icon: Icons.trending_up,
  //   color: AppColors.success,
  //   screen: const HeroProgressExample(),
  //   isNew: true,
  // ),
  Example(
    title: 'Notifications',
    description: 'Toasts, badges, confetti celebrations',
    icon: Icons.notifications_active,
    color: AppColors.warning,
    screen: const NotificationExample(),
    isNew: true,
  ),
  Example(
    title: 'Modal Animations',
    description: 'Bottom sheets with margins',
    icon: Icons.layers,
    color: AppColors.accent,
    screen: const ModalExample(),
  ),
  Example(
    title: 'Chat Suggestions',
    description: 'Auto-staggering suggestion chips',
    icon: Icons.chat,
    color: AppColors.primary,
    screen: const ChatExample(),
  ),
  Example(
    title: 'Typography',
    description: 'All text styles and fonts',
    icon: Icons.text_fields,
    color: Colors.purple,
    screen: const TypographyExample(),
  ),
  Example(
    title: 'Colors',
    description: 'Color palette and gradients',
    icon: Icons.palette,
    color: Colors.pink,
    screen: const ColorsExample(),
  ),
];

// Example screens implementations would go here...
// (ButtonsExample, LoadingExample, HeroProgressExample, NotificationExample, etc.)
// I'll include a few key ones:

class LoadingExample extends StatefulWidget {
  const LoadingExample({super.key});

  @override
  State<LoadingExample> createState() => _LoadingExampleState();
}

class _LoadingExampleState extends State<LoadingExample> {
  bool _isLoading = false;
  final List<String> _items = List.generate(8, (i) => 'Item ${i + 1}');

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _items.insert(0, 'New Item ${_items.length + 1}');
      _isLoading = false;
    });
    if (mounted) {
      AppToast.success(context, 'Added new item!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading States'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () =>
                AppToast.info(context, 'Pull down to refresh or swipe items'),
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: _refresh,
        child: _isLoading
            ? ListView.builder(
                padding: AppSpacing.allSM,
                itemCount: 5,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SkeletonCard(),
                ),
              )
            : ListView.builder(
                padding: AppSpacing.allSM,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return SwipeableListItem(
                    onDelete: () {
                      final item = _items[index];
                      setState(() => _items.removeAt(index));
                      AppToast.error(context, '$item deleted');
                    },
                    onArchive: () {
                      AppToast.info(context, '${_items[index]} archived');
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(_items[index]),
                        subtitle: const Text(
                          'Swipe left to delete, right to archive',
                        ),
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class NotificationExample extends StatefulWidget {
  const NotificationExample({super.key});

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  int _badgeCount = 5;
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          AnimatedBadge(
            count: _badgeCount,
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                setState(() => _badgeCount = 0);
                AppSnackbar.show(
                  context: context,
                  message: 'All notifications read',
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ConfettiAnimation(
        trigger: _showConfetti,
        child: ListView(
          padding: AppSpacing.allLG,
          children: [
            Text(
              'Toast Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => AppToast.success(context, 'Order placed!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Success'),
                ),
                ElevatedButton(
                  onPressed: () => AppToast.error(context, 'Connection failed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text('Error'),
                ),
                ElevatedButton(
                  onPressed: () => AppToast.warning(context, 'Low storage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                  ),
                  child: const Text('Warning'),
                ),
                ElevatedButton(
                  onPressed: () => AppToast.info(context, 'Update available'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                  ),
                  child: const Text('Info'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Badge & Indicators',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    AnimatedBadge(
                      count: _badgeCount,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppBorderRadius.md,
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$_badgeCount items'),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 32,
                            ),
                          ),
                          const Positioned(
                            right: 2,
                            top: 2,
                            child: PulsingDot(color: Colors.green, size: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Online'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _badgeCount++),
              child: const Text('Add Notification'),
            ),
            const SizedBox(height: 32),
            Text('Celebration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _showConfetti = true);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted) setState(() => _showConfetti = false);
                  });
                  AppToast.success(context, '🎉 Congratulations!');
                },
                icon: const Icon(Icons.celebration),
                label: const Text('Celebrate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add other example classes (ButtonsExample, HeroProgressExample, etc.)
// Due to length, showing key ones. Full implementation available on request.

// Example Screens
class ButtonsExample extends StatefulWidget {
  const ButtonsExample({super.key});

  @override
  State<ButtonsExample> createState() => _ButtonsExampleState();
}

class _ButtonsExampleState extends State<ButtonsExample> {
  bool isLiked = false;
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons & Interactions')),
      body: ListView(
        padding: AppSpacing.allLG,
        children: [
          Text(
            'Pressable Button',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Pressable(
            onPressed: () {},
            child: Container(
              padding: AppSpacing.allSM,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppBorderRadius.md,
              ),
              child: Center(
                child: Text(
                  'Press Me',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text('Like Button', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Center(
            child: LikeButton(
              isLiked: isLiked,
              onTap: () => setState(() => isLiked = !isLiked),
              likedColor: AppColors.like,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Shake Animation (Error)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ShakeWidget(
            shake: hasError,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: hasError ? 'Invalid email' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => hasError = !hasError),
            child: Text(hasError ? 'Clear Error' : 'Show Error'),
          ),
        ],
      ),
    );
  }
}

class ModalExample extends StatelessWidget {
  const ModalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modal Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppModals.showDraggableBottomSheet(
                  context: context,
                  child: const AppModalSheet(
                    title: 'Example Modal',
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'This is a modal with margins at the bottom!',
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Show Modal with Margin'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                AppModals.showAlertDialog(
                  context: context,
                  title: 'Confirm',
                  content: 'Are you sure?',
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
              child: const Text('Show Alert Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatExample extends StatefulWidget {
  const ChatExample({super.key});

  @override
  State<ChatExample> createState() => _ChatExampleState();
}

class _ChatExampleState extends State<ChatExample> {
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = true;
  String suggestedText = '';

  final List<String> _suggestions = [
    'Hello! How can I help?',
    'Track my order',
    'Return policy',
    'Contact support',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showSuggestions = _controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Suggestions')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                _showSuggestions
                    ? 'Suggestions shown below'
                    : 'Start typing to hide suggestions',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          if (suggestedText.isNotEmpty)
            AnimatedChatMessage(
              message: suggestedText,
              isUser: _suggestions[1] == suggestedText,
              index: 1,
            ),
          AnimatedSize(
            duration: AnimationConfigs.medium,
            child: _showSuggestions
                ? Padding(
                    padding: AppSpacing.allSM,
                    child: ChatSuggestions(
                      animationDuration: AnimationConfigs.verySlow,
                      suggestions: _suggestions,
                      show: _showSuggestions,
                      onSuggestionTapped: (suggestion) {
                        _controller.text = suggestion;
                        suggestedText = suggestion;
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Container(
            padding: AppSpacing.allSM,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: AppShadows.small,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _controller.clear(),
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypographyExample extends StatelessWidget {
  const TypographyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: ListView(
        padding: AppSpacing.allLG,
        children: [
          Text('Display Large', style: AppTypography.displayLarge()),
          Text('Display Medium', style: AppTypography.displayMedium()),
          Text('Display Small', style: AppTypography.displaySmall()),
          const Divider(height: 32),
          Text('Headline Large', style: AppTypography.headlineLarge()),
          Text('Headline Medium', style: AppTypography.headlineMedium()),
          Text('Headline Small', style: AppTypography.headlineSmall()),
          const Divider(height: 32),
          Text('Title Large', style: AppTypography.titleLarge()),
          Text('Title Medium', style: AppTypography.titleMedium()),
          Text('Title Small', style: AppTypography.titleSmall()),
          const Divider(height: 32),
          Text('Body Large', style: AppTypography.bodyLarge()),
          Text('Body Medium', style: AppTypography.bodyMedium()),
          Text('Body Small', style: AppTypography.bodySmall()),
          const Divider(height: 32),
          Text('Label Large', style: AppTypography.labelLarge()),
          Text('Label Medium', style: AppTypography.labelMedium()),
          Text('Label Small', style: AppTypography.labelSmall()),
          const Divider(height: 32),
          Text('\$55.00', style: AppTypography.price()),
          Text('\$120.00', style: AppTypography.inputLabel()),
          Text('4.8 ★', style: AppTypography.rating()),
        ],
      ),
    );
  }
}

class ColorsExample extends StatelessWidget {
  const ColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: AppSpacing.allLG,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          _ColorBox('Primary', AppColors.primary),
          _ColorBox('Primary Dark', AppColors.primaryDark),
          _ColorBox('Primary Light', AppColors.primaryLight),
          _ColorBox('Accent', AppColors.accent),
          _ColorBox('Success', AppColors.success),
          _ColorBox('Error', AppColors.error),
          _ColorBox('Warning', AppColors.warning),
          _ColorBox('Info', AppColors.surfaceDark),
        ],
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorBox(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppBorderRadius.md,
        boxShadow: AppShadows.small,
      ),
      child: Center(
        child: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            shadows: [const Shadow(blurRadius: 4, color: Colors.black26)],
          ),
        ),
      ),
    );
  }
}
