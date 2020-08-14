import 'package:simulador_rendimento/model/aplicacao.dart';
import 'package:flutter/material.dart';

class AplicacaoCard extends StatelessWidget {
  final Aplicacao aplicacao;

  AplicacaoCard({this.aplicacao});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Column(
        children: <Widget> [
          ListTile(
            title: Text(this.aplicacao.valorMensal),
            subtitle: Text(this.aplicacao.prazo),
          ),

          ListTile(
            title: Text(this.aplicacao.valorAcumulado),
            subtitle: Text(this.aplicacao.valorAtualizado),
          ),
        ],
      ),
    );
  }
}