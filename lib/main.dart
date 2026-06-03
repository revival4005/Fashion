import 'package:flutter/material.dart';

void main() {
  runApp(const FashionMvpApp());
}

class FashionMvpApp extends StatefulWidget {
  const FashionMvpApp({super.key});

  @override
  State<FashionMvpApp> createState() => _FashionMvpAppState();
}

class _FashionMvpAppState extends State<FashionMvpApp> {
  final CartModel cart = CartModel();
  final OrderHistory orderHistory = OrderHistory();
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      isDarkMode: isDarkMode,
      onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      child: CartScope(
        cart: cart,
        onChanged: () => setState(() {}),
        child: OrderScope(
          orderHistory: orderHistory,
          onChanged: () => setState(() {}),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lulu Fashion MVP',
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: appTheme(Brightness.light),
            darkTheme: appTheme(Brightness.dark),
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}

ThemeData appTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF176B5B),
    brightness: brightness,
    primary: const Color(0xFF176B5B),
    secondary: const Color(0xFFE15A3D),
    surface: isDark ? const Color(0xFF151216) : const Color(0xFFFFFBF7),
  );

  return ThemeData(
    colorScheme: colorScheme,
    fontFamily: 'Arial',
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF151216) : const Color(0xFFFFFBF7),
    appBarTheme: AppBarTheme(
      backgroundColor:
          isDark ? const Color(0xFF151216) : const Color(0xFFFFFBF7),
      foregroundColor: isDark ? Colors.white : const Color(0xFF17121A),
      elevation: 0,
    ),
    cardColor: isDark ? const Color(0xFF211B23) : Colors.white,
    useMaterial3: true,
  );
}

class ThemeScope extends InheritedWidget {
  const ThemeScope({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required super.child,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  static ThemeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope was not found.');
    return scope!;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.sizes,
  });

  final int id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String imageUrl;
  final List<String> sizes;
}

class CartItem {
  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  final Product product;
  final String size;
  int quantity;
}

class Order {
  const Order({
    required this.number,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.total,
    required this.itemCount,
    required this.status,
    required this.createdAt,
  });

  final String number;
  final String customerName;
  final String phone;
  final String address;
  final int total;
  final int itemCount;
  final String status;
  final DateTime createdAt;
}

class CartModel {
  final List<CartItem> items = [];

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  void add(Product product, String size) {
    final index = items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index == -1) {
      items.add(CartItem(product: product, size: size));
    } else {
      items[index].quantity++;
    }
  }

  void increase(CartItem item) {
    item.quantity++;
  }

  void decrease(CartItem item) {
    if (item.quantity == 1) {
      items.remove(item);
    } else {
      item.quantity--;
    }
  }

  void clear() {
    items.clear();
  }
}

class OrderHistory {
  final List<Order> orders = [];

  void add(Order order) {
    orders.insert(0, order);
  }
}

class CartScope extends InheritedWidget {
  const CartScope({
    super.key,
    required this.cart,
    required this.onChanged,
    required super.child,
  });

  final CartModel cart;
  final VoidCallback onChanged;

  static CartScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope was not found.');
    return scope!;
  }

  @override
  bool updateShouldNotify(CartScope oldWidget) => true;
}

class OrderScope extends InheritedWidget {
  const OrderScope({
    super.key,
    required this.orderHistory,
    required this.onChanged,
    required super.child,
  });

  final OrderHistory orderHistory;
  final VoidCallback onChanged;

  static OrderScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OrderScope>();
    assert(scope != null, 'OrderScope was not found.');
    return scope!;
  }

  @override
  bool updateShouldNotify(OrderScope oldWidget) => true;
}

const categories = ['All', 'Trousers', 'Bags', 'Shoes', 'Dresses'];

