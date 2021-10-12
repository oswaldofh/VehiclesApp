import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/brand.dart';

import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/brand_screen.dart';

class BrandsScreen extends StatefulWidget {
  final Token token;

  BrandsScreen({required this.token});

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<Brand> _brands = [];
  bool _showLoader = false;

  bool _isFilter = false;
  String _search = '';

  @override
  void initState() {
    //se llama cuando la pantalla cambia
    super.initState();

    _getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcas'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          _isFilter
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
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
        onPressed: () => _goAdd(),
      ),
    );
  }

  Future<Null> _getBrands() async {
    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.getBrands(widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    setState(() {
      _brands = response.result;
    });
  }

  Widget _getContent() {
    return _brands.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFilter
              ? 'No hay marcas con ese criterio de busqueda..'
              : 'No hay marcas registradas..',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getBrands, //se refresca la pantalla al bajarla
      child: ListView(
        children: _brands.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goEdit(e),
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
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ); //cuando hacen clic en cualquiera de ellos
        }).toList(),
      ),
    );
  }

  void _removeFilter() {
    setState(() {
      _isFilter = false;
    });
    _getBrands();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Filtrar marcas'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras de la marca'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Criterio de busqueda...',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar')),
            ],
          );
        });
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Brand> filteredList = [];

    for (var brand in _brands) {
      if (brand.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(brand);
      }
    }
    setState(() {
      _brands = filteredList;
      _isFilter = true;
    });

    Navigator.of(context).pop();
  }

  void _goAdd() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BrandScreen(
                token: widget.token, brand: Brand(id: 0, description: ''))));

    if (result == 'yes') {
      _getBrands();
    }
  }

  void _goEdit(Brand brand) async {
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BrandScreen(token: widget.token, brand: brand)));

    if (result == 'yes') {
      _getBrands();
    }
  }
}
