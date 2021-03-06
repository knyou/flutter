// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// An object sent from the Flutter Driver to a Flutter application to instruct
/// the application to perform a task.
abstract class Command {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const Command({ this.timeout });

  /// Deserializes this command from the value generated by [serialize].
  Command.deserialize(Map<String, String> json)
    : timeout = _parseTimeout(json);

  static Duration _parseTimeout(Map<String, String> json) {
    final String timeout = json['timeout'];
    if (timeout == null)
      return null;
    return Duration(milliseconds: int.parse(timeout));
  }

  /// The maximum amount of time to wait for the command to complete.
  ///
  /// Defaults to no timeout, because it is common for operations to take oddly
  /// long in test environments (e.g. because the test host is overloaded), and
  /// having timeouts essentially means having race conditions.
  final Duration timeout;

  /// Identifies the type of the command object and of the handler.
  String get kind;

  /// Serializes this command to parameter name/value pairs.
  @mustCallSuper
  Map<String, String> serialize() {
    final Map<String, String> result = <String, String>{
      'command': kind,
    };
    if (timeout != null)
      result['timeout'] = '${timeout.inMilliseconds}';
    return result;
  }
}

/// An object sent from a Flutter application back to the Flutter Driver in
/// response to a command.
abstract class Result {
  /// A const constructor to allow subclasses to be const.
  const Result();

  /// Serializes this message to a JSON map.
  Map<String, dynamic> toJson();
}
