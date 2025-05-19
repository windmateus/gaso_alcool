import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gasolina ou Alcool?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto', // Example: Use a different font
      ),
      home: const MyHomePage(title: 'GASOLINA ou ALCOOL?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _inputController = TextEditingController();
  double _resultado = 0.0;
  String _mensagem = '';
  final double _spacing = 16.0;
  
  String formatarDecimalBrasileiro(double valor) {
    final formatoBrasileiro = NumberFormat("#,##0.00", "pt_BR");
    return formatoBrasileiro.format(valor);
  }  

  void _calcular() {
    setState(() {
      try {
        String valorAjustado = _inputController.text.replaceAll(',', '.');
        double inputValue = double.parse(valorAjustado);
        _resultado = inputValue * 0.7;
        _mensagem = 'Compre GASOLINA se o preço do ALCOOL for maior que: R\$ ${formatarDecimalBrasileiro(_resultado)}';        
      } catch (e) {
        _resultado = 0.0;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: <Widget>[
            
            SizedBox(
              width: 100,
              child:
                TextFormField(
                  // initialValue: formatarDecimalBrasileiro(6),
                  controller: _inputController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d(?:[\,]\d{0,2})?')), // Permite digitos, opcionalmente uma virgula/ponto e até 2 casas decimais
                    // Nota: Uma implementação mais robusta para formatos monetários pode ser necessária dependendo da complexidade.
                    // Esta regex é um ponto de partida.
                  ],                  
                  decoration: InputDecoration(
                    labelText: 'GASOLINA',   // Valor até 9,99 em Reais
                    border: OutlineInputBorder(),
                    prefixText: 'R\$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor.';
                    }
                    // Exemplo básico de validação se quiser garantir que se parece com um número
                    // Uma validação mais completa pode converter para double e verificar
                    if (!RegExp(r'^\d(?:[\,]\d{0,2})?').hasMatch(value)) {
                      // Esta regex verifica um formato mais específico: digitos, opcionalmente virgula/ponto e EXATAMENTE 2 casas decimais
                      // Ajuste conforme a sua necessidade de validação
                      return 'Formato de moeda inválido. Use o formato 3,45';
                    }
                    return null; // Indica que o valor é válido
                  },
                ),
            ),

            SizedBox(height: _spacing),
            ElevatedButton(
              onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Calcular'),
            ),
            SizedBox(height: _spacing),
            Text(
              _mensagem,
              style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