const products = [
  Product(
    id: 1,
    name: 'Wide Leg Trousers',
    category: 'Trousers',
    price: 55000,
    description: 'Easy tailored trousers for office days and dinner plans.',
    imageUrl:
        'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=900&q=80',
    sizes: ['S', 'M', 'L', 'XL'],
  ),
  Product(
    id: 2,
    name: 'Mini Shoulder Bag',
    category: 'Bags',
    price: 42000,
    description: 'Compact everyday bag with enough room for the essentials.',
    imageUrl:
        'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?auto=format&fit=crop&w=900&q=80',
    sizes: ['One size'],
  ),
  Product(
    id: 3,
    name: 'Block Heel Sandals',
    category: 'Shoes',
    price: 68000,
    description: 'Comfortable block heels made for long events and weekends.',
    imageUrl:
        'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=900&q=80',
    sizes: ['37', '38', '39', '40', '41'],
  ),
  Product(
    id: 4,
    name: 'Wrap Midi Dress',
    category: 'Dresses',
    price: 79000,
    description: 'A polished wrap dress with a soft waist tie and clean drape.',
    imageUrl:
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=900&q=80',
    sizes: ['S', 'M', 'L'],
  ),
  Product(
    id: 5,
    name: 'Canvas Tote Bag',
    category: 'Bags',
    price: 32000,
    description: 'A roomy tote for errands, market days, and daily carry.',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
    sizes: ['One size'],
  ),
  Product(
    id: 6,
    name: 'Pleated Day Dress',
    category: 'Dresses',
    price: 72000,
    description:
        'Light pleats and a simple neckline for a dressed-up day look.',
    imageUrl:
        'https://images.unsplash.com/photo-1566479179817-c0f4c2f1b4b1?auto=format&fit=crop&w=900&q=80',
    sizes: ['S', 'M', 'L', 'XL'],
  ),
];

String money(int amount) => 'TZS ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    )}';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checkroom, size: 72, color: Color(0xFF176B5B)),
            SizedBox(height: 16),
            Text(
              'Lulu Fashion',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text('MVP shopping flow'),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scope = CartScope.of(context);
    final pages = [
      const HomeScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: selectedIndex,
        cartCount: scope.cart.totalItems,
        onSelected: (index) {
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.cartCount,
    required this.onSelected,
  });

  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onSelected;

  static const items = [
    (Icons.storefront_outlined, Icons.storefront, 'Shop'),
    (Icons.shopping_bag_outlined, Icons.shopping_bag, 'Cart'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
    (Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF17121A),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: AppBottomNavItem(
                    icon: items[index].$1,
                    selectedIcon: items[index].$2,
                    label: items[index].$3,
                    selected: selectedIndex == index,
                    badgeCount: index == 1 ? cartCount : 0,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavItem extends StatelessWidget {
  const AppBottomNavItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF17121A) : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF7E6DD) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Badge.count(
                  count: badgeCount,
                  isLabelVisible: badgeCount > 0,
                  child: Icon(selected ? selectedIcon : icon, color: color),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFFF7E6DD) : Colors.white70,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  bool isSearching = false;
  final searchController = TextEditingController();

  List<Product> get visibleProducts {
    final query = searchController.text.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = CartScope.of(context);
    final themeScope = ThemeScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lulu Fashion'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            icon: Badge.count(
              count: scope.cart.totalItems,
              isLabelVisible: scope.cart.totalItems > 0,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Curated outfits and daily fashion picks'),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: isSearching ? 'Close search' : 'Search',
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                    }
                  });
                },
                icon: Icon(isSearching ? Icons.close : Icons.search),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: themeScope.isDarkMode
                    ? 'Use light theme'
                    : 'Use dark theme',
                onPressed: themeScope.onToggleTheme,
                icon: Icon(
                  themeScope.isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
              ),
            ],
          ),
          if (isSearching) ...[
            const SizedBox(height: 14),
            TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search dresses, bags, shoes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          setState(searchController.clear);
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: 20),
          const FeaturedLookCard(),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          if (visibleProducts.isEmpty)
            const EmptyState(
              icon: Icons.search_off,
              title: 'No products found',
              message: 'Try another search or choose a different category.',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.61,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: visibleProducts[index]);
              },
            ),
        ],
      ),
    );
  }
}

