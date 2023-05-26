/*pkID:
LoginUserID:admin
SearchKey:25000
CompanyId:10032*/

class MaintenanceSearchRequest {
  String pkID;
  String LoginUserID;
  String SearchKey;
  String CompanyID;

  MaintenanceSearchRequest({this.pkID,this.LoginUserID,this.SearchKey,this.CompanyID});

  MaintenanceSearchRequest.fromJson(Map<String, dynamic> json) {
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    pkID = json['pkID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID']  = this.LoginUserID;

    data['SearchKey']= this.SearchKey;
    data['pkID'] = this.pkID;
    return data;
  }
}

