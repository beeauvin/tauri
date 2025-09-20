// Copyright © 2025 Cassidy Spring (Bee).
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleam/json.{type Json}
import gleam/list

// Argument type for command parameters
pub opaque type Argument {
  Argument(json: Json)
}

// Create arguments from common types
pub fn string(value: String) -> Argument {
  Argument(json.string(value))
}

pub fn int(value: Int) -> Argument {
  Argument(json.int(value))
}

pub fn float(value: Float) -> Argument {
  Argument(json.float(value))
}

pub fn bool(value: Bool) -> Argument {
  Argument(json.bool(value))
}

pub fn null() -> Argument {
  Argument(json.null())
}

pub fn list(values: List(Argument)) -> Argument {
  let json_values =
    values
    |> list.map(fn(arg) {
      let Argument(json: json_val) = arg
      json_val
    })
  Argument(json.array(json_values, fn(x) { x }))
}

// Internal function to extract JSON - only used by command module
pub fn to_json(arg: Argument) -> Json {
  let Argument(json: json_val) = arg
  json_val
}
