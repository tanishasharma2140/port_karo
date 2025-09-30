class SelectVehicleModel {
  int? status;
  List<Data>? data;

  SelectVehicleModel({this.status, this.data});

  SelectVehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? vehicleId;
  String? vehicleName;
  String? vehicleImage;
  String? datetime;
  int? bodyTypeId;
  String? bodyType;
  String? bodyTypeImage;
  String? amountPrKm;
  String? bodyDetail;

  Data(
      {this.vehicleId,
        this.vehicleName,
        this.vehicleImage,
        this.datetime,
        this.bodyTypeId,
        this.bodyType,
        this.bodyTypeImage,
        this.amountPrKm,
        this.bodyDetail});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    vehicleName = json['vehicle_name'];
    vehicleImage = json['vehicle_image'];
    datetime = json['datetime'];
    bodyTypeId = json['body_type_id'];
    bodyType = json['body_type'];
    bodyTypeImage = json['body_type_image'];
    amountPrKm = json['amount_pr_km'];
    bodyDetail = json['body_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['vehicle_name'] = vehicleName;
    data['vehicle_image'] = vehicleImage;
    data['datetime'] = datetime;
    data['body_type_id'] = bodyTypeId;
    data['body_type'] = bodyType;
    data['body_type_image'] = bodyTypeImage;
    data['amount_pr_km'] = amountPrKm;
    data['body_detail'] = bodyDetail;
    return data;
  }
}
