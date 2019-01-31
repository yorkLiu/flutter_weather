

class GEOPlaceMark{

  GEOPlaceMark({
    this.country: "中国",
    this.province,
    this.city,
    this.district,
    this.address,
    this.postCode,
    this.latitude,
    this.longitude
  });

  final String country;
  final String province;
  final String city;
  final String district;
  final String address;
  final String postCode;

  // 经度
  final double latitude;
  // 纬度
  final double longitude;


  get getMainAddress{
    String c = city;
    if(district != null && district.isNotEmpty){
      c =  "$city | $district";
    }

    return c.length > 9?c.substring(0,9): c;
  }

  get getSubAddress{
    if(address != null && address.isNotEmpty){
      if(address.length > 7){
        return "${address.substring(0,7)}...";
      }
    }
    return address;
  }

  @override
  String toString() {
    return 'GEOPlaceMark{country: $country, province: $province, city: $city, district: $district, address: $address, postCode: $postCode, latitude: $latitude, longitude: $longitude}';
  }


}