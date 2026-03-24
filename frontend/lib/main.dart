import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CafeApp());
}

class CafeApp extends StatelessWidget {
  const CafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кафе "У Flutter"',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: const CategoriesScreen(),
    );
  }
}

// ==============================
// МОДЕЛЬ ДАННЫХ
// ==============================

class Dish {
  final String name;
  final String description;
  final double price;
  final String emoji;
  final List<String> ingredients;

  const Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.ingredients,
  });
}

class Category {
  final String name;
  final String emoji;
  final Color color;
  final List<Dish> dishes;

  const Category({
    required this.name,
    required this.emoji,
    required this.color,
    required this.dishes,
  });
}

// ==============================
// ДАННЫЕ МЕНЮ
// ==============================

final List<Category> menuData = [
  Category(
    name: 'Завтраки',
    emoji: '🍳',
    color: Colors.orange,
    dishes: [
      Dish(
        name: 'Омлет с сыром',
        description:
            'Пышный омлет из трёх яиц '
            'с тёртым сыром и зеленью.',
        price: 250,
        emoji: '🍳',
        ingredients: ['Яйца', 'Сыр', 'Молоко', 'Зелень'],
      ),
      Dish(
        name: 'Овсянка с ягодами',
        description:
            'Овсяная каша на молоке '
            'со свежими ягодами и мёдом.',
        price: 200,
        emoji: '🥣',
        ingredients: ['Овсянка', 'Молоко', 'Ягоды', 'Мёд'],
      ),
      Dish(
        name: 'Блинчики',
        description:
            'Тонкие блинчики с вареньем '
            'или сметаной на выбор.',
        price: 220,
        emoji: '🥞',
        ingredients: ['Мука', 'Яйца', 'Молоко', 'Варенье'],
      ),
    ],
  ),
  Category(
    name: 'Супы',
    emoji: '🍲',
    color: Colors.red,
    dishes: [
      Dish(
        name: 'Борщ',
        description:
            'Наваристый борщ со сметаной '
            'и чесночными пампушками.',
        price: 320,
        emoji: '🍲',
        ingredients: [
          'Свёкла', 'Капуста', 'Картофель',
          'Мясо', 'Сметана'
        ],
      ),
      Dish(
        name: 'Куриный бульон',
        description:
            'Лёгкий куриный бульон '
            'с лапшой и зеленью.',
        price: 280,
        emoji: '🍜',
        ingredients: ['Курица', 'Лапша', 'Морковь', 'Зелень'],
      ),
    ],
  ),
  // ==============================
  // ЗАДАНИЕ 1: Основные блюда
  // ==============================
  Category(
    name: 'Основные блюда',
    emoji: '🥩',
    color: Colors.teal,
    dishes: [
      Dish(
        name: 'Стейк из говядины',
        description:
            'Сочный стейк средней прожарки '
            'с гарниром из овощей гриль.',
        price: 650,
        emoji: '🥩',
        ingredients: [
          'Говядина', 'Перец', 'Розмарин',
          'Овощи гриль', 'Масло'
        ],
      ),
      Dish(
        name: 'Паста Карбонара',
        description:
            'Итальянская паста с беконом, '
            'сливочным соусом и пармезаном.',
        price: 420,
        emoji: '🍝',
        ingredients: [
          'Спагетти', 'Бекон', 'Сливки',
          'Пармезан', 'Яйцо'
        ],
      ),
      Dish(
        name: 'Куриная грудка на гриле',
        description:
            'Нежная куриная грудка с соусом '
            'песто и рисом на пару.',
        price: 380,
        emoji: '🍗',
        ingredients: [
          'Курица', 'Песто', 'Рис',
          'Базилик', 'Чеснок'
        ],
      ),
      Dish(
        name: 'Лосось запечённый',
        description:
            'Филе лосося, запечённое с лимоном '
            'и травами, подаётся с картофелем.',
        price: 580,
        emoji: '🐟',
        ingredients: [
          'Лосось', 'Лимон', 'Укроп',
          'Картофель', 'Сливочное масло'
        ],
      ),
    ],
  ),
  Category(
    name: 'Напитки',
    emoji: '☕',
    color: Colors.brown,
    dishes: [
      Dish(
        name: 'Капучино',
        description:
            'Классический капучино '
            'с молочной пенкой.',
        price: 180,
        emoji: '☕',
        ingredients: ['Эспрессо', 'Молоко'],
      ),
      Dish(
        name: 'Чай с лимоном',
        description:
            'Чёрный чай с долькой лимона '
            'и мёдом.',
        price: 120,
        emoji: '🍵',
        ingredients: ['Чай', 'Лимон', 'Мёд'],
      ),
      Dish(
        name: 'Морс',
        description:
            'Домашний ягодный морс '
            'из клюквы и брусники.',
        price: 150,
        emoji: '🧃',
        ingredients: ['Клюква', 'Брусника', 'Сахар'],
      ),
    ],
  ),
  Category(
    name: 'Десерты',
    emoji: '🍰',
    color: Colors.pink,
    dishes: [
      Dish(
        name: 'Чизкейк',
        description:
            'Нежный чизкейк с ягодным '
            'соусом.',
        price: 350,
        emoji: '🍰',
        ingredients: [
          'Сливочный сыр', 'Печенье',
          'Ягодный соус'
        ],
      ),
      Dish(
        name: 'Тирамису',
        description:
            'Итальянский десерт '
            'с маскарпоне и кофе.',
        price: 380,
        emoji: '🍮',
        ingredients: [
          'Маскарпоне', 'Савоярди', 'Кофе',
          'Какао'
        ],
      ),
    ],
  ),
];

