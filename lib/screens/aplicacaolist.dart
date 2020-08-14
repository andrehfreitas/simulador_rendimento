import 'package:flutter/material.dart';
import 'package:simulador_rendimento/model/aplicacao.dart';
import 'package:simulador_rendimento/screens/aplicacao-card.dart';
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


  Widget aplicacaoListItems() {
    return Container(
      child: aplicacoes.length > 0
      ? ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Dismissible(
            onDismissed: (DismissDirection direction){
              helper.deleteAplicacao(aplicacoes[position].id);
              getData();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Simulação apagada com sucesso'),
                ),
              );
            },

            background: Container(
              color: Colors.red,
              child: Align(
                child: Text(
                  'Apagar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            child: AplicacaoCard(aplicacao: aplicacoes[position],),
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
          );
        },
      )
    : Center(child: Text('Sem simulações'),)
    );
  }
}