// This is a generated file - do not edit.
//
// Generated from cast_channel.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage$json = {
  '1': 'CastMessage',
  '2': [
    {
      '1': 'protocol_version',
      '3': 1,
      '4': 2,
      '5': 14,
      '6': '.extensions.api.cast_channel.CastMessage.ProtocolVersion',
      '10': 'protocolVersion'
    },
    {'1': 'source_id', '3': 2, '4': 2, '5': 9, '10': 'sourceId'},
    {'1': 'destination_id', '3': 3, '4': 2, '5': 9, '10': 'destinationId'},
    {'1': 'namespace', '3': 4, '4': 2, '5': 9, '10': 'namespace'},
    {
      '1': 'payload_type',
      '3': 5,
      '4': 2,
      '5': 14,
      '6': '.extensions.api.cast_channel.CastMessage.PayloadType',
      '10': 'payloadType'
    },
    {'1': 'payload_utf8', '3': 6, '4': 1, '5': 9, '10': 'payloadUtf8'},
    {'1': 'payload_binary', '3': 7, '4': 1, '5': 12, '10': 'payloadBinary'},
  ],
  '4': [CastMessage_ProtocolVersion$json, CastMessage_PayloadType$json],
};

@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage_ProtocolVersion$json = {
  '1': 'ProtocolVersion',
  '2': [
    {'1': 'CASTV2_1_0', '2': 0},
  ],
};

@$core.Deprecated('Use castMessageDescriptor instead')
const CastMessage_PayloadType$json = {
  '1': 'PayloadType',
  '2': [
    {'1': 'STRING', '2': 0},
    {'1': 'BINARY', '2': 1},
  ],
};

/// Descriptor for `CastMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castMessageDescriptor = $convert.base64Decode(
    'CgtDYXN0TWVzc2FnZRJjChBwcm90b2NvbF92ZXJzaW9uGAEgAigOMjguZXh0ZW5zaW9ucy5hcG'
    'kuY2FzdF9jaGFubmVsLkNhc3RNZXNzYWdlLlByb3RvY29sVmVyc2lvblIPcHJvdG9jb2xWZXJz'
    'aW9uEhsKCXNvdXJjZV9pZBgCIAIoCVIIc291cmNlSWQSJQoOZGVzdGluYXRpb25faWQYAyACKA'
    'lSDWRlc3RpbmF0aW9uSWQSHAoJbmFtZXNwYWNlGAQgAigJUgluYW1lc3BhY2USVwoMcGF5bG9h'
    'ZF90eXBlGAUgAigOMjQuZXh0ZW5zaW9ucy5hcGkuY2FzdF9jaGFubmVsLkNhc3RNZXNzYWdlLl'
    'BheWxvYWRUeXBlUgtwYXlsb2FkVHlwZRIhCgxwYXlsb2FkX3V0ZjgYBiABKAlSC3BheWxvYWRV'
    'dGY4EiUKDnBheWxvYWRfYmluYXJ5GAcgASgMUg1wYXlsb2FkQmluYXJ5IiEKD1Byb3RvY29sVm'
    'Vyc2lvbhIOCgpDQVNUVjJfMV8wEAAiJQoLUGF5bG9hZFR5cGUSCgoGU1RSSU5HEAASCgoGQklO'
    'QVJZEAE=');

@$core.Deprecated('Use authChallengeDescriptor instead')
const AuthChallenge$json = {
  '1': 'AuthChallenge',
};

/// Descriptor for `AuthChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authChallengeDescriptor =
    $convert.base64Decode('Cg1BdXRoQ2hhbGxlbmdl');

@$core.Deprecated('Use authResponseDescriptor instead')
const AuthResponse$json = {
  '1': 'AuthResponse',
  '2': [
    {'1': 'signature', '3': 1, '4': 2, '5': 12, '10': 'signature'},
    {
      '1': 'client_auth_certificate',
      '3': 2,
      '4': 2,
      '5': 12,
      '10': 'clientAuthCertificate'
    },
    {'1': 'client_ca', '3': 3, '4': 3, '5': 12, '10': 'clientCa'},
  ],
};

/// Descriptor for `AuthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResponseDescriptor = $convert.base64Decode(
    'CgxBdXRoUmVzcG9uc2USHAoJc2lnbmF0dXJlGAEgAigMUglzaWduYXR1cmUSNgoXY2xpZW50X2'
    'F1dGhfY2VydGlmaWNhdGUYAiACKAxSFWNsaWVudEF1dGhDZXJ0aWZpY2F0ZRIbCgljbGllbnRf'
    'Y2EYAyADKAxSCGNsaWVudENh');

@$core.Deprecated('Use authErrorDescriptor instead')
const AuthError$json = {
  '1': 'AuthError',
  '2': [
    {
      '1': 'error_type',
      '3': 1,
      '4': 2,
      '5': 14,
      '6': '.extensions.api.cast_channel.AuthError.ErrorType',
      '10': 'errorType'
    },
  ],
  '4': [AuthError_ErrorType$json],
};

@$core.Deprecated('Use authErrorDescriptor instead')
const AuthError_ErrorType$json = {
  '1': 'ErrorType',
  '2': [
    {'1': 'INTERNAL_ERROR', '2': 0},
    {'1': 'NO_TLS', '2': 1},
  ],
};

/// Descriptor for `AuthError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authErrorDescriptor = $convert.base64Decode(
    'CglBdXRoRXJyb3ISTwoKZXJyb3JfdHlwZRgBIAIoDjIwLmV4dGVuc2lvbnMuYXBpLmNhc3RfY2'
    'hhbm5lbC5BdXRoRXJyb3IuRXJyb3JUeXBlUgllcnJvclR5cGUiKwoJRXJyb3JUeXBlEhIKDklO'
    'VEVSTkFMX0VSUk9SEAASCgoGTk9fVExTEAE=');

@$core.Deprecated('Use deviceAuthMessageDescriptor instead')
const DeviceAuthMessage$json = {
  '1': 'DeviceAuthMessage',
  '2': [
    {
      '1': 'challenge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.extensions.api.cast_channel.AuthChallenge',
      '10': 'challenge'
    },
    {
      '1': 'response',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.extensions.api.cast_channel.AuthResponse',
      '10': 'response'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.extensions.api.cast_channel.AuthError',
      '10': 'error'
    },
  ],
};

/// Descriptor for `DeviceAuthMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceAuthMessageDescriptor = $convert.base64Decode(
    'ChFEZXZpY2VBdXRoTWVzc2FnZRJICgljaGFsbGVuZ2UYASABKAsyKi5leHRlbnNpb25zLmFwaS'
    '5jYXN0X2NoYW5uZWwuQXV0aENoYWxsZW5nZVIJY2hhbGxlbmdlEkUKCHJlc3BvbnNlGAIgASgL'
    'MikuZXh0ZW5zaW9ucy5hcGkuY2FzdF9jaGFubmVsLkF1dGhSZXNwb25zZVIIcmVzcG9uc2USPA'
    'oFZXJyb3IYAyABKAsyJi5leHRlbnNpb25zLmFwaS5jYXN0X2NoYW5uZWwuQXV0aEVycm9yUgVl'
    'cnJvcg==');
