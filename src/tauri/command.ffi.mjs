// Copyright © 2025 Cassidy Spring (Bee).
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import { invoke as tauri_invoke } from "@tauri-apps/api/core";
import { Ok, Error } from "../gleam.mjs";

export async function invoke(command, args_json) {
  if (!command) return new Error("command is required");

  try {
    return new Ok(await tauri_invoke(command, args_json));
  } catch (error) {
    return new Error(error.toString());
  }
}
