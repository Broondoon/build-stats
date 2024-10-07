class Item {
  int id;
  int checklistId;
  String? unit;
  String? desc;
  String? result;
  String? comment;
  int? creatorId;
  bool? verified;

  Item({required this.id,
    required this.checklistId,
    this.unit,
    this.desc,
    this.result,
    this.comment,
    this.creatorId,
    this.verified
    })
}