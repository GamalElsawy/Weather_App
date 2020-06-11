import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_app/util/utilty.dart' as utility;
import 'package:http/http.dart' as ht;
import 'dart:async';
import 'dart:convert' as dc;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _cityEntered;
  showStuff() async{
    Map data  = await getWeather(utility.AppId, utility.defaultCity);
    print(data.toString());
  }

  Future _goToNext(BuildContext context) async{
    index = r.nextInt(3);
    var res = await Navigator.of(context).push(
        MaterialPageRoute<dynamic> (

            builder: (BuildContext context){

              return changeCity();
            })

    );
    Map x = res;
    if(x.containsKey('enter')&& x != null){
      _cityEntered = x['enter'];
      //print(x['enter'].toString());
      //_nameFieldController.text = x['info'].toString();
    }else print('NoThing');

  }
  int index = 0;

  void changeIndex() {
    setState(() => index = r.nextInt(3));
  }
  Set<IconData> icn = {Icons.cloud_circle,Icons.cloud,Icons.cloud_queue,Icons.cloud_done};
  Random r = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Colors.blue,),
            onPressed: (){_goToNext(context);},
          ),
        ],
        title: Text("Weather Hup",style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
            child: Icon(icn.elementAt(index),size: 200.0,color: Colors.white,),
          ),
          //Center(
            /*child: Image.asset(
              "assets/y.jpg",
              fit: BoxFit.fill,
              height: 1200.0,
              width: 490.0,
            ),*/
            //child: Container(color: Colors.blue,),
          //),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
            child: Text(
              '${_cityEntered == null ? utility.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          /*Center(
            child: Container(
              //alignment: Alignment.center,
              child: Image.asset("assets/z.png"),
              width: 200.0,
              height: 100.0,
            ),
          ),*/
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 0.0),
            alignment: Alignment.bottomLeft,
            child: UpdateTempWid(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String id,String city) async{
    String apiurl = "https://api.openweathermap.org/data/2.5/weather?q=${city}"
        "&APPID=${utility.AppId}&units=metric";

    ht.Response res = await ht.get(apiurl);
    return dc.json.decode(res.body);
  }

  Widget UpdateTempWid(String city){
    return FutureBuilder(
      future: getWeather(utility.AppId, city == null ? utility.defaultCity : city),
      builder: (BuildContext context,AsyncSnapshot<Map> shapshot){
          if(shapshot.hasData){
            Map content = shapshot.data;
            return Container(
              //alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[
                  
                  ListTile(
                    title: Column(

                      children: <Widget>[
                        Text("MAX: "+content['main']['temp_max'].toString()+" °C",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            color: Colors.white,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        Text("Min: "+content['main']['temp_min'].toString()+" °C",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 30.0,
                              color: Colors.white,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        SizedBox(height: 7.0,),
                        Divider(color: Colors.white,),
                        Text("Humidity: "+content['main']['humidity'].toString()+ " %",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 40.0,
                              color: Colors.white,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        Text("Pressure: "+content['main']['pressure'].toString() ,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 40.0,
                              color: Colors.white,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),

                  )
                ],
              ),
            );
          }else{
            return Container();
          }
      });
  }




}

class changeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        title: Text('Change City',style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          /*Center(
            child:Image.asset('assets/z.png',width: 490.0,height: 1200,fit: BoxFit.fill,)
            ,
          ),*/
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText:'Enter City'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.blue,
                  style: TextStyle(color: Colors.blue,fontStyle: FontStyle.italic),
                ),
              ),
              ListTile(
                title: FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter':_cityFieldController.text
                      });
                    },
                    child: Text('Get Weather'),
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                  

                ),
              )
            ],
          )

        ],
      ),
    );
  }
}



TextStyle cityStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 50.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
