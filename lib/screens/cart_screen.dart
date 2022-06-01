import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  List<Map<String, dynamic>> val;

  CartScreen(this.val);

  @override
  _CartScreenState createState() => _CartScreenState(val);
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _val;

  _CartScreenState(this._val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
      ),
      body: getBody(),
    );
  }


  Widget getBody() {
    return Container(
      child: ListView.separated(
        itemCount: _val.length,
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
                child: Image.network(_val[index]['picture']!,
                  width: 40,),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_val[index]['productName']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Quantity: ${_val[index]['textVal']}"),
                    Text("Price: ${_val[index]['price']!}"),
                  ],
                ),

                Text(
                    "Selected Color: ${_val[index]['colors'][_val[index]['radVal']]!}"),
                Text("Selected Brand: ${_val[index]['dropVal']!}"),
                Row(
                  children: [
                    Text("Total Price: \$${_val[index]['total']}"),

                  ],
                ),


              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

}
