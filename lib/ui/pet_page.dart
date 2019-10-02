import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/helpers/pet_helper.dart';

class PetPage extends StatefulWidget {

  final Pet pet;

  PetPage({this.pet});

  @override
  _PetPageState createState() => _PetPageState();
}

enum SingingCharacter { Femea, Macho }



class _PetPageState extends State<PetPage> {

  SingingCharacter _character = SingingCharacter.Femea;

  final format = DateFormat("dd-MM-yyyy");

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Pet _editedPet;

  @override
  void initState() {
    super.initState();

    if(widget.pet == null){
      _editedPet = Pet();
    } else {
      _editedPet = Pet.fromMap(widget.pet.toMap());

      _nameController.text = _editedPet.name;
//      _emailController.text = _editedPet.email;
//      _phoneController.text = _editedPet.phone;
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(_editedPet.name ?? "Novo Pet"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedPet.name != null && _editedPet.name.isNotEmpty){
              Navigator.pop(context, _editedPet);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedPet.img != null ?
                        FileImage(File(_editedPet.img)) :
                        AssetImage("images/animal.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){
                  _showOptions(context);
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "name"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedPet.name = text;
                  });
                },
              ),

              new Text('Sexo', textAlign: TextAlign.left,),

              RadioListTile<SingingCharacter>(
                title: const Text('Femea'),
                value: SingingCharacter.Femea,
                groupValue: _character,
                onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text('Macho'),
                value: SingingCharacter.Macho,
                groupValue: _character,
                onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Peso"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedPet.name = text;
                  });
                },
              ),
              new Text('Data Nascimento', textAlign: TextAlign.left,),
              DateTimeField(
                format: format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
              ),




            ],
          ),
        ),
      ),
    );
  }


  void _showOptions(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Galeria",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          //launch("tel:${ads[index].phone}");
                          ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                            if(file == null) return;
                            setState(() {
                              _editedPet.img = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Camera",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.camera).then((file){
                            if(file == null) return;
                            setState(() {
                              _editedPet.img = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                        /*onPressed: (){
                          Navigator.pop(context);
                          _showAdPage(ad: ads[index]);
                        },*/

                      ),
                    ),

                  ],
                ),
              );
            },
          );
        }
    );
  }



  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}


