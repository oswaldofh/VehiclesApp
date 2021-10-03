import 'package:flutter/material.dart';
import 'package:vehicles_app/models/procedure.dart';

import 'package:vehicles_app/models/token.dart';

class ProcedureScreen extends StatefulWidget {
  final Token token;
  final Procedure procedure;

  ProcedureScreen({required this.token, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  String _descripcion = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();

  String _price = '';
  String _priceError = '';
  bool _priceShowError = false;
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descripcion = widget.procedure.description;
    _descriptionController.text = _descripcion;
    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.procedure.id == 0
            ? 'Nuevo procedimiento'
            : widget.procedure.description),
      ),
      body: Column(
        children: <Widget>[_showDescription(), _showPrice(), _showButton()],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa una descripción...',
          labelText: 'Descripción',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _descripcion = value;
        },
      ),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa un precio...',
          labelText: 'Precio',
          errorText: _priceShowError ? _priceError : null,
          suffixIcon: Icon(Icons.attach_money),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _price = value;
        },
      ),
    );
  }

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  //return const Color(0xFFF6665);
                  return Colors.green;
                }),
              ),
              onPressed: () => {},
            ),
          ),
          widget.procedure.id == 0 ? Container() : const SizedBox(width: 20),
          widget.procedure.id == 0
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Borrar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        //return const Color(0xFE83A59);
                        return Colors.orange;
                      }),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
