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

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use dateRangeDescriptor instead')
const DateRange$json = {
  '1': 'DateRange',
  '2': [
    {
      '1': 'period',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.adair_flutter_lib.DateRange.Period',
      '10': 'period'
    },
    {'1': 'start_timestamp', '3': 2, '4': 1, '5': 4, '10': 'startTimestamp'},
    {'1': 'end_timestamp', '3': 3, '4': 1, '5': 4, '10': 'endTimestamp'},
    {'1': 'time_zone', '3': 23, '4': 1, '5': 9, '10': 'timeZone'},
  ],
  '4': [DateRange_Period$json],
};

@$core.Deprecated('Use dateRangeDescriptor instead')
const DateRange_Period$json = {
  '1': 'Period',
  '2': [
    {'1': 'allDates', '2': 0},
    {'1': 'today', '2': 1},
    {'1': 'yesterday', '2': 2},
    {'1': 'thisWeek', '2': 3},
    {'1': 'thisMonth', '2': 4},
    {'1': 'thisYear', '2': 5},
    {'1': 'lastWeek', '2': 6},
    {'1': 'lastMonth', '2': 7},
    {'1': 'lastYear', '2': 8},
    {'1': 'last7Days', '2': 9},
    {'1': 'last14Days', '2': 10},
    {'1': 'last30Days', '2': 11},
    {'1': 'last60Days', '2': 12},
    {'1': 'last12Months', '2': 13},
    {'1': 'custom', '2': 14},
  ],
};

/// Descriptor for `DateRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateRangeDescriptor = $convert.base64Decode(
    'CglEYXRlUmFuZ2USOwoGcGVyaW9kGAEgASgOMiMuYWRhaXJfZmx1dHRlcl9saWIuRGF0ZVJhbm'
    'dlLlBlcmlvZFIGcGVyaW9kEicKD3N0YXJ0X3RpbWVzdGFtcBgCIAEoBFIOc3RhcnRUaW1lc3Rh'
    'bXASIwoNZW5kX3RpbWVzdGFtcBgDIAEoBFIMZW5kVGltZXN0YW1wEhsKCXRpbWVfem9uZRgXIA'
    'EoCVIIdGltZVpvbmUi4wEKBlBlcmlvZBIMCghhbGxEYXRlcxAAEgkKBXRvZGF5EAESDQoJeWVz'
    'dGVyZGF5EAISDAoIdGhpc1dlZWsQAxINCgl0aGlzTW9udGgQBBIMCgh0aGlzWWVhchAFEgwKCG'
    'xhc3RXZWVrEAYSDQoJbGFzdE1vbnRoEAcSDAoIbGFzdFllYXIQCBINCglsYXN0N0RheXMQCRIO'
    'CgpsYXN0MTREYXlzEAoSDgoKbGFzdDMwRGF5cxALEg4KCmxhc3Q2MERheXMQDBIQCgxsYXN0MT'
    'JNb250aHMQDRIKCgZjdXN0b20QDg==');
