import gleam/dynamic/decode
import gleam/javascript/promise
import lustre/effect.{type Effect}
import tauri/command
import tauri/command/argument

pub fn greet_effect(
  name: String,
  on_result: fn(Result(String, String)) -> msg,
) -> Effect(msg) {
  effect.from(fn(dispatch) {
    command.invoke("greet")
    |> command.with("name", argument.string(name))
    |> command.send()
    |> command.decode(decode.string)
    |> promise.map(fn(result) {
      case result {
        Ok(value) -> dispatch(on_result(Ok(value)))
        Error(error) -> dispatch(on_result(Error(error)))
      }
    })

    // Probably a better way to handle this but it's fine. Everything is fine.
    Nil
  })
}
