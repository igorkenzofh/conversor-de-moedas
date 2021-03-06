// TODO 24: Importar packages
import 'package:flutter/material.dart';
import 'main.dart';

// TODO 23: Colcoar a classe criada do textField em outro arq dart
class CampoConv extends StatelessWidget {
  // TODO 20: Criar construtor
  CampoConv({this.textoLabel, this.textoPrefix, this.controller, this.funcaoF});

  // TODO 21: Criar vars e botar no constructor
  final String textoLabel;
  final String textoPrefix;
  // TODO 27 Criar var controller, botar no construtor tb
  final TextEditingController controller;
  // TODO 31: Criar var funcao e botar no constructor
  final Function funcaoF;

  @override
  Widget build(BuildContext context) {
    // TODO 17: Criando o TextField
    return TextField(
      // TODO 28: declarar controller
      controller: controller, // Adicionado após os controllers no main
      style: TextStyle(color: Colors.amber, fontSize: 25),
      decoration: InputDecoration(
        // TODO 22: Substituir vars nos locais certos
        labelText: textoLabel,
        prefixText: textoPrefix,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      // TODO 30: Função para quando campo for alterado
      onChanged: funcaoF, // Adicionado depois das funções em main
      // TODO 33: Alterando para o teclado ser só de números
      keyboardType: TextInputType.numberWithOptions(
          decimal: true), // Faz o teclado de números aparecer
    );
  }
}
