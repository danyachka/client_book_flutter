import 'package:drift/drift.dart';

enum NotificationStatus {
  enabled,
  disabled;

  static NotificationStatus fromString(String value) {
    return switch (value) {
      "enabled" => enabled,
      "disabled" => disabled,
      _ => enabled
    };
  }
}

class NotificationStatusConverter extends TypeConverter<NotificationStatus, String> {
  const NotificationStatusConverter();

  @override
  NotificationStatus fromSql(String fromDb) {
    return NotificationStatus.fromString(fromDb);
  }

  @override
  String toSql(NotificationStatus value) {
    return value.toString();
  }
}
