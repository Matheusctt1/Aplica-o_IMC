import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmi;
  String _result = '';
  bool _calculated = false;

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira valores válidos')),
      );
      return;
    }

    final heightMeters = height > 3 ? height / 100 : height;
    final bmi = weight / (heightMeters * heightMeters);

    String result;
    if (bmi < 18.5) {
      result = 'Abaixo do peso';
    } else if (bmi < 25) {
      result = 'Normal';
    } else if (bmi < 30) {
      result = 'Acima do peso';
    } else {
      result = 'Obesidade';
    }

    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(1));
      _result = result;
      _calculated = true;
    });
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmi = null;
      _result = '';
      _calculated = false;
    });
  }

  void _showCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const BMICategoriesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Corpo'),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCategories,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Calculadora de IMC',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  GenderCard(selected: true, label: 'Homem', icon: Icons.male),
                  GenderCard(selected: false, label: 'Mulher', icon: Icons.female),
                ],
              ),
              const SizedBox(height: 30),
              if (!_calculated)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _weightController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Seu peso (Kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _heightController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Sua altura (cm)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _calculateBMI,
                      child: const Text(
                        'Calcular IMC',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text('Seu IMC'),
                    Text(
                      _bmi!.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _reset,
                      child: const Text(
                        'Calcular IMC novamente',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              TextButton(
                onPressed: _showCategories,
                child: const Text('Categorias de IMC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderCard extends StatelessWidget {
  final bool selected;
  final String label;
  final IconData icon;

  const GenderCard({
    super.key,
    required this.selected,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor:
              selected ? Colors.blue.shade100 : Colors.grey.shade200,
          child: Icon(icon,
              size: 40, color: selected ? Colors.blue : Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class BMICategoriesSheet extends StatelessWidget {
  const BMICategoriesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: Text(
              'Categorias de IMC',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Text('Menos de 18,5 — você está abaixo do peso.'),
          SizedBox(height: 10),
          Text('18,5 a 24,9 — você está normal.'),
          SizedBox(height: 10),
          Text('25 a 29,9 — você está acima do peso.'),
          SizedBox(height: 10),
          Text('30 ou mais — obesidade.'),
        ],
      ),
    );
  }
}
