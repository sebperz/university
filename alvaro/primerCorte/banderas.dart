import 'package:flutter/material.dart';

void main() => runApp(const ChileApp());

class ChileApp extends StatelessWidget {
  const ChileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chile - Regiones y Cultura',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0039A6), // Chilean Blue
        brightness: Brightness.light,
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

  static const _titles = ['Regiones', 'Buscar', 'Cultura'];
  final _pages = const [RegionsPage(), SearchPage(), CulturePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Text('🇨🇱 '), Text(_titles[_index])],
        ),
        backgroundColor: const Color(0xFFCE1126), // Chilean Red
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: const Color(0xFF0039A6), // Chilean Blue
        // ignore: deprecated_member_use
        indicatorColor: Colors.white.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.map, color: Colors.white),
            label: 'Regiones',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.search, color: Colors.white),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.palette, color: Colors.white),
            label: 'Cultura',
          ),
        ],
      ),
    );
  }
}

class RegionsPage extends StatefulWidget {
  const RegionsPage({super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage>
    with AutomaticKeepAliveClientMixin {
  // Chile's 16 regions with capital and characteristic
  final List<Map<String, dynamic>> _regions = [
    {
      'name': 'Arica y Parinacota',
      'capital': 'Arica',
      'zone': 'Norte Grande',
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'Tarapacá',
      'capital': 'Iquique',
      'zone': 'Norte Grande',
      'icon': Icons.beach_access,
    },
    {
      'name': 'Antofagasta',
      'capital': 'Antofagasta',
      'zone': 'Norte Grande',
      'icon': Icons.landscape,
    },
    {
      'name': 'Atacama',
      'capital': 'Copiapó',
      'zone': 'Norte Chico',
      'icon': Icons.water_drop,
    },
    {
      'name': 'Coquimbo',
      'capital': 'La Serena',
      'zone': 'Norte Chico',
      'icon': Icons.wine_bar,
    },
    {
      'name': 'Valparaíso',
      'capital': 'Valparaíso',
      'zone': 'Central',
      'icon': Icons.directions_boat,
    },
    {
      'name': 'Metropolitana',
      'capital': 'Santiago',
      'zone': 'Central',
      'icon': Icons.location_city,
    },
    {
      'name': 'O\'Higgins',
      'capital': 'Rancagua',
      'zone': 'Central',
      'icon': Icons.agriculture,
    },
    {
      'name': 'Maule',
      'capital': 'Talca',
      'zone': 'Central',
      'icon': Icons.forest,
    },
    {
      'name': 'Ñuble',
      'capital': 'Chillán',
      'zone': 'Sur',
      'icon': Icons.ac_unit,
    },
    {
      'name': 'Biobío',
      'capital': 'Concepción',
      'zone': 'Sur',
      'icon': Icons.factory,
    },
    {
      'name': 'Araucanía',
      'capital': 'Temuco',
      'zone': 'Sur',
      'icon': Icons.nature,
    },
    {
      'name': 'Los Ríos',
      'capital': 'Valdivia',
      'zone': 'Sur',
      'icon': Icons.water,
    },
    {
      'name': 'Los Lagos',
      'capital': 'Puerto Montt',
      'zone': 'Sur',
      'icon': Icons.landscape,
    },
    {
      'name': 'Aysén',
      'capital': 'Coyhaique',
      'zone': 'Austral',
      'icon': Icons.ice_skating,
    },
    {
      'name': 'Magallanes',
      'capital': 'Punta Arenas',
      'zone': 'Austral',
      'icon': Icons.ac_unit,
    },
  ];

  @override
  bool get wantKeepAlive => true;

  Color _getZoneColor(String zone) {
    switch (zone) {
      case 'Norte Grande':
        return Colors.orange;
      case 'Norte Chico':
        return Colors.amber;
      case 'Central':
        return const Color(0xFFCE1126); // Chilean Red
      case 'Sur':
        return Colors.green;
      case 'Austral':
        return Colors.blue.shade800;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      key: const PageStorageKey('regions_list'),
      padding: const EdgeInsets.all(12),
      itemCount: _regions.length,
      itemBuilder: (_, i) {
        final region = _regions[i];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getZoneColor(region['zone']),
              child: Icon(region['icon'], color: Colors.white),
            ),
            title: Text(
              region['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Capital: ${region['capital']} • ${region['zone']}'),
            trailing: Chip(
              label: Text(
                '#${i + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: const Color(0xFF0039A6),
              padding: EdgeInsets.zero,
            ),
          ),
        );
      },
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
  final List<String> _chileanCities = [
    'Santiago',
    'Valparaíso',
    'Concepción',
    'La Serena',
    'Antofagasta',
    'Temuco',
    'Rancagua',
    'Iquique',
    'Puerto Montt',
    'Chillán',
    'Calama',
    'Osorno',
    'Copiapó',
    'Punta Arenas',
    'Curicó',
    'Talca',
    'Arica',
    'Valdivia',
    'Coyhaique',
    'Villarrica',
    'Pucón',
    'La Unión',
    'Castro',
    'Puerto Varas',
    'Frutillar',
  ];
  List<String> _filteredCities = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = [];
      } else {
        _filteredCities = _chileanCities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFFCE1126).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Buscar ciudad chilena',
                  hintText: 'Ej: Valparaíso, Punta Arenas...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFCE1126),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _search,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCities.isEmpty && _controller.text.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.travel_explore,
                            size: 64,
                            // ignore: deprecated_member_use
                            color: const Color(0xFF0039A6).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Busca ciudades de Chile',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Desde Arica hasta Punta Arenas',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : _filteredCities.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron ciudades',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      key: const PageStorageKey('cities_results'),
                      itemCount: _filteredCities.length,
                      itemBuilder: (_, i) => Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Color(0xFFCE1126),
                          ),
                          title: Text(_filteredCities[i]),
                          subtitle: Text('Chile 🇨🇱'),
                          trailing: const Icon(Icons.chevron_right),
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

class CulturePage extends StatelessWidget {
  const CulturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('culture_page'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chile Flag Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0039A6), Color(0xFFCE1126)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🇨🇱', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                const Text(
                  'República de Chile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Por la razón o la fuerza',
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Tradiciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0039A6),
            ),
          ),

          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: const [
              _CultureTile(
                icon: Icons.music_note,
                label: 'Cueca',
                color: Color(0xFFCE1126),
                description: 'Baile nacional',
              ),
              _CultureTile(
                icon: Icons.food_bank,
                label: 'Empanadas',
                color: Color(0xFF0039A6),
                description: '18 de septiembre',
              ),
              _CultureTile(
                icon: Icons.wine_bar,
                label: 'Vino',
                color: Colors.purple,
                description: 'Valle Central',
              ),
              _CultureTile(
                icon: Icons.park,
                label: 'Terremotos',
                color: Colors.orange,
                description: 'Bebida típica',
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Datos Curiosos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0039A6),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            child: Column(
              children: [
                _buildFactRow(Icons.straighten, '4.300 km', 'de longitud'),
                const Divider(height: 1),
                _buildFactRow(
                  Icons.terrain,
                  '6.961 m',
                  'Ojos del Salado (volcán más alto)',
                ),
                const Divider(height: 1),
                _buildFactRow(Icons.water, '8.000 km', 'de costa'),
                const Divider(height: 1),
                _buildFactRow(
                  Icons.eco,
                  '24%',
                  'de la reserva de litio mundial',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactRow(IconData icon, String value, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFCE1126)),
          const SizedBox(width: 16),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF0039A6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _CultureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;

  const _CultureTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        side: BorderSide(color: color.withOpacity(0.3), width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // ignore: deprecated_member_use
            colors: [color.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
