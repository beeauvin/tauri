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
