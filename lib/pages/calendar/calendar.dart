import 'package:flutter/material.dart';
import 'package:app_medicamentos/pages/home_page.dart';
import 'package:app_medicamentos/pages/profile/profile_page.dart';
import 'package:app_medicamentos/pages/records/records.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:app_medicamentos/pages/layout/bottom_navbar.dart';
import 'package:app_medicamentos/utils/button.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class CalendarPage extends StatefulWidget{
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState(){
    return _CalendarPage();
  }
}

class _CalendarPage extends State <CalendarPage>{
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEDF2FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'Calendario',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF09184D)),
            onPressed: () {
              Navigator.pushAndRemoveUntil <dynamic>(
                context,
                MaterialPageRoute <dynamic>(
                    builder: (BuildContext context) => HomePage()
                ),
                    (route) => false,
              );
            },
          ),
          actions: const [],
          backgroundColor: const Color(0xFFEDF2FA),
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
        ),
      ),

      body: Container(
          height: calendarPageCards.length * 120 + 350, // Establece la altura del Container a 200 píxeles
          child: ListView(
            children: <Widget>[
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.single,
                showNavigationArrow: true,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  CreateCards(context, args.value.toString());
                },
                todayHighlightColor: Color(0xFF09184D),
                selectionColor: Color(0xFF09184D),
              ),
              const SizedBox(height: 20.0,),
              const Text(
                'Eventos de ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              )
            ]
                + calendarPageCards
            ,
          )
      ),

      bottomNavigationBar: Container(
        child: CustomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (index == 1) {

            } else if (index == 2) {
              muestraButtonSheet();
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));//Registros
            } else if (index == 4) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            }
          },
        ),
      ),
    );
  }

  void muestraButtonSheet(){
    final int bandShow = 0;
    // band: revisar que valor tiene para mostrar los widgets qe necesites
    //final bool num = 0;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0)
          )
      ),
      context: context,
      builder: (BuildContext context){
        return SizedBox(
            height: 350,
            child: Center(
              // child: bandShow == 1 ? Column(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (bandShow == 0)
                    Column(
                      children: [
                        Button(color: 0xFF0D1C52,
                          ancho: 263,
                          alto: 71,
                          contenido: 'Agregar medicamento',
                          ruta: 0,
                        ),
                        const SizedBox(width: 0.0, height: 60.0,),
                        Button(color: 0xFF0D1C52,
                          ancho: 263,
                          alto: 71,
                          contenido: 'Agregar cita médica',
                          ruta: 1,
                        )
                      ],
                    ),

                  if (bandShow == 1)
                    Column(
                      children: [
                        Text('Medicamento agregado con éxito',),
                        const SizedBox(width: 0.0, height: 60.0,),
                        Button(color: 0xFF0063C9, ancho: 180, alto: 60, contenido: 'Aceptar', ruta: 2,),
                      ],
                    ),

                  if (bandShow == 2)
                    Column(
                      children: [
                        Text('Error al agregar medicamento',),
                        const SizedBox(width: 0.0, height: 60.0,),
                        Button(color: 0xFF0063C9, ancho: 180, alto: 60, contenido: 'Aceptar', ruta: 2,),
                      ],
                    ),

                  if (bandShow == 3)
                    Column(
                      children: [
                        Text('Cita agregada con éxito',),
                        const SizedBox(width: 0.0, height: 60.0,),
                        Button(color: 0xFF0063C9, ancho: 180, alto: 60, contenido: 'Aceptar', ruta: 2,),
                      ],
                    ),

                  if (bandShow == 4)
                    Column(
                      children: [
                        Text('Error al agregar cita',),
                        const SizedBox(width: 0.0, height: 60.0,),
                        Button(color: 0xFF0063C9, ancho: 180, alto: 60, contenido: 'Aceptar', ruta: 2,),
                      ],
                    )
                ],
              ) ,
            )
        );
      },
    );
  }

  Future<void> CreateCards(var context, String date) async {
    try{
      calendarPageCards.clear();
      Database database = await openDatabase(
          Path.join(await getDatabasesPath(), 'medicamentos.db'), version: 1);

      print("SELECT * FROM Medicamento LIKE '" + date.toString().split(" ")[0] + "%'");

      final List<Map<String, dynamic>> medicamentos = await database.rawQuery(
        "SELECT * FROM Medicamento WHERE inicioToma LIKE '" + date.toString().split(" ")[0] + "%'",
      );
      print("map: " + medicamentos.length.toString());

      if(medicamentos.length > 0){
        for(int i = 0; i < medicamentos.length; i++){
          calendarPageCards.add(Card(
            elevation: 3, // Elevación para dar profundidad al card
            margin: EdgeInsets.all(16), // Margen alrededor del card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Borde redondeado con radio de 15
            ),
            child: ListTile(
              leading: Icon(Icons.medication_liquid, size: 40), // Icono de medicina a la izquierda
              title: Text(
                medicamentos[i]['nombre'].toString(), //Nombre del medicamento
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de Medicamento'),
                  Text("Dosis: " + medicamentos[i]['dosis'].toString()), //Dosis del medicamento
                ],
              ),
              trailing: Text(
                "Inicio: " + medicamentos[i]['inicioToma'].toString().split(" ")[0], //Fecha de inicio
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
          );
        }
        Navigator.pushAndRemoveUntil <dynamic>(
          context,
          MaterialPageRoute <dynamic>(
              builder: (BuildContext context) => const CalendarPage()
          ),
              (route) => false,
        );
      }
      print("cards: " + calendarPageCards.length.toString());
    }catch(exception){
      print(exception);
    }
  }
}

List<Widget> calendarPageCards = [];