
class Application{
  late String? id;
  final String applicantId;
  final String name;
  final String? fbProfile;
  final String? membershipNo;
  final String? nationName;
  final String? profilePic;
  final int status;

  Application({this.id, required this.applicantId, required this.name, required this.fbProfile, 
  this.membershipNo, this.nationName, this.profilePic, required this.status});

factory Application.fromJson(String id, Map<String, dynamic> doc) {
    return Application(
      id: id, 
      applicantId: doc['user_id'] as String,
      name: doc['name'] as String, 
      fbProfile: doc['fb_profile'] as String,
      membershipNo: doc['nation_membership_no'] != null ? doc['nation_membership_no'] as String : null,
      nationName: doc['nation_name'] != null ? doc['nation_name'] as String : null,
      profilePic: doc['profile_pic'] != null ? doc['profile_pic'] as String : null,
      status: doc['status'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id' :applicantId,
      'name' : name,
      'fb_profile' : fbProfile,
      'nation_membership_no' : membershipNo,
      'nation_name' : nationName,
      'profile_pic' : profilePic,
      'status' : status
    };
  }
}