class FeaturedLookCard extends StatelessWidget {
  const FeaturedLookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/featured_look.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xEE17121A), Color(0x2217121A)],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Featured fit',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Styled Look',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'A complete outfit, already worn and ready to shop.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ProductImage(imageUrl: product.imageUrl)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Color(0xFFE15A3D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    money(product.price),
                    style: const TextStyle(
                      color: Color(0xFFE15A3D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF1E7DF),
          alignment: Alignment.center,
          child: const Icon(Icons.checkroom, color: Color(0xFF176B5B)),
        );
      },
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String selectedSize = widget.product.sizes.first;

  @override
  Widget build(BuildContext context) {
    final scope = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              scope.cart.add(widget.product, selectedSize);
              scope.onChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
        ),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ProductImage(imageUrl: widget.product.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  money(widget.product.price),
                  style: const TextStyle(
                    color: Color(0xFFE15A3D),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(widget.product.description),
                const SizedBox(height: 24),
                const Text(
                  'Size',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: widget.product.sizes.map((size) {
                    return ChoiceChip(
                      label: Text(size),
                      selected: selectedSize == size,
                      onSelected: (_) => setState(() => selectedSize = size),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CartScope.of(context);
    final cart = scope.cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add a product to continue the MVP checkout flow.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final item in cart.items) ...[
                  CartItemRow(
                    item: item,
                    onIncrease: () {
                      cart.increase(item);
                      scope.onChanged();
                    },
                    onDecrease: () {
                      cart.decrease(item);
                      scope.onChanged();
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 4),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  ),
                  child: Text('Checkout - ${money(cart.totalPrice)}'),
                ),
              ],
            ),
    );
  }
}

class CartItemRow extends StatelessWidget {
  const CartItemRow({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 72,
              height: 72,
              child: ProductImage(imageUrl: item.product.imageUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text('Size: ${item.size}'),
                const SizedBox(height: 4),
                Text(money(item.product.price)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease quantity',
                onPressed: onDecrease,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${item.quantity}'),
              IconButton(
                tooltip: 'Increase quantity',
                onPressed: onIncrease,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = CartScope.of(context);
    final orderScope = OrderScope.of(context);
    final cart = scope.cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Guest checkout',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Login can be added later for order history and saved addresses.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer name',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'M-Pesa phone number',
                hintText: 'Example: 255712345678',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: addressController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Delivery address',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),
            const SizedBox(height: 20),
            OrderSummary(total: cart.totalPrice),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final order = Order(
                  number: 'LF-${DateTime.now().millisecondsSinceEpoch}',
                  customerName: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                  total: cart.totalPrice,
                  itemCount: cart.totalItems,
                  status: 'Pending',
                  createdAt: DateTime.now(),
                );

                orderScope.orderHistory.add(order);
                cart.clear();
                orderScope.onChanged();
                scope.onChanged();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => OrderConfirmedScreen(order: order),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.phone_android),
              label: const Text('Place Order with M-Pesa'),
            ),
          ],
        ),
      ),
    );
  }
}

String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required for MVP checkout';
  }
  return null;
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Order total',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            money(total),
            style: const TextStyle(
              color: Color(0xFFE15A3D),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 88,
                color: Color(0xFF176B5B),
              ),
              const SizedBox(height: 18),
              const Text(
                'Order confirmed',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                'Order ${order.number} is pending payment confirmation.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${money(order.total)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderScope.of(context).orderHistory.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message:
                  'Placed orders will show here with Pending, Shipped, and Delivered status.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return OrderRow(order: orders[index]);
              },
            ),
    );
  }
}

class OrderRow extends StatelessWidget {
  const OrderRow({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.number,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 10),
          Text('${order.itemCount} item(s) - ${money(order.total)}'),
          const SizedBox(height: 6),
          Text(
            'Delivery to ${order.address}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF176B5B).withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF176B5B),
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'Personal account details for the shopper.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF17121A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFFFEEF4),
                  child: Text(
                    'GS',
                    style: TextStyle(
                      color: Color(0xFFE15A3D),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest Shopper',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Not signed in yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Profile Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          const ProfileRow(
            icon: Icons.badge_outlined,
            title: 'Full name',
            subtitle: 'Guest Shopper',
          ),
          const ProfileRow(
            icon: Icons.phone_outlined,
            title: 'Phone number',
            subtitle: 'Add a phone number after login',
          ),
          const ProfileRow(
            icon: Icons.mail_outline,
            title: 'Email',
            subtitle: 'Add an email after login',
          ),
          const ProfileRow(
            icon: Icons.lock_outline,
            title: 'Account status',
            subtitle: 'Guest account',
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFE15A3D)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: const Color(0xFF176B5B)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
