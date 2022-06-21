import 'package:isar/isar.dart';
import 'package:job_timer/app/entities/project_status.dart';

class ProjectStatusConverter extends TypeConverter<ProjectStatus, int> {
  const ProjectStatusConverter();

  @override
  fromIsar(int object) {
    return ProjectStatus.values[object];
  }

  @override
  int toIsar(object) {
    return object.index;
  }
}
