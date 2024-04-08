class ShiftType{
  final String id;
  final String type;

  ShiftType({required this.id, required this.type});

  @override
  bool operator ==(Object other) => other is ShiftType && other.type == type;

  @override
  int get hashCode => type.hashCode;

  factory ShiftType.fromJson(String id, Map<String, dynamic> doc){
    return ShiftType(id: id, type: doc['name']);
  }

  factory ShiftType.fromShortJson(Map<String, dynamic> doc){
    return ShiftType(id: doc['id'], type: doc['name']);
  }

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'name' : type
    };
  }
}