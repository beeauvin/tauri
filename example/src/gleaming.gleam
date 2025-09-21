import greet
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(name: String, greeting_message: String, loading: Bool)
}

type Msg {
  NameChanged(String)
  GreetClicked
  GreetResult(Result(String, String))
}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(Model(name: "", greeting_message: "", loading: False), effect.none())
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    NameChanged(new_name) -> #(Model(..model, name: new_name), effect.none())
    GreetClicked ->
      case model.name {
        "" -> #(
          Model(..model, greeting_message: "", loading: False),
          effect.none(),
        )
        name -> #(
          Model(..model, loading: True, greeting_message: ""),
          greet.greet_effect(name, GreetResult),
        )
      }
    GreetResult(result) ->
      case result {
        Ok(greeting) -> #(
          Model(..model, greeting_message: greeting, loading: False),
          effect.none(),
        )
        Error(error) -> #(
          Model(..model, greeting_message: "Error: " <> error, loading: False),
          effect.none(),
        )
      }
  }
}

fn view(model: Model) -> Element(Msg) {
  html.main([attribute.class("container")], [
    html.h1([], [html.text("Welcome to Tauri")]),
    html.div([attribute.class("row")], [
      html.a([attribute.href("https://tauri.app"), attribute.target("_blank")], [
        html.img([
          attribute.src("/static/tauri.svg"),
          attribute.class("logo tauri"),
          attribute.alt("Tauri logo"),
        ]),
      ]),
      html.a([attribute.href("https://gleam.run"), attribute.target("_blank")], [
        html.img([
          attribute.src("/static/lucy.svg"),
          attribute.class("logo gleam"),
          attribute.alt("Gleam logo"),
        ]),
      ]),
      html.a(
        [
          attribute.href(
            "https://developer.mozilla.org/en-US/docs/Web/JavaScript",
          ),
          attribute.target("_blank"),
        ],
        [
          html.img([
            attribute.src("/static/javascript.svg"),
            attribute.class("logo vanilla"),
            attribute.alt("JavaScript logo"),
          ]),
        ],
      ),
    ]),
    html.p([], [
      html.text("Click on the Tauri logo to learn more about the framework"),
    ]),
    html.div([attribute.class("row")], [
      html.input([
        attribute.placeholder("Enter a name..."),
        attribute.value(model.name),
        event.on_input(NameChanged),
        attribute.disabled(model.loading),
      ]),
      html.button(
        [event.on_click(GreetClicked), attribute.disabled(model.loading)],
        [
          html.text(case model.loading {
            True -> "Loading..."
            False -> "Greet"
          }),
        ],
      ),
    ]),
    html.p([attribute.id("greet-msg")], [html.text(model.greeting_message)]),
  ])
}
