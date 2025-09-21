import gleam/io
import lustre/attribute
import lustre/element/html
import lustre/ssg
import simplifile

pub fn index() {
  html.html([attribute.class("container")], [
    html.head([], [
      html.meta([attribute.charset("utf-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1"),
      ]),
      html.title([], "Gleaming"),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href("/gleaming.min.css"),
      ]),
      html.script(
        [attribute.type_("module"), attribute.src("/gleaming.min.mjs")],
        "",
      ),
    ]),
    html.body([], [html.main([attribute.id("app")], [])]),
  ])
}

pub fn main() {
  let build =
    ssg.new("./dist")
    |> ssg.add_static_route("/", index())
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }

  let copy = simplifile.copy_directory("./static", "./dist/static")
  case copy {
    Ok(_) -> io.println("Copy succeeded!")
    Error(e) -> {
      echo e
      io.println("Copy failed!")
    }
  }
}
