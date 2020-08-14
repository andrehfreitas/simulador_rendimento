class Aplicacao {
  int _id;
  String _valorMensal;
  String _valorAcumulado;
  String _valorAtualizado;
  String _prazo;

  // Construtor para quando o bando de dados não definiu o _id
  Aplicacao(this._valorMensal, this._valorAcumulado, this._valorAtualizado, this._prazo);
  // Construtor nomeado para quando já se tem o _id
  Aplicacao.comId(this._id, this._valorMensal, this._valorAcumulado, this._valorAtualizado, this._prazo);


  // Getters
  int get id => _id;
  String get valorMensal => _valorMensal;
  String get valorAcumulado => _valorAcumulado;
  String get valorAtualizado => _valorAtualizado;
  String get prazo => _prazo;


  // Setters
  set valorMensal(String novoValorMensal) {
    if (novoValorMensal.length <= 255) {
      _valorMensal = novoValorMensal;
    }
  }

  set valorAcumulado(String novoValorAcumulado) {
    if (novoValorAcumulado.length <= 255) {
    _valorAcumulado = novoValorAcumulado;
    }
  }

  set valorAtualizado(String novoValorAtualizado) {
    if (novoValorAtualizado.length <= 255) {
    _valorAtualizado = novoValorAtualizado;
    }
  }

  set prazo(String novoPrazo) {
    _prazo = novoPrazo;
  }

  // Método que transforma o objeto em Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['valorMensal'] = _valorMensal;
    map['valorAcumulado'] = _valorAcumulado;
    map['valorAtualizado'] = _valorAtualizado;
    map['prazo'] = _prazo;

    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }


  // Contrutor nomeado que transforma map no objeto
  Aplicacao.fromObject(dynamic o) {
    this._id = o['id'];
    this._valorMensal = o['valorMensal'];
    this._valorAcumulado = o['valorAcumulado'];
    this._valorAtualizado = o['valorAtualizado'];
    this._prazo = o['prazo'];
  }

}