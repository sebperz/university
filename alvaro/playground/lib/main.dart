import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Chile',
      theme: ThemeData(
        useMaterial3: true,
        // Tema basado en la bandera de Chile: Azul, Blanco y Rojo
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0039A6), // Azul de la bandera
          primary: const Color(0xFF0039A6),
          secondary: const Color(0xFFD52B1E), // Rojo de la bandera
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static const _titles = ['Feed', 'Buscar', 'Ajustes'];
  final _pages = const [FeedPage(), SearchPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0039A6),
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF0039A6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  // Contenido temático: Ciudades de Chile
  final _items = <String>[
    'Santiago',
    'Valparaíso',
    'Concepción',
    'La Serena',
    'Antofagasta',
    'Punta Arenas',
    'Iquique',
    'Puerto Montt',
    'Arica',
    'Temuco',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // requerido por KeepAlive
    return ListView.builder(
      key: const PageStorageKey('feed_list'),
      padding: const EdgeInsets.all(12),
      itemCount: _items.length,
      itemBuilder: (_, i) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: const Icon(
            Icons.location_city,
            color: Color(0xFFD52B1E),
          ), // Rojo Chile
          title: Text(
            _items[i],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Región de Chile'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();
  final List<String> _results = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addResult() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    setState(() => _results.add(q));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ocultar teclado
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Buscar en Chile',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _addResult(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD52B1E), // Botón Rojo
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _results.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin resultados. Escribe un lugar.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      key: const PageStorageKey('search_results'),
                      itemCount: _results.length,
                      // ERROR FIX: Changed (, _) to (_, __)
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => ListTile(
                        leading: const Icon(
                          Icons.place,
                          color: Color(0xFF0039A6),
                        ),
                        title: Text(_results[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      key: const PageStorageKey('settings_grid'),
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 1.25,
      children: const [
        _SettingTile(icon: Icons.wifi, label: 'Wi‑Fi'),
        _SettingTile(icon: Icons.notifications, label: 'Notificaciones'),
        _SettingTile(icon: Icons.lock, label: 'Privacidad'),
        _SettingTile(icon: Icons.flag, label: 'Región'),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SettingTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF0039A6),
            ), // Iconos Azules
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
