import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi = "";
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;

  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            //bundan sonra formdaki onsaved alan çalışacak
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return uygulamaGovedesi(orientation);
          } else {
            return uygulamaGovedesiLandscape(orientation);
          }
        },
      ),
    );
  }

  Widget uygulamaGovedesi(var orientation) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //statik fromu tutan form
          Container(
            padding: EdgeInsets.all(10),
            // color: Colors.pink.shade300,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      hintText: "Ders Adını Giriniz",
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.book),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else {
                        return "Ders Adı boş olamaz";
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.add(
                          Ders(dersAdi, dersHarfDegeri, dersKredi,
                              rastgeleRenkOlustur()),
                        );
                        ortalama = 0;
                        ortalamaHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: dersKredileriItems(),
                            value: dersKredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: dersHarfDegerleriItems(),
                            value: dersHarfDegeri,
                            onChanged: (secilenHarf) {
                              setState(() {
                                dersHarfDegeri = secilenHarf;
                              });
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
//            decoration: BoxDecoration(
//              border: BorderDirectional(
//                top: BorderSide(color: Colors.blue,width: 2),
//                bottom: BorderSide(color: Colors.green,width: 2),
//
//              )
//            ),
            height: 70,
            //DECORATION verilince arkaplan rengi koyulmuyor
            color: Colors.orange.shade100,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Ortalama  : ",
                      style: TextStyle(fontSize: 30, color: Colors.black)),
                  TextSpan(
                      text: tumDersler.length != 0
                          ? "${ortalama.toStringAsFixed(2)}"
                          : " - ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),
          //Dinamik listeyi tutan form
          Expanded(
            child: Container(
              color: Colors.green.shade100,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
//     var herbirKredi = DropdownMenuItem<int>(value: i,child: Text("$i Kredi"),);
//    krediler.add(herbirKredi);
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(fontSize: 30),
        ),
      ));
    }

    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "AA",
          style: TextStyle(fontSize: 30),
        ),
        value: 4,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "BA",
          style: TextStyle(fontSize: 30),
        ),
        value: 3.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "BB",
          style: TextStyle(fontSize: 30),
        ),
        value: 3.0,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "CB",
          style: TextStyle(fontSize: 30),
        ),
        value: 2.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "CC",
          style: TextStyle(fontSize: 30),
        ),
        value: 2.0,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "DC",
          style: TextStyle(fontSize: 30),
        ),
        value: 1.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "DD",
          style: TextStyle(fontSize: 30),
        ),
        value: 1.0,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "FF",
          style: TextStyle(fontSize: 30),
        ),
        value: 0,
      ),
    );

    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    //Color olusanRastgeleRenk = rastgeleRenkOlustur();
    debugPrint("$sayac   ");
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: tumDersler[index].renk, width: 2)),
        margin: EdgeInsets.all(5),
        child: ListTile(
          leading: Icon(
            Icons.album,
            size: 36,
            color: tumDersler[index].renk,
          ),
          title: Text(tumDersler[index].ad),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: tumDersler[index].renk,
          ),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " Kredili Ders / Ders Not Değeri :" +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var oAnkiDers in tumDersler) {
      var harfDegeri = oAnkiDers.harfDegeri;
      var kredi = oAnkiDers.kredi;

      //hata var
      toplamNot += harfDegeri * kredi;
      toplamKredi += kredi;
    }

    ortalama = toplamNot / toplamKredi;
  }

  Color rastgeleRenkOlustur() {
    return Color.fromARGB(
        150 + Random().nextInt(105),
        150 + Random().nextInt(105),
        150 + Random().nextInt(105),
        150 + Random().nextInt(105));
  }

  Widget uygulamaGovedesiLandscape(Orientation orientation) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                // color: Colors.pink.shade300,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Ders Adını Giriniz",
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.book),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else {
                            return "Ders Adı boş olamaz";
                          }
                        },
                        onSaved: (kaydedilecekDeger) {
                          dersAdi = kaydedilecekDeger;
                          setState(() {
                            tumDersler.add(
                              Ders(dersAdi, dersHarfDegeri, dersKredi,
                                  rastgeleRenkOlustur()),
                            );
                            ortalama = 0;
                            ortalamaHesapla();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: dersKredileriItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: dersHarfDegerleriItems(),
                                value: dersHarfDegeri,
                                onChanged: (secilenHarf) {
                                  setState(() {
                                    dersHarfDegeri = secilenHarf;
                                  });
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                      border: BorderDirectional(
                    top: BorderSide(color: Colors.blue, width: 2),
                    bottom: BorderSide(color: Colors.green, width: 2),
                  )),
                  //height: 70,
                  //DECORATION verilince arkaplan rengi koyulmuyor
                  //color: Colors.orange.shade100,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Ortalama  : ",
                            style:
                                TextStyle(fontSize: 30, color: Colors.black)),
                        TextSpan(
                            text: tumDersler.length != 0
                                ? "${ortalama.toStringAsFixed(2)}"
                                : " - ",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
            flex: 1,
          ),
          Expanded(
            child: Container(
              color: Colors.green.shade100,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.harfDegeri, this.kredi, this.renk);
}
