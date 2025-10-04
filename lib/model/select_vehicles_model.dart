class SelectVehicleModel {
  int? status;
  String? message;
  List<Data>? data;

  SelectVehicleModel({this.status, this.message, this.data});

  SelectVehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? vehicleId;
  String? vehicleName;
  int? bodyDetailId;
  String? bodyDetails;
  String? bodyType;
  String? vehicleImage;
  double? amount;
  int? selectedStatus;

  Data(
      {this.vehicleId,
        this.vehicleName,
        this.bodyDetailId,
        this.bodyDetails,
        this.bodyType,
        this.vehicleImage,
        this.amount,
        this.selectedStatus});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    vehicleName = json['vehicle_name'];
    bodyDetailId = json['body_detail_id'];
    bodyDetails = json['body_details'];
    bodyType = json['body_type'];
    vehicleImage = json['vehicle_image'];
    amount = (json['amount'] as num?)?.toDouble();
    selectedStatus = json['selected_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['vehicle_name'] = vehicleName;
    data['body_detail_id'] = bodyDetailId;
    data['body_details'] = bodyDetails;
    data['body_type'] = bodyType;
    data['vehicle_image'] = vehicleImage;
    data['amount'] = amount;
    data['selected_status'] = selectedStatus;
    return data;
  }
}
