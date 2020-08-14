import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simulador_rendimento/screens/aplicacaolist.dart';
import 'package:simulador_rendimento/util/dbhelper.dart';
import 'package:simulador_rendimento/model/aplicacao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Simulador(),
    );
  }
}

class Simulador extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SimuladorState();
}

class SimuladorState extends State<Simulador> {

  Aplicacao aplicacao;

  // Controles dos TextFiels
  TextEditingController valorController = TextEditingController();
  TextEditingController taxaController = TextEditingController();
  TextEditingController prazoController = TextEditingController();

  // Formatação para moeda brasileira
  final formatter = NumberFormat.currency(locale: "pt-br", symbol: "R\$");

  String valorMensal = '';
  String valorAcumulado = '';
  String valorAtualizado = '';
  String prazo = '';

  // Instanciar o dbhelper:
  DbHelper helper = DbHelper();

  // Método Build
  @override
  Widget build(BuildContext context) {

    // Definindo um estilo de texto padrão
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Simulador de rentabilidade'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _listaSimulacoes),
        ]
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: valorController,
              style: textStyle,
              decoration: InputDecoration(
                labelText: "Valor a ser aplicado mensalmente",
                hintText: 'p.ex. 0.00',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 9.0, bottom: 9.0),
              child: TextField(
                controller: taxaController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Taxa de juros mensal (%)",
                  hintText: 'p.ex. 0.00',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            TextField(
                controller: prazoController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Prazo em meses",
                  hintText: 'p.ex. 60',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 8.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      child: Text(
                        'SIMULAR',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          valorMensal = 'Valor aplicado mensalmente: ' + formatter.format(double.parse(valorController.text));
                          prazo = 'Prazo da aplicação: ' + prazoController.text + ' meses';
                          valorAcumulado = calculaTotalAcumulado();
                          valorAtualizado = calculaTotalRentabilizado();
                          aplicacao = Aplicacao(valorMensal, valorAcumulado, valorAtualizado, prazo);
                        });

                      },
                    ),
                  ),
                ),
              ],
            ),

            Text(valorMensal),
            Text(prazo),
            Text(valorAcumulado),
            Text(valorAtualizado),

            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 70.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorLight,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        'Salvar Simulação',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        helper.insertAplicacao(aplicacao);
                        setState(() {
                          limpaFormulario();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String calculaTotalAcumulado(){
    double valorMensal = double.parse(valorController.text);
    int prazo = int.parse(prazoController.text);

    double valorTotalAcumulado = valorMensal * prazo;
    String saida = 'Valor total aplicado:  ' + formatter.format(valorTotalAcumulado);

    return saida;
  }


  String calculaTotalRentabilizado(){
    double valorMensal = double.parse(valorController.text);
    double taxa = double.parse(taxaController.text);
    int prazo = int.parse(prazoController.text);
    double valorAtualizado = 0.0;

    for (var i = 0; i < prazo; i++){
      valorAtualizado = valorAtualizado + (valorAtualizado * taxa/100) + valorMensal;
    }

    String saida = 'Valor total aplicado + Rentabilidade:  ' + formatter.format(valorAtualizado); 
    
    return saida;
  }

  limpaFormulario(){
    valorController.text = '';
    taxaController.text = '';
    prazoController.text = '';
    valorMensal = '';
    valorAcumulado = '';
    valorAtualizado = '';
    prazo = '';
  }

  void _listaSimulacoes() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AplicacaoList()));
  }

}
