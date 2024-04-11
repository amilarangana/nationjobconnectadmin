
class Application{
  late String? id;
  // final String deviceId;
  final String applicantId;
  final String name;
  final String fbProfile;
  final int status;

  Application({this.id, required this.applicantId, required this.name, required this.fbProfile, required this.status});

factory Application.fromJson(String id, Map<String, dynamic> doc) {
    return Application(
      id: id, 
      // deviceId: doc['device_id'] as String, 
      applicantId: doc['user_id'] as String,
      name: doc['name'] as String, 
      fbProfile: doc['fb_profile'] as String,
      status: doc['status'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id' :applicantId,
      'name' : name,
      // 'device_id' : deviceId,
      'fb_profile' : fbProfile
    };
  }
}