class TripEstimatedDetailsModel {
  TripEstimatedDetailsModel({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });

  List<String>? destinationAddresses;
  List<String>? originAddresses;
  List<RowM>? rows;
  String? status;

  factory TripEstimatedDetailsModel.fromJson(Map<String, dynamic> json) =>
      TripEstimatedDetailsModel(
        destinationAddresses:
            List<String>.from(json["destination_addresses"].map((x) => x)),
        originAddresses:
            List<String>.from(json["origin_addresses"].map((x) => x)),
        rows: List<RowM>.from(json["rows"].map((x) => RowM.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "destination_addresses":
            List<dynamic>.from(destinationAddresses!.map((x) => x)),
        "origin_addresses": List<dynamic>.from(originAddresses!.map((x) => x)),
        "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
        "status": status,
      };
}

class RowM {
  RowM({
    this.elements,
  });

  List<TripNumericDetailsM>? elements;

  factory RowM.fromJson(Map<String, dynamic> json) => RowM(
        elements: List<TripNumericDetailsM>.from(
            json["elements"].map((x) => TripNumericDetailsM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": List<dynamic>.from(elements!.map((x) => x.toJson())),
      };
}

class TripNumericDetailsM {
  TripNumericDetailsM({
    this.distance,
    this.duration,
    this.status,
  });

  Distance? distance;
  Distance? duration;
  String? status;

  factory TripNumericDetailsM.fromJson(Map<String, dynamic> json) =>
      TripNumericDetailsM(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance!.toJson(),
        "duration": duration!.toJson(),
        "status": status,
      };
}

class Distance {
  Distance({
    this.text,
    this.value,
  });

  String? text;
  int? value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
