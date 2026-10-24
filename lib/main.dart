
import 'package:flutter/material.dart';

void main() {
  runApp(const VillageCartApp());
}

class VillageCartApp extends StatelessWidget {
  const VillageCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VillageCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16834A),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final int price;
  final String emoji;

  const Product(
    this.name,
    this.category,
    this.price,
    this.emoji,
  );
}

const List<Product> products = [
  Product('Rice - 1 kg', 'Groceries', 60, '🍚'),
  Product('Cooking Oil - 1 L', 'Groceries', 145, '🫗'),
  Product('Biscuits', 'Groceries', 20, '🍪'),
  Product('Bath Soap', 'Household', 35, '🧼'),
  Product('Toothpaste', 'Household', 55, '🪥'),
  Product('Phone Charger', 'Electronics', 199, '🔌'),
  Product('Milk - 500 ml', 'Groceries', 30, '🥛'),
  Product('Bread', 'Groceries', 40, '🍞'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, int> cart = {};

  String category = 'All';
  String village = 'Select village';

  int get itemCount =>
      cart.values.fold(0, (total, quantity) => total + quantity);

  int get total => products.fold(
        0,
        (sum, product) =>
            sum + product.price * (cart[product.name] ?? 0),
      );

  void changeQuantity(Product product, int change) {
    setState(() {
      final quantity = (cart[product.name] ?? 0) + change;

      if (quantity <= 0) {
        cart.remove(product.name);
      } else {
        cart[product.name] = quantity;
      }
    });
  }

  void selectVillage() {
    const villages = [
      'Narasaraopet',
      'Ravipadu',
      'Palapadu',
      'Kakani',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                'Choose your village',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...villages.map(
              (place) => ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(place),
                onTap: () {
                  setState(() => village = place);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Cart ($itemCount items)',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (itemCount == 0)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Your cart is empty.'),
                  ),
                ...products
                    .where((p) => (cart[p.name] ?? 0) > 0)
                    .map(
                      (p) => ListTile(
                        title: Text(p.name),
                        subtitle: Text('₹${p.price} each'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                changeQuantity(p, -1);
                                refresh(() {});
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${cart[p.name]}'),
                            IconButton(
                              onPressed: () {
                                changeQuantity(p, 1);
                                refresh(() {});
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '₹$total',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: itemCount == 0
                        ? null
                        : () {
                            Navigator.pop(context);
                            showDialog(
                              context: this.context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Demo checkout'),
                                content: Text(
                                  'Your cart total is ₹$total. '
                                  'This is a demo. No real order or payment '
                                  'has been created.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: const Text('Continue to checkout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = products.where((product) {
      return category == 'All' || product.category == category;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_basket, color: Color(0xFF16834A)),
            SizedBox(width: 8),
            Text(
              'VillageCart',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: showCart,
            icon: Badge(
              isLabelVisible: itemCount > 0,
              label: Text('$itemCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF126C3D),
                          Color(0xFF2AAA68),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your village. Your shops.',
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Everyday essentials, delivered locally.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: ListTile(
                      onTap: selectVillage,
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF16834A),
                      ),
                      title: const Text('Delivering to'),
                      subtitle: Text(village),
                      trailing: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Shop essentials',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final value in [
                          'All',
                          'Groceries',
                          'Household',
                          'Electronics',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(value),
                              selected: category == value,
                              onSelected: (_) {
                                setState(() => category = value);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = visibleProducts[index];
                  final quantity = cart[product.name] ?? 0;

                  return Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                product.emoji,
                                style: const TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: Color(0xFF16834A),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '₹${product.price}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (quantity == 0)
                                IconButton.filled(
                                  onPressed: () =>
                                      changeQuantity(product, 1),
                                  icon: const Icon(Icons.add),
                                )
                              else ...[
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      changeQuantity(product, -1),
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
                                ),
                                Text('$quantity'),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      changeQuantity(product, 1),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: visibleProducts.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: itemCount == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: showCart,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text('View cart • $itemCount items • ₹$total'),
                ),
              ),
            ),
    );
  }
}
