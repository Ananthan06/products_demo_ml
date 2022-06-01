import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_products_mt/product_model/product_response_model.dart';
import 'package:flutter_products_mt/screens/cart_screen.dart';
import 'package:flutter_products_mt/webservice/json_value.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductsResponse> response = [];
  late ProductsResponse data;

  bool _isLoading = true;

  @override
  void initState() {
    valueFetch();
    super.initState();
  }

  valueFetch() async {
    jsonValue.forEach((v) {
      response.add(ProductsResponse.fromJson(v));
    });

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return _isLoading ? const CircularProgressIndicator() :
    Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: response.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(3),
                  width: 55,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12
                  ),
                  child: Center(
                    child: Image.network(response[index].picture!,
                      width: 40,),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(response[index].productName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    Text("Price: ${response[index].price!}"),
                    Row(
                      children:
                      getRadio(response[index].colors!, index),

                    ),
                    getSpinner(response[index].brands!,
                        response[index].brands![0].name!, index),
                    TextField(keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Qty",

                      ),
                      onChanged: (val) {
                        print(val);
                        jsonValue[index]['textVal'] = val;
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context,
                int index) => const Divider(),
          ),
        ),
        SizedBox(
          child: MaterialButton(
            onPressed: () {
              onSubmit();
            },
            child: const Text("SUBMIT"),
          ),
        )
      ],
    );
  }

  int selectedRadio = 0;

  getRadio(List<String> val, int num) {
    return List<Widget>.generate(val.length, (int index) {
      return Row(
        children: [
          Radio<int>(
            value: index,
            groupValue: jsonValue[num]['radVal'] ??= 0,
            onChanged: (int? value) {
              setState(() {
                selectedRadio = value!;
                print(value);
                jsonValue[num]['radVal'] = value;
                jsonValue[num]['colorVal'] = val[value];
              });
            },
          ),
          Text(val[index])
        ],
      );
    }
    );
  }

  getSpinner(List<Brands> val, String initVal, int num) {
    String dropdownvalue = initVal;
    return DropdownButton(
        hint: Text(jsonValue[num]['dropVal'] ?? "Select a Brand",
          style: TextStyle(
              color: Colors.black
          ),),

        // Initial Value
        // value: jsonValue[num]['dropVal'] ?? dropdownvalue,

        icon: const Icon(Icons.keyboard_arrow_down),

        items: val.map((Brands items) {
          return DropdownMenuItem(
            value: items.name,
            child: Text(items.name!),
          );
        }).toList(),

        onChanged: (newVal) {
          dropdownvalue = newVal.toString();
          print(newVal);
          setState(() {
            jsonValue[num]['dropVal'] = newVal.toString();
          });
        }
    );
  }

  onSubmit() {
    print(jsonValue);
    List<Map<String, dynamic>> _value = [];
    jsonValue.forEach((element) {
      if (element['textVal'] != null && element['textVal'] != '') {
        if (element['dropVal'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Select  Brand from spinner"),
          ));
        } else if (element['radVal'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Select a color"),
          ));
        } else {
          String _total = total(element);
          element['total'] = _total;
          _value.add(element);
        }
      }
    });

    if (_value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Atleast 1 product is required to submit"),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CartScreen(_value);
      }));
    }
    print("__________________");
    print(_value);
  }


  String total(Map<String, dynamic> value) {
    String x = value['price'].toString().split('\$')[1].toString().replaceAll(
        ',', '');
    double rate = double.parse(x);
    double total = rate * double.parse(value['textVal']);
    return total.toStringAsFixed(2);
  }
}
