// TODO 1: Importar packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO 3: Importar packages http, async e convert
import 'package:http/http.dart' as http;
import 'dart:async'; // requisição que faz e não precisa ficar esperando receber
import 'dart:convert'; // Para transformar arquiv json
//TODO 25: Importar dart file novo
import 'classes.dart';

// TODO 2: Pegar as chaves da API
// CHAVE API HG FINANCE = 5de89a6b
// autenticação e chave: https://api.hgbrasil.com/finance?key=5de89a6b
// formatos de retorno: 5de89a6b
// Site para visualizar arq JSON: https://jsoneditoronline.org/

// TODO 4: Declarar var request = api + chave
const request = 'https://api.hgbrasil.com/finance?key=5de89a6b';

// TODO 5: Criar main normal como sempre, mas async pq o retorno de dados vai ser no futuro
void main() async {
  // Async pq n retorna os dados na hora, faz a requisição e qnd receber faz algo

  // TIRADO DAQUI PARA COLCOAR EM getData()
  // http.Response response = await http.get(
  //   request); // Não retorna os dados na hora, por isso add o await e o async em cima
  // ignore: unnecessary_statements
  // print(json.decode(response.body)['results']['currencies']['USD']);

  runApp(
    MaterialApp(
      home: Home(),
      // TODO 7: Antes de home era materialapp
      // TODO 18: O prefix do texto (hint color) nao aparece mesmo trocando a cor para white, então criar um tema
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

// TODO 6: Criando uma função para retornar um dado futuro (q n chega na hora)
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

// TODO 8: Criar Stful  Home
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO 26: Criar controladores para obter os dados dos campos
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  // TODO 11: Declarar var dolar e euro
  double dolar;
  double euro;

  // TODO 29: Criar função para descobrir quando o campo é alterado
  void _realChanged(String text) {
    //TODO 33: Função para pegar o valor do real que escreveu no input
    double real = double.parse(text); // Converte o String em double
    dolarController.text = (real / dolar)
        .toStringAsFixed(2); // Converter para dolar e euro mostrando 2 casas
    euroController.text = (real / euro)
        .toStringAsFixed(2); // Converter para dolar e euro mostrando 2 casas

    // TODO 37: Aplicando função de reset
    if (text.isEmpty) {
      _resetall();
      return;
    }
  }

  void _dolarChanged(String text) {
    // TODO 34: Função para pegar valor do dolar e converter
    double dolar = double.parse(
        text); // Essa var dolar tem o mesmo nome da de cima, mas nao e a mesma
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    // como n temos a conv direita de dolar>euro, estamos transformando dolar>real e dps euro
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

    if (text.isEmpty) {
      _resetall();
      return;
    }
  }

  void _euroChanged(String text) {
    // TODO 35: Função para pegar valor do euro e converter
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

    if (text.isEmpty) {
      _resetall();
      return;
    }
  }

  // TODO 36: Criando função apra resetar campos
  void _resetall() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO 9: Criar Scaffold
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _resetall();
              })
        ],
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        // TODO 10: Criar um FutureBuilder
        // o Future builder vai fazer aparecer 'Carregando'. <Map> pq o JSON retorna um Map
        future: getData(), // o futuro dos nossos dados será o getData
        builder: (context, snapshot) {
          // precisa especificar oq vai aparecer na tela para cada caso
          switch (snapshot.connectionState) {
            // Ve qual o estado da conexão
            case ConnectionState.none: // Caso não estiver conectado
            case ConnectionState.waiting: // ou/e caso não estiver esperando
              return Center(
                // Ele me retorna Esse widget
                child: Text(
                  'Carregando Dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default: // Caso o que ele obteve
              if (snapshot.hasError) {
                // For um erro, então
                return Center(
                  // me retorna esse widget
                  child: Text(
                    'Erro ao carregar dados! :/',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                // Caso contrário, se n houver erro,
                // obtem valor do dolar e euro
                // TODO 12: Para pegar valor de compra do dolar e euro usando a API
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                // e retorna esse Widget
                // TODO 13: Retornando uma tela scrolable ao inves de eum container
                return SingleChildScrollView(
                  // TODO 18: Adicionar um padding para nao ocupar a width inteira
                  padding: EdgeInsets.all(10.0),
                  // TODO 14: Precisar ser uma coluna pois tem varios itens na verti
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TODO 15: Essa tela terá um icone
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      Divider(),
                      // TODO 16: E três campos TextField
                      // TODO 19: Transformar o textField em uma classe para economizar
                      CampoConv(
                        textoLabel: 'Reais',
                        textoPrefix: 'R\$ ',
                        // TODO 28: Declarar controller do real, dolar e euro
                        controller: realController,
                        // TODO 32: Passar as função para a funcaoF
                        funcaoF: _realChanged,
                      ),
                      // TODO 22: Botar os Dividers para dividir os elementos
                      Divider(),
                      CampoConv(
                        textoLabel: 'Dólares',
                        textoPrefix: 'US\$ ',
                        controller: dolarController,
                        funcaoF: _dolarChanged,
                      ),
                      Divider(),
                      CampoConv(
                        textoLabel: 'Euros',
                        textoPrefix: '€ ',
                        controller: euroController,
                        funcaoF: _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
