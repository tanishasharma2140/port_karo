class SelectVehiclesModel {
  List<Data>? data;
  int? status;
  String? message;

  SelectVehiclesModel({this.data, this.status, this.message});

  SelectVehiclesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? image;
  int? time;
  int? price;
  int? maxWeight;
  String? datetime;

  Data(
      {this.id,
        this.name,
        this.image,
        this.time,
        this.price,
        this.maxWeight,
        this.datetime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    time = json['time'];
    price = json['price'];
    maxWeight = json['max_weight'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['time'] = time;
    data['price'] = price;
    data['max_weight'] = maxWeight;
    data['datetime'] = datetime;
    return data;
  }
}
