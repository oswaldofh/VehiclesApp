import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vehicles_app/components/loader_component.dart';

import 'package:vehicles_app/helpers/constans.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/procedure_screen.dart';

class ProceduresScreen extends StatefulWidget {
  final Token token;

  ProceduresScreen({required this.token});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedures = [];
  bool _showLoader = false;

  @override
  void initState() {
    //se llama cuando la pantalla cambia
    super.initState();

    _getProcedures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimientos'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        //agregar un boton flotante
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProcedureScreen(
                      token: widget.token,
                      procedure: Procedure(id: 0, description: '', price: 0))));
        },
      ),
    );
  }

  void _getProcedures() async {
    setState(() {
      _showLoader = true;
    });
    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
    );

    setState(() {
      _showLoader = false;
    });
    var body = response.body;
    var decodedjson = jsonDecode(body);

    if (decodedjson != null) {
      for (var item in decodedjson) {
        _procedures
            .add(Procedure.fromJson(item)); //se cargan todos los procedimientos
      }
    }

    print(_procedures);
  }

  Widget _getContent() {
    return _procedures.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: const Text(
          'No hay procedimientos almacenados..',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _procedures.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProcedureScreen(token: widget.token, procedure: e)));
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.description,
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${NumberFormat.currency(symbol: '\$').format(e.price)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ); //cuando hacen clic en cualquiera de ellos
      }).toList(),
    );
  }
}
