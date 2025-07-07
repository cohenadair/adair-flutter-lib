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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'adair_flutter_lib.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'adair_flutter_lib.pbenum.dart';

class DateRange extends $pb.GeneratedMessage {
  factory DateRange({
    DateRange_Period? period,
    $fixnum.Int64? startTimestamp,
    $fixnum.Int64? endTimestamp,
    $core.String? timeZone,
  }) {
    final result = create();
    if (period != null) result.period = period;
    if (startTimestamp != null) result.startTimestamp = startTimestamp;
    if (endTimestamp != null) result.endTimestamp = endTimestamp;
    if (timeZone != null) result.timeZone = timeZone;
    return result;
  }

  DateRange._();

  factory DateRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DateRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateRange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'adair_flutter_lib'),
      createEmptyInstance: create)
    ..e<DateRange_Period>(
        1, _omitFieldNames ? '' : 'period', $pb.PbFieldType.OE,
        defaultOrMaker: DateRange_Period.allDates,
        valueOf: DateRange_Period.valueOf,
        enumValues: DateRange_Period.values)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'startTimestamp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'endTimestamp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(23, _omitFieldNames ? '' : 'timeZone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRange clone() => DateRange()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRange copyWith(void Function(DateRange) updates) =>
      super.copyWith((message) => updates(message as DateRange)) as DateRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DateRange create() => DateRange._();
  @$core.override
  DateRange createEmptyInstance() => create();
  static $pb.PbList<DateRange> createRepeated() => $pb.PbList<DateRange>();
  @$core.pragma('dart2js:noInline')
  static DateRange getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DateRange>(create);
  static DateRange? _defaultInstance;

  @$pb.TagNumber(1)
  DateRange_Period get period => $_getN(0);
  @$pb.TagNumber(1)
  set period(DateRange_Period value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => $_clearField(1);

  /// Should only be set for Period.custom.
  @$pb.TagNumber(2)
  $fixnum.Int64 get startTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set startTimestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set endTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTimestamp() => $_clearField(3);

  @$pb.TagNumber(23)
  $core.String get timeZone => $_getSZ(3);
  @$pb.TagNumber(23)
  set timeZone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(23)
  $core.bool hasTimeZone() => $_has(3);
  @$pb.TagNumber(23)
  void clearTimeZone() => $_clearField(23);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
