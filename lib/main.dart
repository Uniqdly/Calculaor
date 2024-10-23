import 'package:flutter/material.dart';

void main() {
  runApp(Converter());
}

class Converter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Конвертер')),
      body: ListView(
        children: <Widget>[
          buildConverterTile(context, 'Длина', ['Meter', 'Kilometer', 'Centimeter'], lengthConversions),
          buildConverterTile(context, 'Вес', ['Kilogram', 'Gram', 'Pound'], weightConversions),
          buildConverterTile(context, 'Время', ['Seconds', 'Minutes', 'Hours'], timeConversions),
          buildConverterTile(context, 'Скорость', ['Meters per second', 'Kilometers per hour', 'Miles per hour'], speedConversions),
          buildConverterTile(context, 'Площадь', ['Square Meter', 'Square Kilometer', 'Square Mile'], areaConversions),
        ],
      ),
    );
  }

  ListTile buildConverterTile(BuildContext context, String title, List<String> units, Map<String, Map<String, double>> conversions) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitConverter(
              title: title,
              units: units,
              conversions: conversions,
            ),
          ),
        );
      },
    );
  }
}

class UnitConverter extends StatefulWidget {
  final String title;
  final List<String> units;
  final Map<String, Map<String, double>> conversions;

  UnitConverter({
    required this.title,
    required this.units,
    required this.conversions,
  });

  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  late String _fromUnit;
  late String _toUnit;
  String _result = '0';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.units[0];
    _toUnit = widget.units[1];
  }

  void _convert() {
    double value = double.tryParse(_controller.text) ?? 0;
    double conversionFactor = widget.conversions[_fromUnit]?[_toUnit] ?? 1;
    double result = value * conversionFactor;

    setState(() {
      _result = result.toString();
    });
  }

  void _swapUnits() {
    setState(() {
      String temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Конвертер ${widget.title}')),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: _fromUnit,
            items: widget.units.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _fromUnit = newValue!;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: _swapUnits,
            tooltip: 'Поменять местами',
          ),
          DropdownButton<String>(
            value: _toUnit,
            items: widget.units.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _toUnit = newValue!;
              });
            },
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Введите значение'),
          ),
          ElevatedButton(
            onPressed: _convert,
            child: Text('Конвертировать'),
          ),
          Text('Результат: $_result $_toUnit'),
        ],
      ),
    );
  }
}

Map<String, Map<String, double>> lengthConversions = {
  'Meter': {'Kilometer': 0.001, 'Centimeter': 100},
  'Kilometer': {'Meter': 1000, 'Centimeter': 100000},
  'Centimeter': {'Meter': 0.01, 'Kilometer': 0.00001},
};

Map<String, Map<String, double>> weightConversions = {
  'Kilogram': {'Gram': 1000, 'Pound': 2.20462},
  'Gram': {'Kilogram': 0.001, 'Pound': 0.00220462},
  'Pound': {'Kilogram': 0.453592, 'Gram': 453.592},
};

Map<String, Map<String, double>> timeConversions = {
  'Seconds': {'Minutes': 1 / 60, 'Hours': 1 / 3600},
  'Minutes': {'Seconds': 60, 'Hours': 1 / 60},
  'Hours': {'Seconds': 3600, 'Minutes': 60},
};

Map<String, Map<String, double>> speedConversions = {
  'Meters per second': {'Kilometers per hour': 3.6, 'Miles per hour': 2.23694},
  'Kilometers per hour': {'Meters per second': 0.277778, 'Miles per hour': 0.621371},
  'Miles per hour': {'Meters per second': 0.44704, 'Kilometers per hour': 1.60934},
};

Map<String, Map<String, double>> areaConversions = {
  'Square Meter': {'Square Kilometer': 1e-6, 'Square Mile': 3.861e-7},
  'Square Kilometer': {'Square Meter': 1e6, 'Square Mile': 0.3861},
  'Square Mile': {'Square Meter': 2.59e6, 'Square Kilometer': 2.58999},
};
