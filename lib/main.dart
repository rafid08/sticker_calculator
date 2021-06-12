import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticker Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sticker Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> units = ['Inch', 'Centimeter'];
  List<String> shortUnits = ['in', 'cm'];

  int unit = 0;

  double price = 0;

  double height = 0;
  double width = 0;
  double wastage = 0;
  double leatherRate = 0;
  double embossRate = 0;

  TextEditingController widthText = TextEditingController();
  TextEditingController heightText = TextEditingController();
  TextEditingController wastageText = TextEditingController();
  TextEditingController leatherText = TextEditingController();
  TextEditingController embossText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Column(
                  children: [
                    inputTile(text: 'Width ', controller: widthText, suffix: shortUnits[unit], onChanged: (t){
                      width = double.parse((t.trim())==''?0:t.trim());
                      calculate();
                    }),
                    inputTile(text: 'Height', controller: heightText, suffix: shortUnits[unit], onChanged: (t){
                      height = double.parse((t.trim())==''?0:t.trim());
                      calculate();
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: DropdownButton<int>(
                    value: unit,
                    hint: Text(units[unit]),
                    items: List<DropdownMenuItem<int>>.generate(units.length, (index) => DropdownMenuItem<int>(value: index, child: Text(units[index]))),
                    onChanged: (index){print(index);setState(() => unit = index); calculate();},
                  ),
                )
              ],
            ),
            inputTile(text: 'Wastage', controller: wastageText, suffix: '%', onChanged: (t){
              wastage = double.parse((t.trim())==''?0:t.trim());
              calculate();
            }),
            SizedBox(height: 20,),
            inputTile(text: 'Leather Rate', controller: leatherText, suffix: '৳/sft', onChanged: (t){
              leatherRate = double.parse((t.trim())==''?0:t.trim());
              calculate();
            }),
            inputTile(text: 'Emboss Rate ', controller: embossText, suffix: '৳/pcs', onChanged: (t){
              embossRate = double.parse((t.trim())==''?0:t.trim());
              calculate();
            }),
            Container(
              height: 120,
              width: 240,
              margin: EdgeInsets.only(left: 20, top: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1,1),
                    blurRadius: 2,
                    spreadRadius: 2
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '${price.toStringAsFixed(2)} ৳',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  calculate(){
    double finalHeight = (unit==1)?(height/2.54):height;
    double finalWidth = (unit==1)?(width/2.54):width;
    double size = (((finalHeight*finalWidth)/144)*(wastage+100))/100;

    print('$height, $width, $wastage, $leatherRate, $embossRate');
    setState(() => price = (size*leatherRate)+embossRate);
  }

  Widget inputTile({String text, TextEditingController controller, String suffix, ValueChanged<String> onChanged}){
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        children: [
          Text(
            '$text : ',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20
            ),
          ),
          Container(
            height: 45,
            width: 180,
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: suffix??'',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintStyle: new TextStyle(color: Colors.grey[800]),
                hintText: "${text.trim()}...",
                fillColor: Colors.white70,
              ),
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