// ==============================
// ЗАДАНИЕ 2: Корзина (глобальная переменная)
// ==============================

List<Map<String, dynamic>> cart = [];

// ==============================
// API-СЕРВИС ДЛЯ КОРЗИНЫ
// ==============================

class CartService {
  static String get _baseUrl => Uri.base.origin;

  static Future<List<Map<String, dynamic>>> getCart() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/cart'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Ошибка загрузки корзины: $e');
    }
    return [];
  }

  static Future<bool> addToCart(Map<String, dynamic> item) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Ошибка добавления в корзину: $e');
      return false;
    }
  }

  static Future<bool> clearCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/cart'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Ошибка очистки корзины: $e');
      return false;
    }
  }

  static Future<bool> removeFromCart(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/cart/$id'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Ошибка удаления из корзины: $e');
      return false;
    }
  }
}

// ==============================
// ЭКРАН 1: КАТЕГОРИИ (с поиском — Задание 3)
// ==============================

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _searchText = '';
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dish> _getFilteredDishes() {
    return menuData
        .expand((cat) => cat.dishes)
        .where((dish) => dish.name
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
        .toList();
  }

  Color _getCategoryColor(Dish dish) {
    for (final cat in menuData) {
      if (cat.dishes.contains(dish)) {
        return cat.color;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchText.isNotEmpty;
    final filteredDishes =
        isSearching ? _getFilteredDishes() : <Dish>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кафе "У Flutter"'),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Задание 3: Поле поиска
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск блюд...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchText = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          // Контент: результаты поиска или список категорий
          Expanded(
            child: isSearching
                ? _buildSearchResults(filteredDishes)
                : _buildCategoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Dish> dishes) {
    if (dishes.isEmpty) {
      return const Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        final color = _getCategoryColor(dish);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DishDetailScreen(
                    dish: dish,
                    categoryColor: color,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        dish.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dish.price.toInt()} \u20BD',
                          style: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: menuData.length,
      itemBuilder: (context, index) {
        final category = menuData[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Category category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DishesScreen(category: category),
            ),
          );
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                category.color.withOpacity(0.7),
                category.color.withOpacity(0.3),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  category.emoji,
                  style: const TextStyle(fontSize: 44),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category.dishes.length} позиций',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==============================
// ЭКРАН 2: СПИСОК БЛЮД
// ==============================

class DishesScreen extends StatelessWidget {
  final Category category;

  const DishesScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${category.emoji} ${category.name}'),
        backgroundColor:
            category.color.withOpacity(0.3),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: category.dishes.length,
        itemBuilder: (context, index) {
          final dish = category.dishes[index];
          return _buildDishCard(context, dish);
        },
      ),
    );
  }

  Widget _buildDishCard(
      BuildContext context, Dish dish) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DishDetailScreen(
                    dish: dish,
                    categoryColor: category.color,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: category.color
                      .withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    dish.emoji,
                    style: const TextStyle(
                        fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: category.color
                      .withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  '${dish.price.toInt()} \u20BD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: category.color,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==============================
// ЭКРАН 3: КАРТОЧКА БЛЮДА
// ==============================

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  final Color categoryColor;

  const DishDetailScreen({
    super.key,
    required this.dish,
    required this.categoryColor,
  });

  @override
  State<DishDetailScreen> createState() =>
      _DishDetailScreenState();
}

class _DishDetailScreenState
    extends State<DishDetailScreen> {
  int _quantity = 1;

  void _addToCart() async {
    final item = {
      'name': widget.dish.name,
      'price': widget.dish.price,
      'quantity': _quantity,
      'emoji': widget.dish.emoji,
    };

    // Сохраняем в локальную корзину
    cart.add(item);

    // Сохраняем на сервер для персистентности
    await CartService.addToCart(item);

    if (!mounted) return;

    final total = widget.dish.price * _quantity;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.dish.name}'
          ' x$_quantity'
          ' = ${total.toInt()} \u20BD'
          ' добавлено в заказ!',
        ),
        backgroundColor: widget.categoryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
        backgroundColor:
            widget.categoryColor.withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            // Большой баннер с эмодзи
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.categoryColor
                        .withOpacity(0.4),
                    widget.categoryColor
                        .withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  widget.dish.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),

            // Основная информация
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dish.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.dish.price.toInt()} \u20BD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.dish.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ингредиенты
                  const Text(
                    'Состав:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.dish.ingredients
                        .map(
                          (item) => Chip(
                            avatar: Icon(
                              Icons.check_circle,
                              size: 18,
                              color:
                                  widget.categoryColor,
                            ),
                            label: Text(item),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // Выбор количества
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                        icon: const Icon(
                            Icons.remove_circle_outline),
                        iconSize: 36,
                        color: widget.categoryColor,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        icon: const Icon(
                            Icons.add_circle_outline),
                        iconSize: 36,
                        color: widget.categoryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Кнопка заказа
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.categoryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'В заказ \u2014 '
                        '${(widget.dish.price * _quantity).toInt()} \u20BD',
                        style: const TextStyle(
                            fontSize: 18),
                      ),
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

// ==============================
// ЭКРАН 4: КОРЗИНА (Задание 2)
// ==============================

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    final items = await CartService.getCart();
    if (mounted) {
      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    }
  }

  double get _totalPrice {
    double total = 0;
    for (final item in _cartItems) {
      total += (item['price'] as num) *
          (item['quantity'] as num);
    }
    return total;
  }

  Future<void> _clearCart() async {
    await CartService.clearCart();
    cart.clear();
    if (mounted) {
      setState(() {
        _cartItems = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Корзина очищена'),
        ),
      );
    }
  }

  Future<void> _removeItem(int id, int index) async {
    await CartService.removeFromCart(id);
    if (mounted) {
      setState(() {
        _cartItems.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearCart,
              tooltip: 'Очистить корзину',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Корзина пуста',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Добавьте блюда из меню',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.all(16),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item =
                              _cartItems[index];
                          final itemTotal =
                              (item['price'] as num) *
                                  (item['quantity']
                                      as num);
                          return Card(
                            margin:
                                const EdgeInsets.only(
                                    bottom: 12),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                      12),
                              child: Row(
                                children: [
                                  Text(
                                    item['emoji'] ??
                                        '🍽',
                                    style:
                                        const TextStyle(
                                            fontSize:
                                                32),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          item['name'] ??
                                              '',
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 4),
                                        Text(
                                          '${(item['price'] as num).toInt()} \u20BD x ${item['quantity']}',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                14,
                                            color: Colors
                                                    .grey[
                                                600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${itemTotal.toInt()} \u20BD',
                                    style:
                                        const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color:
                                          Colors.brown,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color:
                                          Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      final id =
                                          item['id'];
                                      if (id != null) {
                                        _removeItem(
                                            id as int,
                                            index);
                                      } else {
                                        setState(() {
                                          _cartItems
                                              .removeAt(
                                                  index);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Итого
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset:
                                const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          const Text(
                            'Итого:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_totalPrice.toInt()} \u20BD',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
