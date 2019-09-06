import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () {
                _salvarAnotacao();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            ),
          ],
          title: Text("Adicionar anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Digite título.."
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite descrição.."
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  _recuperarAnotacoes() async {

    List<Anotacao> listaTemporaria = List<Anotacao>();
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }
    setState(() {
     _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;

  }

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    
    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();

  }

  _formatarData(String data){
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat("d/M/y - H:m:s");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormaada = formatador.format(dataConvertida);

    return dataFormaada;

  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount:  _anotacoes.length,
              itemBuilder: (context, index){
                final item = _anotacoes[index];
                return Card(
                  child: ListTile(
                    title: Text(item.titulo),
                    subtitle: Text("${ _formatarData(item.data)} - ${item.descricao}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
        _exibirTelaCadastro();

        },
      ),
      
    );
  }
}