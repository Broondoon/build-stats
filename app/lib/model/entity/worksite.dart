import 'package:shared/worksite.dart';

class Worksite extends BaseWorksite {
  Worksite({
    required super.id,
    super.ownerId,
    super.companyId,
    super.checklistIds,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  Worksite.fromBaseWorksite({required super.worksite})
      : super.fromBaseWorksite();
}

class WorksiteFactory extends BaseWorksiteFactory<Worksite> {
  @override
  Worksite fromJson(Map<String, dynamic> json) {
    return Worksite.fromBaseWorksite(worksite: super.fromJson(json));
  }
}
