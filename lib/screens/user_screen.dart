import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/document_type.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;

  UserScreen({required this.token, required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _showLoader = false;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  TextEditingController _lastNameController = TextEditingController();

  DocumentType _documentType = DocumentType(id: 0, description: '');
  List<DocumentType> _documentTypes = [];

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  TextEditingController _documentController = TextEditingController();

  String _adress = '';
  String _adressError = '';
  bool _adressShowError = false;
  TextEditingController _adressController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDocumentTypes();

    _firstName = widget.user.firstName;
    _firstNameController.text = _firstName;

    _lastName = widget.user.lastName;
    _lastNameController.text = _lastName;

    _documentType = widget.user.documentType;

    _document = widget.user.document;
    _documentController.text = _document;

    _adress = widget.user.address;
    _adressController.text = _adress;

    _email = widget.user.email;
    _emailController.text = _email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
            widget.user.id.isEmpty ? 'Nuevo usuario' : widget.user.fullName),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            //para que quepan en la pantalla
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _showFirstName(),
                _showLastName(),
                _showDocumentType(),
                _showDocument(),
                _showEmail(),
                _showAdress(),
                _showPhoneNumber(),
                _showButton(),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showFirstName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _firstNameController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa Nombres...',
          labelText: 'Nombres',
          errorText: _firstNameShowError ? _firstNameError : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _firstName = value;
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
              onPressed: () => _save(),
            ),
          ),
          widget.user.id.isEmpty ? Container() : const SizedBox(width: 20),
          widget.user.id.isEmpty
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmDelete(),
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

  void _save() {
    if (!_validateFields()) {
      return;
    }

    widget.user.id.isEmpty ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar al menos nombre';
    } else {
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar al menos un apellido';
    } else {
      _lastNameShowError = false;
    }

    if (_document.isEmpty) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Debes ingresar el numero del documento';
    } else {
      _documentShowError = false;
    }

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes  ingresar un email valido';
    } else {
      _emailShowError = false;
    }

    if (_adress.isEmpty) {
      isValid = false;
      _adressShowError = true;
      _adressError = 'Debes ingresar una direccion';
    } else {
      _adressShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar el numero de telefono';
    } else {
      _phoneNumberShowError = false;
    }

    setState(() {});

    return isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'firstNmae': _firstName,
      'lastNmae': _lastName,
      'document': _document,
      'documentType': 1,
      'email': _email,
      'userName': _email,
      'adress': _adress,
      'phoneNumber': _phoneNumber,
    };

    setState(() {
      _showLoader = false;
    });

    Response response =
        await ApiHelper.post('/api/Users/', request, widget.token.token);
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
    Navigator.pop(context, 'yes'); //yes recarga la pantalla
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'firstNmae': _firstName,
      'lastNmae': _lastName,
      'document': _document,
      'documentType': 1,
      'email': _email,
      'userName': _email,
      'adress': _adress,
      'phoneNumber': _phoneNumber,
    };

    setState(() {
      _showLoader = false;
    });

    Response response = await ApiHelper.put(
        '/api/Users/', widget.user.id, request, widget.token.token);
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
    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: 'Estas seguro de borrar el registro',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'Si'),
        ]);

    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.delete(
        '/api/Users/', widget.user.id, widget.token.token);

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
    Navigator.pop(context, 'yes');
  }

  Widget _showPhoto() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: widget.user.id.isEmpty
          ? Image(
              image: AssetImage('assets/no_image.png'),
              height: 160,
              width: 160,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: FadeInImage(
                placeholder: AssetImage('assets/vehicles.png'),
                image: NetworkImage(widget.user.imageFullPath),
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _showLastName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa Apellidos...',
          labelText: 'Apellidos',
          errorText: _lastNameShowError ? _lastNameError : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _showDocumentType() {
    //TODO : pendin to implement
    return Container();
  }

  Widget _showDocument() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _documentController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa documento...',
          labelText: 'Documento',
          errorText: _documentShowError ? _documentError : null,
          suffixIcon: Icon(Icons.assignment_ind),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _document = value;
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailController, //para que precarge la descripcion
        keyboardType: TextInputType.emailAddress, //tipo de correo
        decoration: InputDecoration(
          hintText: 'Ingresa email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showAdress() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _adressController, //para que precarge la descripcion
        keyboardType: TextInputType.streetAddress, //tipo de direccion
        decoration: InputDecoration(
          hintText: 'Ingresa dirección...',
          labelText: 'Dirección',
          errorText: _adressShowError ? _adressError : null,
          suffixIcon: Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _adress = value;
        },
      ),
    );
  }

  Widget _showPhoneNumber() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController, //para que precarge la descripcion
        keyboardType: TextInputType.phone, //tipo de direccion
        decoration: InputDecoration(
          hintText: 'Ingresa el telefono...',
          labelText: 'Telefono',
          errorText: _phoneNumberShowError ? _phoneNumberError : null,
          suffixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

  Future<Null> _getDocumentTypes() async {
    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.getDocumetTypes(widget.token.token);

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
      _documentTypes = response.result;
    });
  }
}
