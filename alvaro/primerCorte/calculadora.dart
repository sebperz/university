import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const CamburApp());

class CamburApp extends StatelessWidget {
  const CamburApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambur - El Medidor Universal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFD700),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFD700),
        brightness: Brightness.dark,
      ),
      home: const CamburConverterPage(),
    );
  }
}

class CamburConverterPage extends StatefulWidget {
  const CamburConverterPage({super.key});

  @override
  State<CamburConverterPage> createState() => _CamburConverterPageState();
}

class _CamburConverterPageState extends State<CamburConverterPage>
    with SingleTickerProviderStateMixin {
  // 🍌 El estándar internacional del cambur venezolano
  static const double CAMBUR_LENGTH_CM = 18.0;
  static const double CAMBUR_WEIGHT_GRAMS = 120.0;
  static const double CAMBUR_VOLUME_ML = 150.0;

  static const categories = ['Longitud', 'Masa', 'Volumen', 'Tiempo', 'Dinero'];

  static const Map<String, List<String>> unitsByCategory = {
    'Longitud': ['cm', 'm', 'km', 'pies', 'pulgadas', 'millas'],
    'Masa': ['g', 'kg', 'lb', 'oz', 'toneladas'],
    'Volumen': ['ml', 'L', 'galones', 'onzas líquidas', 'tazas'],
    'Tiempo': ['segundos', 'minutos', 'horas', 'días'],
    'Dinero': ['USD', 'EUR', 'VES (Bolívar)', 'COP', 'ARS'],
  };

  static const Map<String, Map<String, double>> toBaseFactor = {
    'Longitud': {
      'cm': 1.0,
      'm': 100.0,
      'km': 100000.0,
      'pies': 30.48,
      'pulgadas': 2.54,
      'millas': 160934.0,
    },
    'Masa': {
      'g': 1.0,
      'kg': 1000.0,
      'lb': 453.592,
      'oz': 28.3495,
      'toneladas': 1000000.0,
    },
    'Volumen': {
      'ml': 1.0,
      'L': 1000.0,
      'galones': 3785.41,
      'onzas líquidas': 29.5735,
      'tazas': 236.588,
    },
    'Tiempo': {
      'segundos': 1.0,
      'minutos': 60.0,
      'horas': 3600.0,
      'días': 86400.0,
    },
    'Dinero': {
      'USD': 1.0,
      'EUR': 1.08,
      'VES (Bolívar)': 0.000023,
      'COP': 0.00024,
      'ARS': 0.0011,
    },
  };

  String category = 'Longitud';
  late String fromUnit = unitsByCategory[category]!.first;
  String inputText = '';
  double? camburResult;
  String? funFact;

  final math.Random _random = math.Random();

  late AnimationController _bananaController;
  late Animation<double> _bananaAnimation;

  @override
  void initState() {
    super.initState();
    _bananaController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bananaAnimation = CurvedAnimation(
      parent: _bananaController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _bananaController.dispose();
    super.dispose();
  }

  double _parse(String s) {
    final t = s.trim().replaceAll(',', '.');
    return double.tryParse(t) ?? 0.0;
  }

  void _convert() {
    final value = _parse(inputText);
    if (value == 0) {
      setState(() {
        camburResult = null;
        funFact = null;
      });
      return;
    }

    double baseValue;
    double camburValue;

    baseValue = value * toBaseFactor[category]![fromUnit]!;

    switch (category) {
      case 'Longitud':
        camburValue = baseValue / CAMBUR_LENGTH_CM;
        break;
      case 'Masa':
        camburValue = baseValue / CAMBUR_WEIGHT_GRAMS;
        break;
      case 'Volumen':
        camburValue = baseValue / CAMBUR_VOLUME_ML;
        break;
      case 'Tiempo':
        camburValue = baseValue / 120.0;
        break;
      case 'Dinero':
        camburValue = baseValue / 0.10;
        break;
      default:
        camburValue = 0;
    }

    _generateFunFact(camburValue, category);

    setState(() {
      camburResult = camburValue;
    });

    _bananaController.forward(from: 0);
  }

  void _generateFunFact(double camburs, String cat) {
    final smallPhrases = [
      "Eso ni siquiera es medio cambur... 😢",
      "Una uña de cambur, quizás",
      "Más pequeño que la esperanza de un venezolano viendo el dólar",
    ];

    final mediumPhrases = [
      "¡Un cambur perfecto! 🍌",
      "Esto sí es un buen desayuno",
      "Ni verde ni maduro, justo en el punto",
    ];

    final largePhrases = [
      "¡Un racimo entero! 🍌🍌🍌",
      "Eso es más cambur que el Mercal en Navidad",
      "Hasta el Chavo del 8 envidiaría ese montón",
    ];

    final extremePhrases = [
      "¡CAMBUR ASTRONÓMICO! 🚀🍌",
      "Eso es más cambur que kilómetros hay de cola para la gasolina",
      "Ni en el Mercado de Chacao hay tanto cambur",
      "¡Alerta de camburzo! (Tsunami de cambures)",
    ];

    String phrase;

    if (camburs < 0.5) {
      phrase = smallPhrases[_random.nextInt(smallPhrases.length)];
    } else if (camburs < 2) {
      phrase = mediumPhrases[_random.nextInt(mediumPhrases.length)];
    } else if (camburs < 50) {
      phrase = largePhrases[_random.nextInt(largePhrases.length)];
    } else {
      phrase = extremePhrases[_random.nextInt(extremePhrases.length)];
    }

    String specificFact = '';
    if (cat == 'Longitud') {
      if (camburs > 1000) {
        specificFact =
            ' Eso es más largo que la cola para comprar harina pan en 2015.';
      }
    } else if (cat == 'Masa') {
      if (camburs > 100) {
        specificFact =
            ' Con eso haces unas torrejas que ni la abuela se imagina.';
      }
    } else if (cat == 'Dinero') {
      if (camburs < 1) {
        specificFact =
            ' Con esa vaina ni te compras un caramelo, menos un cambur.';
      } else {
        specificFact = ' ¡Eso es potencial de un buen batido!';
      }
    }

    setState(() {
      funFact = '$phrase$specificFact';
    });
  }

  void _onCategoryChanged(String? c) {
    if (c == null) return;
    setState(() {
      category = c;
      fromUnit = unitsByCategory[category]!.first;
      camburResult = null;
      funFact = null;
    });
  }

  void _shareResult() {
    if (camburResult == null) return;
    final unitLabel = category == 'Tiempo'
        ? 'tiempos-cambur'
        : (camburResult == 1 ? 'cambur' : 'cambures');
    final text =
        '¡${camburResult!.toStringAsFixed(2)} $unitLabel! 🍌\n\nConvertido con la app Cambur - La medida universal venezolana';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Copiado: $text'),
        backgroundColor: const Color(0xFFFFD700),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildBananaVisual(double count) {
    if (count == 0) return const SizedBox.shrink();

    int fullBananas = count.floor();
    double partial = count - fullBananas;
    List<Widget> bananas = [];

    int displayCount = fullBananas > 20 ? 20 : fullBananas;

    for (int i = 0; i < displayCount; i++) {
      bananas.add(
        AnimatedBuilder(
          animation: _bananaAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _bananaAnimation.value,
              child: Transform.rotate(
                angle: (i % 2 == 0 ? -0.2 : 0.2) * _bananaAnimation.value,
                child: child,
              ),
            );
          },
          child: const Text('🍌', style: TextStyle(fontSize: 32)),
        ),
      );
    }

    if (fullBananas > 20) {
      bananas.add(
        Text(
          '+${fullBananas - 20} más...',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF8C00),
          ),
        ),
      );
    }

    if (partial > 0.1 && fullBananas <= 20) {
      bananas.add(
        Opacity(
          opacity: partial,
          child: const Text('🍌', style: TextStyle(fontSize: 32)),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: bananas,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF2D2D2D)
          : const Color(0xFFFFF8DC),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🍌 ', style: TextStyle(fontSize: 24)),
            Text(
              'Cambur',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(' 🍌', style: TextStyle(fontSize: 24)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                // ignore: deprecated_member_use
                color: const Color(0xFFFFD700).withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'El Estándar Universal Venezolano',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Porque todo en la vida se mide en cambures',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.category, color: cs.primary),
                          const SizedBox(width: 8),
                          const Text(
                            '¿Qué vas a medir?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((cat) {
                          final isSelected = cat == category;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) => _onCategoryChanged(cat),
                            selectedColor: const Color(0xFFFFD700),
                            backgroundColor: cs.surfaceContainerHighest,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : cs.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Cantidad',
                                hintText: 'Ej: 1,75',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.edit),
                                filled: true,
                                // ignore: deprecated_member_use
                                fillColor: cs.surfaceContainerHighest
                                    .withOpacity(0.3),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (v) {
                                inputText = v;
                                _convert();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: fromUnit,
                              underline: const SizedBox(),
                              items: unitsByCategory[category]!
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(
                                        u,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (u) {
                                if (u == null) return;
                                setState(() => fromUnit = u);
                                _convert();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (camburResult != null)
                Card(
                  elevation: 8,
                  color: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'RESULTADO',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          camburResult!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        Text(
                          _getUnitLabel(camburResult!),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildBananaVisual(camburResult!),
                        const SizedBox(height: 16),
                        if (funFact != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              funFact!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _shareResult,
                          icon: const Icon(Icons.share),
                          label: const Text('Compartir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: const Color(0xFFFFD700),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  '🍌 Hecho con amor y potasio 🍌\nEl cambur no miente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            inputText = '';
            camburResult = null;
            funFact = null;
          });
        },
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.refresh),
        label: const Text('Nuevo'),
      ),
    );
  }

  String _getUnitLabel(double value) {
    if (category == 'Tiempo') {
      return value == 1 ? 'TIEMPO-CAMBUR' : 'TIEMPOS-CAMBUR';
    }
    return value == 1 ? 'CAMBUR' : 'CAMBURES';
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(children: [Text('🍌 '), Text('Sobre Cambur')]),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estándares Oficiales:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• 1 Cambur = 18 cm de longitud'),
            Text('• 1 Cambur = 120 gramos de masa'),
            Text('• 1 Cambur = 150 ml de volumen'),
            Text('• 1 Tiempo-Cambur = 2 minutos'),
            Text('• 1 Cambur = ~0.10 USD'),
            SizedBox(height: 16),
            Text(
              '¿Por qué cambur?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Porque en Venezuela, el cambur es la unidad más confiable'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('¡Entendido!'),
          ),
        ],
      ),
    );
  }
}
