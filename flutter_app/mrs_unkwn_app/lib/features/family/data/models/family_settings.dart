/// Model representing family-level settings.
class FamilySettings {
  FamilySettings({
    this.studyRulesEnabled = false,
    this.screenTimeLimitMinutes = 0,
    this.bedtimeHour = 21,
    this.bedtimeMinute = 0,
    List<String>? restrictedApps,
  }) : restrictedApps = restrictedApps ?? [];

  final bool studyRulesEnabled;
  final int screenTimeLimitMinutes;
  final int bedtimeHour;
  final int bedtimeMinute;
  final List<String> restrictedApps;

  factory FamilySettings.fromJson(Map<String, dynamic> json) => FamilySettings(
        studyRulesEnabled: json['studyRulesEnabled'] as bool? ?? false,
        screenTimeLimitMinutes:
            json['screenTimeLimitMinutes'] as int? ?? 0,
        bedtimeHour: json['bedtimeHour'] as int? ?? 21,
        bedtimeMinute: json['bedtimeMinute'] as int? ?? 0,
        restrictedApps: (json['restrictedApps'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'studyRulesEnabled': studyRulesEnabled,
        'screenTimeLimitMinutes': screenTimeLimitMinutes,
        'bedtimeHour': bedtimeHour,
        'bedtimeMinute': bedtimeMinute,
        'restrictedApps': restrictedApps,
      };
}
