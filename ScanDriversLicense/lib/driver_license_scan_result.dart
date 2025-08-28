import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

enum EnumResultStatus {
  finished,
  cancelled,
  error,
}

class DriverLicenseScanResult {
  EnumResultStatus resultStatus;
  String? errorString = "";
  DriverLicenseData? data;
  DriverLicenseScanResult({
    required this.resultStatus,
    this.errorString,
    this.data,
  });
}

class DriverLicenseData {
  String documentType;
  String? name;
  String? state; //For AAMVA_DL_ID
  String? stateOrProvince; //For AAMVA_DL_ID_WITH_MAG_STRIPE
  String? initials; //For SOUTH_AFRICA_DL
  String? city; //For AAMVA_DL_ID, AAMVA_DL_ID_WITH_MAG_STRIPE
  String? address; //For AAMVA_DL_ID, AAMVA_DL_ID_WITH_MAG_STRIPE
  String? idNumber; //For SOUTH_AFRICA_DL
  String? idNumberType; //For SOUTH_AFRICA_DL
  String? licenseNumber;
  String? licenseIssueNumber; //For SOUTH_AFRICA_DL
  String? issuedDate;
  String? expirationDate;
  String? birthDate;
  String? sex;
  String? height; //For AAMVA_DL_ID, SOUTH_AFRICA_DL
  String? issuedCountry; //For AAMVA_DL_ID, SOUTH_AFRICA_DL
  String? vehicleClass;  //For AAMVA_DL_ID
  String? driverRestrictionCodes; //For SOUTH_AFRICA_DL
  DriverLicenseData({
    required this.documentType
  });

  Map<String, String> toMap() {
    return {
      'documentType': documentType,
      if (name != null) 'name': name!,
      if (state != null) 'state': state!,
      if (stateOrProvince != null) 'stateOrProvince': stateOrProvince!,
      if (initials != null) 'initials': initials!,
      if (city != null) 'city': city!,
      if (address != null) 'address': address!,
      if (idNumber != null) 'idNumber': idNumber!,
      if (idNumberType != null) 'idNumberType': idNumberType!,
      if (licenseNumber != null) 'licenseNumber': licenseNumber!,
      if (licenseIssueNumber != null) 'licenseIssueNumber': licenseIssueNumber!,
      if (issuedDate != null) 'issuedDate': issuedDate!,
      if (expirationDate != null) 'expirationDate': expirationDate!,
      if (birthDate != null) 'birthDate': birthDate!,
      if (sex != null) 'sex': sex!,
      if (height != null) 'height': height!,
      if (issuedCountry != null) 'issuedCountry': issuedCountry!,
      if (vehicleClass != null) 'vehicleClass': vehicleClass!,
      if (driverRestrictionCodes != null) 'driverRestrictionCodes': driverRestrictionCodes!,
    };
  }

  static DriverLicenseData? fromParsedResultItem(ParsedResultItem item) {
    var codeType = item.codeType;
    var parsedFields = item.parsedFields;
    if(parsedFields.isEmpty) {
      return null;
    }
    var data = DriverLicenseData(documentType: codeType);
    if(codeType == 'AAMVA_DL_ID') {
      data.name = parsedFields['fullName']?.value ??
          "${parsedFields['givenName']?.value ?? parsedFields['givenName']?.value ??""} ${parsedFields['lastName']?.value ?? ''}";
      data.city = parsedFields['city']?.value;
      data.state = parsedFields['jurisdictionCode']?.value;
      data.address = "${parsedFields['street_1']?.value??""} ${parsedFields['street_2']?.value??""}";
      data.licenseNumber = parsedFields['licenseNumber']?.value;
      data.issuedDate = parsedFields['issuedDate']?.value;
      data.expirationDate = parsedFields['expirationDate']?.value;
      data.birthDate = parsedFields['birthDate']?.value;
      data.height = parsedFields['height']?.value;
      data.sex = parsedFields['sex']?.value;
      data.issuedCountry = parsedFields['issuedCountry']?.value;
      data.vehicleClass = parsedFields['vehicleClass']?.value;
    } else if(codeType == 'AAMVA_DL_ID_WITH_MAG_STRIPE') {
      data.name = parsedFields['name']?.value;
      data.city = parsedFields['city']?.value;
      data.stateOrProvince = parsedFields['stateOrProvince']?.value;
      data.address = parsedFields['address']?.value;
      data.licenseNumber = parsedFields['DLorID_Number']?.value;
      data.expirationDate = parsedFields['expirationDate']?.value;
      data.birthDate = parsedFields['birthDate']?.value;
      data.height = parsedFields['height']?.value;
      data.sex = parsedFields['sex']?.value;
    } else if(codeType == 'SOUTH_AFRICA_DL') {
      data.name = parsedFields['surname']?.value;
      data.idNumber = parsedFields['idNumber']?.value;
      data.idNumberType = parsedFields['idNumberType']?.value;
      data.licenseNumber = parsedFields['idNumber']?.value ?? parsedFields['licenseNumber']?.value;
      data.licenseIssueNumber = parsedFields['licenseIssueNumber']?.value;
      data.initials = parsedFields['initials']?.value;
      data.issuedDate = parsedFields['licenseValidityFrom']?.value;
      data.expirationDate = parsedFields['licenseValidityTo']?.value;
      data.birthDate = parsedFields['birthDate']?.value;
      data.sex = parsedFields['gender']?.value;
      data.issuedCountry = parsedFields['idIssuedCountry']?.value;
      data.driverRestrictionCodes = parsedFields['driverRestrictionCodes']?.value;
    }
    return data;
  }
}

