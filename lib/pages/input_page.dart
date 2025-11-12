//Halaman utama: input + converter (other units) + tombol Calculate & Clear. Clear mengembalikan semua input ke 0.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bmr_calculator/constants.dart';
import 'package:bmr_calculator/components/custom_card.dart';
import 'package:bmr_calculator/components/round_icon_button.dart';
import 'package:bmr_calculator/components/bottom_button.dart';
import 'package:bmr_calculator/calculator.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage>
    with SingleTickerProviderStateMixin {
  // Variabel utama
  Gender selectedGender = Gender.male;
  BmrFormula selectedFormula = BmrFormula.mifflinStJeor;

  int age = 0;
  int heightCm = 0;
  int weightKg = 0;
  double bodyFat = 0;

  // Controller konversi (Input meter/inch dan kg/lb)
  final TextEditingController meterController = TextEditingController(
    text: '0',
  );
  final TextEditingController inchController = TextEditingController(text: '0');
  final TextEditingController kgController = TextEditingController(text: '0');
  final TextEditingController lbController = TextEditingController(text: '0');

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // konversi otomatis meter-inch
    meterController.addListener(() {
      final v = double.tryParse(meterController.text) ?? 0;
      final inches = (v * 39.3701).toStringAsFixed(2);
      if (inchController.text != inches) inchController.text = inches;
      final cm = (v * 100).round();
      if (heightCm != cm) setState(() => heightCm = cm);
    });

    inchController.addListener(() {
      final v = double.tryParse(inchController.text) ?? 0;
      final meters = (v / 39.3701).toStringAsFixed(2);
      if (meterController.text != meters) meterController.text = meters;
      final cm = (v * 2.54).round();
      if (heightCm != cm) setState(() => heightCm = cm);
    });

    //konversi otomatis kg-lb
    kgController.addListener(() {
      final v = double.tryParse(kgController.text) ?? 0;
      final lbs = (v * 2.20462).toStringAsFixed(2);
      if (lbController.text != lbs) lbController.text = lbs;
      if (weightKg != v.round()) setState(() => weightKg = v.round());
    });

    lbController.addListener(() {
      final v = double.tryParse(lbController.text) ?? 0;
      final kgs = (v / 2.20462).toStringAsFixed(2);
      if (kgController.text != kgs) kgController.text = kgs;
      final kgRound = (v / 2.20462).round();
      if (weightKg != kgRound) setState(() => weightKg = kgRound);
    });
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    meterController.dispose();
    inchController.dispose();
    kgController.dispose();
    lbController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // --- Reset semua input ---
  void _clearAll() {
    setState(() {
      selectedGender = Gender.male;
      selectedFormula = BmrFormula.mifflinStJeor;
      age = 0;
      heightCm = 0;
      weightKg = 0;
      bodyFat = 0;
      meterController.text = '0';
      inchController.text = '0';
      kgController.text = '0';
      lbController.text = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMR CALCULATOR'),
        // --- Tab Navigasi untuk US, Metric, dan Other Units ---
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'US Units'),
            Tab(text: 'Metric Units'),
            Tab(text: 'Other Units'),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Isi utama tiap tab ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsTab(),
                _buildMetricTab(),
                _buildOtherUnitsTab(),
              ],
            ),
          ),

          // --- Tombol CALCULATE & CLEAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: BottomButton(
                    title: 'CALCULATE',
                    onTap: () {
                      // Hitung nilai BMR dan pindah ke halaman hasil
                      final calc = BmrCalculator(
                        heightCm: heightCm.toDouble(),
                        weightKg: weightKg.toDouble(),
                        age: age,
                        gender: selectedGender,
                        bodyFatPercent:
                            selectedFormula == BmrFormula.katchMcArdle
                            ? (bodyFat == 0 ? null : bodyFat)
                            : null,
                        formula: selectedFormula,
                      );

                      final bmr = calc.calculate();
                      final category = calc.getCategory();
                      final interpretation = calc.getInterpretation();
                      final table = calc.caloriesForActivities();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultPage(
                            bmr: bmr.round(),
                            category: category,
                            interpretation: interpretation,
                            caloriesTable: table,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BottomButton(title: 'CLEAR', onTap: _clearAll),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab: US Units (inch & lbs) ---
  Widget _buildUsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _genderCard()),
              Expanded(child: _ageCard()),
            ],
          ),
          // Input tinggi & berat badan
          CustomCard(
            color: cardGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Height (inches)', style: labelTextStyle),
                Text('${(heightCm / 2.54).round()} in', style: numberTextStyle),
                Slider(
                  value: (heightCm / 2.54).clamp(0, 100).toDouble(),
                  min: 0,
                  max: 84,
                  onChanged: (v) {
                    final cm = (v * 2.54).round();
                    setState(() {
                      heightCm = cm;
                      meterController.text = (cm / 100).toStringAsFixed(2);
                      inchController.text = v.toStringAsFixed(2);
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Text('Weight (lbs)', style: labelTextStyle),
                Text(
                  '${(weightKg * 2.20462).round()} lb',
                  style: numberTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      onPressed: () {
                        setState(() {
                          final newKg = (weightKg - 1).clamp(0, 999);
                          weightKg = newKg;
                          kgController.text = weightKg.toString();
                          lbController.text = (weightKg * 2.20462)
                              .toStringAsFixed(2);
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      onPressed: () {
                        setState(() {
                          weightKg = (weightKg + 1).clamp(0, 999);
                          kgController.text = weightKg.toString();
                          lbController.text = (weightKg * 2.20462)
                              .toStringAsFixed(2);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _formulaCard(),
        ],
      ),
    );
  }

  // --- Tab: Metric Units (cm & kg) ---
  Widget _buildMetricTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _genderCard()),
              Expanded(child: _ageCard()),
            ],
          ),
          CustomCard(
            color: cardGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Height (cm)', style: labelTextStyle),
                Text('$heightCm cm', style: numberTextStyle),
                Slider(
                  value: heightCm.toDouble().clamp(0, 220),
                  min: 0,
                  max: 220,
                  onChanged: (v) {
                    setState(() {
                      heightCm = v.round();
                      meterController.text = (heightCm / 100).toStringAsFixed(
                        2,
                      );
                      inchController.text = (heightCm / 2.54).toStringAsFixed(
                        2,
                      );
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Text('Weight (kg)', style: labelTextStyle),
                Text('$weightKg kg', style: numberTextStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      onPressed: () {
                        setState(() {
                          weightKg = (weightKg - 1).clamp(0, 999);
                          kgController.text = weightKg.toString();
                          lbController.text = (weightKg * 2.20462)
                              .toStringAsFixed(2);
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      onPressed: () {
                        setState(() {
                          weightKg = (weightKg + 1).clamp(0, 999);
                          kgController.text = weightKg.toString();
                          lbController.text = (weightKg * 2.20462)
                              .toStringAsFixed(2);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _formulaCard(),
        ],
      ),
    );
  }

  // --- Tab: Other Units
  Widget _buildOtherUnitsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          CustomCard(
            color: cardGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Use the converters below to convert your values to the units accepted by the calculator.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Text('Height Converter:', style: labelTextStyle),
                // Konversi tinggi meter <-> inch
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: meterController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'meter'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('= ?'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: inchController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'inch'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Weight Converter:', style: labelTextStyle),
                // Konversi berat kg <-> lb
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: kgController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'kilogram',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('= ?'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: lbController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'pound'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '*Converter bekerja otomatis — ketik di salah satu field untuk mengupdate nilai lain dan nilai utama (cm, kg).',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Komponen: Pilihan Gender ---
  Widget _genderCard() {
    return CustomCard(
      color: cardGrey,
      child: Column(
        children: [
          const Text('Gender', style: labelTextStyle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedGender = Gender.male),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.mars,
                      color: selectedGender == Gender.male
                          ? primaryBlue
                          : Colors.black54,
                    ),
                    const SizedBox(height: 6),
                    const Text('MALE', style: labelTextStyle),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () => setState(() => selectedGender = Gender.female),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.venus,
                      color: selectedGender == Gender.female
                          ? primaryBlue
                          : Colors.black54,
                    ),
                    const SizedBox(height: 6),
                    const Text('FEMALE', style: labelTextStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // --- Komponen: Pilihan Umur ---
  Widget _ageCard() {
    return CustomCard(
      color: cardGrey,
      child: Column(
        children: [
          const Text('Age', style: labelTextStyle),
          Text('$age', style: numberTextStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundIconButton(
                icon: FontAwesomeIcons.minus,
                onPressed: () {
                  setState(() => age = (age - 1).clamp(0, 150));
                },
              ),
              const SizedBox(width: 12),
              RoundIconButton(
                icon: FontAwesomeIcons.plus,
                onPressed: () {
                  setState(() => age = (age + 1).clamp(0, 150));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Komponen: Pilihan formula + Body Fat (untuk Katch-McArdle) ---
  Widget _formulaCard() {
    return CustomCard(
      color: cardGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Formula', style: labelTextStyle),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Mifflin St Jeor'),
                selected: selectedFormula == BmrFormula.mifflinStJeor,
                onSelected: (_) =>
                    setState(() => selectedFormula = BmrFormula.mifflinStJeor),
              ),
              ChoiceChip(
                label: const Text('Revised HB'),
                selected: selectedFormula == BmrFormula.revisedHarrisBenedict,
                onSelected: (_) => setState(
                  () => selectedFormula = BmrFormula.revisedHarrisBenedict,
                ),
              ),
              ChoiceChip(
                label: const Text('Katch-McArdle'),
                selected: selectedFormula == BmrFormula.katchMcArdle,
                onSelected: (_) =>
                    setState(() => selectedFormula = BmrFormula.katchMcArdle),
              ),
            ],
          ),
          if (selectedFormula == BmrFormula.katchMcArdle) ...[
            const SizedBox(height: 8),
            const Text('Body Fat %', style: labelTextStyle),
            Slider(
              value: bodyFat,
              min: 0,
              max: 60,
              divisions: 60,
              label: '${bodyFat.round()}%',
              onChanged: (v) => setState(() => bodyFat = v),
            ),
          ],
        ],
      ),
    );
  }
}
