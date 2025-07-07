//
//  Generated code. Do not modify.
//  source: adair_flutter_lib.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DateRange_Period extends $pb.ProtobufEnum {
  static const DateRange_Period allDates =
      DateRange_Period._(0, _omitEnumNames ? '' : 'allDates');
  static const DateRange_Period today =
      DateRange_Period._(1, _omitEnumNames ? '' : 'today');
  static const DateRange_Period yesterday =
      DateRange_Period._(2, _omitEnumNames ? '' : 'yesterday');
  static const DateRange_Period thisWeek =
      DateRange_Period._(3, _omitEnumNames ? '' : 'thisWeek');
  static const DateRange_Period thisMonth =
      DateRange_Period._(4, _omitEnumNames ? '' : 'thisMonth');
  static const DateRange_Period thisYear =
      DateRange_Period._(5, _omitEnumNames ? '' : 'thisYear');
  static const DateRange_Period lastWeek =
      DateRange_Period._(6, _omitEnumNames ? '' : 'lastWeek');
  static const DateRange_Period lastMonth =
      DateRange_Period._(7, _omitEnumNames ? '' : 'lastMonth');
  static const DateRange_Period lastYear =
      DateRange_Period._(8, _omitEnumNames ? '' : 'lastYear');
  static const DateRange_Period last7Days =
      DateRange_Period._(9, _omitEnumNames ? '' : 'last7Days');
  static const DateRange_Period last14Days =
      DateRange_Period._(10, _omitEnumNames ? '' : 'last14Days');
  static const DateRange_Period last30Days =
      DateRange_Period._(11, _omitEnumNames ? '' : 'last30Days');
  static const DateRange_Period last60Days =
      DateRange_Period._(12, _omitEnumNames ? '' : 'last60Days');
  static const DateRange_Period last12Months =
      DateRange_Period._(13, _omitEnumNames ? '' : 'last12Months');
  static const DateRange_Period custom =
      DateRange_Period._(14, _omitEnumNames ? '' : 'custom');

  static const $core.List<DateRange_Period> values = <DateRange_Period>[
    allDates,
    today,
    yesterday,
    thisWeek,
    thisMonth,
    thisYear,
    lastWeek,
    lastMonth,
    lastYear,
    last7Days,
    last14Days,
    last30Days,
    last60Days,
    last12Months,
    custom,
  ];

  static final $core.List<DateRange_Period?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 14);
  static DateRange_Period? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DateRange_Period._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
