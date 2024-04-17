class ShiftType{
  final String? id;
  final String type;
  final String? description;
  final String? nationId;

  ShiftType({required this.id, required this.type, this.description, this.nationId,});

  @override
  bool operator ==(Object other) => other is ShiftType && other.type == type;

  @override
  int get hashCode => type.hashCode;

  factory ShiftType.fromJson(String id, Map<String, dynamic> doc){
    return ShiftType(
      id: id, 
      type: doc['name'],
      description: doc['description'],
      nationId: doc['nation_id']);
  }

  factory ShiftType.fromShortJson(Map<String, dynamic> doc){
    return ShiftType(id: doc['id'], type: doc['name']);
  }

  Map<String, dynamic> toShortJson(){
    return{
      'id' : id,
      'name' : type
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'name' : type,
      'description' : description,
      'nation_id' : nationId
    };
  }
}