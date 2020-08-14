import 'package:flutter/material.dart';
import 'package:simulador_rendimento/model/aplicacao.dart';
import 'package:simulador_rendimento/util/dbhelper.dart';


class AplicacaoList extends StatefulWidget {
@override
  State<StatefulWidget> createState() => AplicacaoListState();
}

class AplicacaoListState extends State<AplicacaoList>{

  DbHelper helper = DbHelper();
  List<Aplicacao> aplicacoes;
  int count = 0;

  void getData(){
    final dbFuture = helper.initializeDb();

    dbFuture.then( (result) {
      final aplicacoesFuture = helper.getAplicacoes();
      aplicacoesFuture.then( (result) {
        List<Aplicacao> aplicacaoList = List<Aplicacao>();
        count = result.length;

        for (int i=0; i<count; i++) {
          aplicacaoList.add(Aplicacao.fromObject(result[i]));
        } 

        setState(() {
          aplicacoes = aplicacaoList;
        });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (aplicacoes == null) {
      aplicacoes = List<Aplicacao>();
      getData();
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Simulações salvas')),
      body: aplicacaoListItems(),
    );
  }


  ListView aplicacaoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Column(
            children: <Widget> [
              ListTile(
                title: Text(this.aplicacoes[position].valorMensal),
                subtitle: Text(this.aplicacoes[position].prazo),
              ),

              Divider(height: 0.0,),

              ListTile(
                title: Text(this.aplicacoes[position].valorAcumulado),
                subtitle: Text(this.aplicacoes[position].valorAtualizado),
              ),
            ],
          ),
        );
      },
    );
  }
}