import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// ================= MODEL MAKANAN =================

class FoodListing {
  final String name;
  final String category;
  final String description;
  final double originalPrice;
  final double discountPrice;
  final String pickupTime;
  final String emoji;
  int stock;

  FoodListing({
    required this.name,
    required this.category,
    required this.description,
    required this.originalPrice,
    required this.discountPrice,
    required this.pickupTime,
    required this.emoji,
    required this.stock,
  });
}

// ================= KATEGORI & EMOJI =================

const List<String> foodCategories = [
  'Makanan Berat',
  'Bakery',
  'Dessert',
  'Minuman',
  'Snack',
  'Lainnya',
];

String emojiForCategory(String category) {
  switch (category) {
    case 'Makanan Berat':
      return '🍱';
    case 'Bakery':
      return '🥐';
    case 'Dessert':
      return '🍰';
    case 'Minuman':
      return '🥤';
    case 'Snack':
      return '🍿';
    default:
      return '🍽️';
  }
}

// ================= APLIKASI UTAMA =================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SisaRasa',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF238B68),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F8F5),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final List<FoodListing> foods = [
    FoodListing(
      name: 'Nasi Ayam Teriyaki',
      category: 'Makanan Berat',
      description:
          'Nasi dengan ayam teriyaki dan sayuran segar. '
          'Dijual dengan harga spesial karena stok berlebih.',
      originalPrice: 30000,
      discountPrice: 15000,
      pickupTime: '19.00 - 20.00',
      emoji: '🍱',
      stock: 5,
    ),
    FoodListing(
      name: 'Roti Cokelat',
      category: 'Bakery',
      description:
          'Roti lembut dengan isian cokelat yang lezat. '
          'Masih layak dikonsumsi dan dikemas dengan baik.',
      originalPrice: 15000,
      discountPrice: 7000,
      pickupTime: '18.00 - 19.00',
      emoji: '🥐',
      stock: 8,
    ),
    FoodListing(
      name: 'Donat Premium',
      category: 'Dessert',
      description:
          'Donat dengan topping cokelat dan keju. '
          'Tersedia dengan harga diskon menjelang toko tutup.',
      originalPrice: 20000,
      discountPrice: 10000,
      pickupTime: '20.00 - 21.00',
      emoji: '🍩',
      stock: 4,
    ),
  ];

  String searchText = '';

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> openAddFood() async {
    final newFood = await Navigator.push<FoodListing>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFoodScreen(),
      ),
    );

    // Pastikan widget masih aktif sebelum memakai context lagi
    if (!mounted) return;

    if (newFood != null) {
      setState(() {
        foods.add(newFood);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Makanan berhasil dipublikasikan!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = foods.where((food) {
      return food.name.toLowerCase().contains(
        searchText.toLowerCase(),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Text(
              'SisaRasa',
              style: GoogleFonts.kaushanScript(
                fontSize: 28,
                color: const Color(0xFF238B68),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openAddFood,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah makanan',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF238B68),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di SisaRasa!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nikmati makanan berkualitas dengan '
                    'harga lebih hemat dan bantu kurangi '
                    'pemborosan makanan.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Temukan Makanan',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // SEARCH
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DAFTAR MAKANAN
            if (filteredFoods.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'Belum ada makanan tersedia.',
                  ),
                ),
              ),

            ...filteredFoods.map((food) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        food: food,
                        formatRupiah: formatRupiah,
                        onReserved: () {
                          setState(() {
                            food.stock--;
                          });
                        },
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      // EMOJI MAKANAN
                      Container(
                        width: 85,
                        height: 85,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F4ED),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          food.emoji,
                          style: const TextStyle(fontSize: 43),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              food.category,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              formatRupiah(food.discountPrice),
                              style: const TextStyle(
                                color: Color(0xFF238B68),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              'Stok: ${food.stock}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 15),

            // TOMBOL TAMBAH MAKANAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openAddFood,
                icon: const Icon(Icons.add),
                label: const Text('Jual Makanan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238B68),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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

// ================= HALAMAN DETAIL & RESERVASI =================

class DetailScreen extends StatefulWidget {
  final FoodListing food;
  final String Function(double) formatRupiah;
  final VoidCallback onReserved;

  const DetailScreen({
    super.key,
    required this.food,
    required this.formatRupiah,
    required this.onReserved,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  void reserveFood() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (widget.food.stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maaf, stok makanan sudah habis.'),
        ),
      );
      return;
    }

    widget.onReserved();

    setState(() {});

    final code = DateTime.now()
        .millisecondsSinceEpoch
        .toString()
        .substring(7);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Reservasi Berhasil!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF238B68),
                size: 65,
              ),
              const SizedBox(height: 12),
              Text(
                'Terima kasih, ${nameController.text}!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text('Kode Pengambilan Anda:'),
              const SizedBox(height: 8),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF238B68),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tunjukkan kode ini kepada penjual '
                'saat mengambil pesanan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // GAMBAR MAKANAN
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F4ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  food.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              food.name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              food.category,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Text(
              widget.formatRupiah(food.discountPrice),
              style: const TextStyle(
                fontSize: 25,
                color: Color(0xFF238B68),
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Harga normal: ${widget.formatRupiah(food.originalPrice)}',
              style: const TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Deskripsi Produk',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(food.description),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF238B68),
                ),
                const SizedBox(width: 8),
                Text('Jam pengambilan: ${food.pickupTime}'),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF238B68),
                ),
                const SizedBox(width: 8),
                Text('Stok tersedia: ${food.stock}'),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Form Reservasi',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pembeli',
                      hintText: 'Masukkan nama Anda',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama pembeli wajib diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: food.stock > 0
                          ? reserveFood
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF238B68),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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

// ================= HALAMAN TAMBAH MAKANAN =================

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  String? selectedCategory;
  final descriptionController = TextEditingController();
  final originalPriceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final stockController = TextEditingController();
  final pickupController = TextEditingController();

  void publishFood() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final originalPrice =
        double.tryParse(originalPriceController.text);

    final discountPrice =
        double.tryParse(discountPriceController.text);

    final stock = int.tryParse(stockController.text);

    if (originalPrice == null ||
        discountPrice == null ||
        stock == null) {
      return;
    }

    final category = selectedCategory;
    if (category == null) {
      return;
    }

    final newFood = FoodListing(
      name: nameController.text.trim(),
      category: category,
      description: descriptionController.text.trim(),
      originalPrice: originalPrice,
      discountPrice: discountPrice,
      pickupTime: pickupController.text.trim(),
      emoji: emojiForCategory(category),
      stock: stock,
    );

    Navigator.pop(context, newFood);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    originalPriceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    pickupController.dispose();
    super.dispose();
  }

  Widget buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }
    return null;
  }

  String? positiveNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }

    final number = double.tryParse(value);

    if (number == null || number <= 0) {
      return 'Masukkan angka yang valid dan lebih dari 0';
    }

    return null;
  }

  String? stockValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stok wajib diisi';
    }

    final number = int.tryParse(value);

    if (number == null || number <= 0) {
      return 'Stok harus berupa bilangan bulat positif';
    }

    return null;
  }

  String? discountValidator(String? value) {
    final result = positiveNumberValidator(value);

    if (result != null) return result;

    final original = double.tryParse(originalPriceController.text);
    final discount = double.tryParse(value!);

    if (original != null &&
        discount != null &&
        discount >= original) {
      return 'Harga diskon harus lebih rendah dari harga normal';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Publikasikan Makanan',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Isi informasi makanan yang ingin '
                'dijual agar dapat ditemukan pembeli.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 22),

              buildInput(
                label: 'Nama Makanan',
                hint: 'Contoh: Nasi Ayam',
                controller: nameController,
                icon: Icons.fastfood,
                validator: requiredValidator,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text('Pilih kategori'),
                  items: foodCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        '${emojiForCategory(category)}  $category',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih kategori makanan';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: const Icon(Icons.category),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              buildInput(
                label: 'Deskripsi',
                hint: 'Jelaskan kondisi dan isi makanan',
                controller: descriptionController,
                icon: Icons.description,
                validator: requiredValidator,
                maxLines: 3,
              ),

              buildInput(
                label: 'Harga Normal (Rp)',
                hint: 'Contoh: 30000',
                controller: originalPriceController,
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: positiveNumberValidator,
              ),

              buildInput(
                label: 'Harga Diskon (Rp)',
                hint: 'Contoh: 15000',
                controller: discountPriceController,
                icon: Icons.discount,
                keyboardType: TextInputType.number,
                validator: discountValidator,
              ),

              buildInput(
                label: 'Jumlah Stok',
                hint: 'Contoh: 5',
                controller: stockController,
                icon: Icons.inventory,
                keyboardType: TextInputType.number,
                validator: stockValidator,
              ),

              buildInput(
                label: 'Jam Pengambilan',
                hint: 'Contoh: 18.00 - 20.00',
                controller: pickupController,
                icon: Icons.access_time,
                validator: requiredValidator,
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: publishFood,
                  icon: const Icon(Icons.publish),
                  label: const Text('Publikasikan Makanan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF238B68),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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