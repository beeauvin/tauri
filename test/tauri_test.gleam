// Copyright © 2025 Cassidy Spring (Bee).
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Just test that the module compiles successfully
pub fn compilation_test() {
  // If this test runs, it means everything compiled successfully
  should.equal(1, 1)
}
