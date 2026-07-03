import 'package:hive/hive.dart';

class SchemeAdapter extends TypeAdapter<Scheme> {
  @override
  final int typeId = 0;

  @override
  Scheme read(BinaryReader reader) {
    return Scheme(
      schemeCode: reader.readInt(),
      schemeName: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Scheme obj) {
    writer.writeInt(obj.schemeCode);
    writer.writeString(obj.schemeName);
  }
}

class Scheme {
  final int schemeCode;
  final String schemeName;

  Scheme({
    required this.schemeCode,
    required this.schemeName,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeCode: json['schemeCode'] as int,
      schemeName: json['schemeName'] as String,
    );
  }
}

class SchemeDetail {
  final String fundHouse;
  final String schemeType;
  final String schemeCategory;
  final int schemeCode;
  final String schemeName;

  SchemeDetail({
    required this.fundHouse,
    required this.schemeType,
    required this.schemeCategory,
    required this.schemeCode,
    required this.schemeName,
  });

  factory SchemeDetail.fromJson(Map<String, dynamic> json) {
    return SchemeDetail(
      fundHouse: json['fund_house'] ?? '',
      schemeType: json['scheme_type'] ?? '',
      schemeCategory: json['scheme_category'] ?? '',
      schemeCode: json['scheme_code'] as int,
      schemeName: json['scheme_name'] ?? '',
    );
  }
}

class NavData {
  final String date;
  final String nav;

  NavData({
    required this.date,
    required this.nav,
  });

  factory NavData.fromJson(Map<String, dynamic> json) {
    return NavData(
      date: json['date'] ?? '',
      nav: json['nav'] ?? '',
    );
  }
}

class SchemeDetailResponse {
  final SchemeDetail meta;
  final List<NavData> data;

  SchemeDetailResponse({
    required this.meta,
    required this.data,
  });

  factory SchemeDetailResponse.fromJson(Map<String, dynamic> json) {
    return SchemeDetailResponse(
      meta: SchemeDetail.fromJson(json['meta']),
      data: (json['data'] as List).map((e) => NavData.fromJson(e)).toList(),
    );
  }
}
