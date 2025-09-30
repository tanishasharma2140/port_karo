class UserHistoryModel {
  List<Data>? data;
  bool? success;
  String? message;

  UserHistoryModel({this.data, this.success, this.message});

  UserHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? deviceId;
  String? firstName;
  String? lastName;
  String? email;
  String? type;
  int? phone;
  int? status;
  dynamic wallet;
  dynamic fcm;
  String? createdAt;
  String? updatedAt;
  int? userid;
  String? vehicleType;
  String? pickupAddress;
  String? pickupLatitute;
  String? pickLongitude;
  String? dropAddress;
  String? dropLatitute;
  String? dropLogitute;
  String? senderName;
  int? senderPhone;
  String? reciverName;
  int? reciverPhone;
  int? rideStatus;
  dynamic driverId;
  int? amount;
  int? distance;
  String? datetime;
  int? paymentStatus;
  int? paymode;
  dynamic txnId;
  String? goodsType;
  String? dbVehicleName;
  String? vehicleImage;
  String? amountPrKm;
  String? vehicleName;

  Data(
      {this.id,
        this.deviceId,
        this.firstName,
        this.lastName,
        this.email,
        this.type,
        this.phone,
        this.status,
        this.wallet,
        this.fcm,
        this.createdAt,
        this.updatedAt,
        this.userid,
        this.vehicleType,
        this.pickupAddress,
        this.pickupLatitute,
        this.pickLongitude,
        this.dropAddress,
        this.dropLatitute,
        this.dropLogitute,
        this.senderName,
        this.senderPhone,
        this.reciverName,
        this.reciverPhone,
        this.rideStatus,
        this.driverId,
        this.amount,
        this.distance,
        this.datetime,
        this.paymentStatus,
        this.paymode,
        this.txnId,
        this.goodsType,
        this.dbVehicleName,
        this.vehicleImage,
        this.amountPrKm,
        this.vehicleName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['device_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    type = json['type'];
    phone = json['phone'];
    status = json['status'];
    wallet = json['wallet'];
    fcm = json['fcm'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userid = json['userid'];
    vehicleType = json['vehicle_type'];
    pickupAddress = json['pickup_address'];
    pickupLatitute = json['pickup_latitute'];
    pickLongitude = json['pick_longitude'];
    dropAddress = json['drop_address'];
    dropLatitute = json['drop_latitute'];
    dropLogitute = json['drop_logitute'];
    senderName = json['sender_name'];
    senderPhone = json['sender_phone'];
    reciverName = json['reciver_name'];
    reciverPhone = json['reciver_phone'];
    rideStatus = json['ride_status'];
    driverId = json['driver_id'];
    amount = json['amount'];
    distance = json['distance'];
    datetime = json['datetime'];
    paymentStatus = json['payment_status'];
    paymode = json['paymode'];
    txnId = json['txn_id'];
    goodsType = json['goods_type'];
    dbVehicleName = json['db_vehicle_name'];
    vehicleImage = json['vehicle_image'];
    amountPrKm = json['amount_pr_km'];
    vehicleName = json['vehicle_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['device_id'] = deviceId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['type'] = type;
    data['phone'] = phone;
    data['status'] = status;
    data['wallet'] = wallet;
    data['fcm'] = fcm;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['userid'] = userid;
    data['vehicle_type'] = vehicleType;
    data['pickup_address'] = pickupAddress;
    data['pickup_latitute'] = pickupLatitute;
    data['pick_longitude'] = pickLongitude;
    data['drop_address'] = dropAddress;
    data['drop_latitute'] = dropLatitute;
    data['drop_logitute'] = dropLogitute;
    data['sender_name'] = senderName;
    data['sender_phone'] = senderPhone;
    data['reciver_name'] = reciverName;
    data['reciver_phone'] = reciverPhone;
    data['ride_status'] = rideStatus;
    data['driver_id'] = driverId;
    data['amount'] = amount;
    data['distance'] = distance;
    data['datetime'] = datetime;
    data['payment_status'] = paymentStatus;
    data['paymode'] = paymode;
    data['txn_id'] = txnId;
    data['goods_type'] = goodsType;
    data['db_vehicle_name'] = dbVehicleName;
    data['vehicle_image'] = vehicleImage;
    data['amount_pr_km'] = amountPrKm;
    data['vehicle_name'] = vehicleName;
    return data;
  }
}
