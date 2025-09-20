// Copyright © 2025 Cassidy Spring (Bee).
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode.{type Decoder}
import gleam/javascript/promise.{type Promise}
import gleam/json.{type Json}
import gleam/string
import tauri/command/argument.{type Argument}

// Builder pattern state - stores Json key/value pairs directly
pub opaque type CommandBuilder {
  CommandBuilder(command: String, args: List(#(String, Json)))
}

@external(javascript, "./command.ffi.mjs", "invoke")
fn invoke_js(command: String, args: Json) -> Promise(Result(Dynamic, String))

// Start building a command
pub fn invoke(command: String) -> CommandBuilder {
  CommandBuilder(command: command, args: [])
}

// Add an argument using the with() function
pub fn with(
  builder: CommandBuilder,
  key: String,
  value: Argument,
) -> CommandBuilder {
  let CommandBuilder(command: cmd, args: current_args) = builder
  let json_value = argument.to_json(value)
  CommandBuilder(command: cmd, args: [#(key, json_value), ..current_args])
}

// Execute the command - use json.object directly
pub fn send(builder: CommandBuilder) -> Promise(Result(Dynamic, String)) {
  let CommandBuilder(command: cmd, args: arg_list) = builder
  let args_json = json.object(arg_list)
  invoke_js(cmd, args_json)
}

// Decode the result using a decoder
pub fn decode(
  promise: Promise(Result(Dynamic, String)),
  decoder: Decoder(t),
) -> Promise(Result(t, String)) {
  promise
  |> promise.map(fn(result) {
    case result {
      Ok(dynamic_value) -> {
        case decode.run(dynamic_value, decoder) {
          Ok(decoded_value) -> Ok(decoded_value)
          Error(decode_errors) ->
            Error("Decode error: " <> string.inspect(decode_errors))
        }
      }
      Error(error) -> Error(error)
    }
  })
}
