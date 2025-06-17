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
      title: 'Gasolina ou Alcool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Adiciona um tema de entrada para um visual mais consistente
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding:
                EdgeInsets.symmetric(vertical: 15.0), // Preenchimento do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
            ),
            textStyle: TextStyle(fontSize: 18), // Tamanho da fonte do botão
          ),
        ),
      ),
      home: const MyHomePage(title: 'GASOLINA ou ALCOOL - v0.1'),
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
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário

  final TextEditingController _inputController = TextEditingController();
  double _resultado = 0.0;
  bool _showResultContainer = false; // NOVA VARIÁVEL DE ESTADO
  String _mensagem = '';
  final double _spacing = 30.0;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_clearResultOnInputChange);
  }

  // Listener para limpar o resultado quando o input é esvaziado
  void _clearResultOnInputChange() {
    if (_inputController.text.isEmpty && _showResultContainer) {
      setState(() {
        _resultado = 0.0;
        _showResultContainer = false; // ESCONDE O CONTAINER
      });
    }
  }

  String formatarDecimalBrasileiro(double valor) {
    final formatoBrasileiro = NumberFormat("#,##0.00", "pt_BR");
    return formatoBrasileiro.format(valor);
  }

  void _calcular() {
    // Valida o formulário antes de tentar o cálculo
    if (_formKey.currentState!.validate()) {
      final String texto = _inputController.text;
      if (texto.isNotEmpty) {
        try {
          // String valorAjustado = valor.replaceAll(',', '.');
          // double inputValue = double.parse(valorAjustado);
          final double valor = double.parse(texto.replaceAll(',', '.'));
          setState(() {
            _resultado = valor * 0.7;
            _showResultContainer =
                true; // MOSTRA O CONTAINER APÓS CÁLCULO BEM-SUCEDIDO
            _mensagem =
                'Compre GASOLINA se preço do ALCOOL maior que: R\$ ${formatarDecimalBrasileiro(_resultado)}';
          });
        } catch (e) {
          // Em caso de erro de parsing, exibe snackbar e esconde o container
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Valor inválido. Insira um número até 9,99.')),
          );
          setState(() {
            _resultado = 0.0;
            _showResultContainer = false; // ESCONDE O CONTAINER EM CASO DE ERRO
          });
        }
      } else {
        // Se o input estiver vazio (após validação), esconde o container
        setState(() {
          _resultado = 0.0;
          _showResultContainer = false; // ESCONDE O CONTAINER SE INPUT VAZIO
        });
      }
    } else {
      // Se a validação do formulário falhar, esconde o container
      setState(() {
        _showResultContainer = false;
      });
    }
  }

  @override
  void dispose() {
    _inputController.removeListener(_clearResultOnInputChange);
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(
            child: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Stack(  // O Stack permite sobrepor e posicionar widgets
          children: <Widget>[
            Positioned(
              top: 80.0,
              left: 10.0,
              right: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('images/bomba_combustivel.jpg'),
                        ),
                        // Image.asset(
                        //   'images/bomba_combustivel.jpg',
                        //   height: 80,
                        // ),
                        SizedBox(height: _spacing),

                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 30, fontFamily: 'Montserrat'),
                            autofocus: true, // Foca no campo ao abrir a tela
                            // initialValue: formatarDecimalBrasileiro(6),
                            controller: _inputController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d(?:[\,]\d{0,2})?')
                                ), // Permite digitos, opcionalmente uma virgula/ponto e até 2 casas decimais
                            ],
                            decoration: InputDecoration(
                              labelText:
                                  'PREÇO DA GASOLINA', 
                              border: OutlineInputBorder(),
                              prefixText: 'R\$ ',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insira um valor';
                              }
                              if (!RegExp(r'^\d(?:[\,]\d{0,2})?')
                                  .hasMatch(value)) {   // Valor até 9,99 em Reais
                                return 'Formato de moeda inválido';
                              }
                              return null; // Indica que o valor é válido
                            },
                          ),
                        ),

                        SizedBox(height: _spacing),

                        // ElevatedButton(
                        //   onPressed: _calcular,
                        //   style: ElevatedButton.styleFrom(
                        //     // padding: const EdgeInsets.symmetric(vertical: 16.0),
                        //     textStyle: const TextStyle(
                        //         fontSize: 25, fontFamily: 'Roboto'),
                        //   ),
                        //   child: const Text('CALCULAR'),
                        // ),

                        SizedBox(
                          width: 150, // Largura definida como 100 pixels
                          child: GestureDetector(
                            onTap: _calcular,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.lightBlue, Colors.green],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue,
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'CALCULAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: _spacing),

                        // --- ÁREA DE RESULTADO CONDICIONAL ---
                        // O AnimatedSwitcher e seu conteúdo só serão construídos se _showResultContainer for true
                        if (_showResultContainer)
                          AnimatedSwitcher(
                            duration: const Duration(
                                milliseconds: 500), // Duração da animação
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              // Efeito de fade e scale ao mudar o resultado
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                    scale: animation, child: child),
                              );
                            },
                            child: Container(
                              // A chave precisa ser única para que AnimatedSwitcher detecte a mudança
                              key: ValueKey<String>(_mensagem),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor, // Usa a cor de fundo do Card do tema
                                borderRadius: BorderRadius.circular(
                                    10.0), // Cantos arredondados
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100, // Sombra azul sutil
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5), // Deslocamento da sombra
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Ocupa o mínimo de espaço vertical necessário
                                children: [
                                  Text(_mensagem,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        // --- FIM DA ÁREA DE RESULTADO CONDICIONAL ---

                        SizedBox(height: _spacing),
                        const Text(
                          'Obs: O cálculo é baseado na regra de 70% do preço da gasolina.',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.teal,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
