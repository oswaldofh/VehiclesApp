import 'package:flutter/material.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/login_screens.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: _getBody(),
      drawer: _getMechanicMenu(), //es el menu
    );
  }

  Widget _getBody() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Center(
        child: Text(
          'Bienvenid@ ${widget.token.user.fullName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getMechanicMenu() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
            child: Image(
          image: AssetImage('assets/vehicles.png'),
        )),
        ListTile(
          leading: const Icon(Icons.two_wheeler),
          title: const Text('Marcas'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.precision_manufacturing),
          title: const Text('Procedimientos'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.badge),
          title: const Text('Tipo de Documentos'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.toys),
          title: const Text('Tipo de Vehiculos'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Usuarios'),
          onTap: () {},
        ),
        const Divider(
          color: Colors.black,
          height: 2,
        ),
        ListTile(
          leading: const Icon(Icons.face),
          title: const Text('Editar Perfil'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar Sesión'),
          onTap: () {
            Navigator.pushReplacement(
              //navegar entre paginas
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
    ));
  }
}
