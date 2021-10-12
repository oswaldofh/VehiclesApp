import 'package:flutter/material.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/login_screens.dart';
import 'package:vehicles_app/screens/procedures_screen.dart';
import 'package:vehicles_app/screens/users_screen.dart';
import 'package:vehicles_app/screens/vehicles_type_screen.dart';

import 'brands_screen.dart';
import 'documents_type_screen.dart';

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
        backgroundColor: Colors.red,
      ),
      body: _getBody(),
      drawer: widget.token.user.userType == 0
          ? _getMechanicMenu()
          : _getCustomerMenu(), //es el menu
    );
  }

  Widget _getBody() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: FadeInImage(
                //colocar la imagen del usuario
                placeholder: AssetImage('assets/vehicles.png'),
                image: NetworkImage(widget.token.user.imageFullPath),
                height: 300,
                fit: BoxFit.cover),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Bienvenid@ ${widget.token.user.fullName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                  builder: (context) => BrandsScreen(
                        token: widget.token,
                      )),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.precision_manufacturing),
          title: const Text('Procedimientos'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                  builder: (context) => ProceduresScreen(
                        token: widget.token,
                      )),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.badge),
          title: const Text('Tipo de Documentos'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentsTypeScreen(
                        token: widget.token,
                      )),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.toys),
          title: const Text('Tipo de Vehiculos'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                  builder: (context) => VehiclesTypeScreen(
                        token: widget.token,
                      )),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Usuarios'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                  builder: (context) => UsersScreen(
                        token: widget.token,
                      )),
            );
          },
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
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
    ));
  }

  Widget _getCustomerMenu() {
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
          title: const Text('Mis vehiculos'),
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
              //navegar al login
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
