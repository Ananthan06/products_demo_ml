class ProductsResponse {
  String? sId;
  String? price;
  String? picture;
  List<String>? colors;
  String? productName;
  List<Brands>? brands;

  ProductsResponse({this.sId,
    this.price,
    this.picture,
    this.colors,
    this.productName,
    this.brands});

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    price = json['price'];
    picture = json['picture'];
    colors = json['colors'].cast<String>();
    productName = json['productName'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['price'] = this.price;
    data['picture'] = this.picture;
    data['colors'] = this.colors;
    data['productName'] = this.productName;
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? id;
  String? name;

  Brands({this.id, this.name});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}