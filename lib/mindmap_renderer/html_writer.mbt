///|
fn write_str(out : StringBuilder, value : String) -> Unit {
  out.write_string(value)
}

///|
fn[T : Show] write_obj(out : StringBuilder, value : T) -> Unit {
  out.write_object(value)
}

///|
fn write_attr(out : StringBuilder, name : String, value : String) -> Unit {
  out.write_string(" ")
  out.write_string(name)
  out.write_string("=\"")
  out.write_string(value)
  out.write_string("\"")
}

///|
fn write_int_attr(out : StringBuilder, name : String, value : Int) -> Unit {
  out.write_string(" ")
  out.write_string(name)
  out.write_string("=\"")
  write_obj(out, value)
  out.write_string("\"")
}

///|
fn write_bool_attr(out : StringBuilder, name : String, value : Bool) -> Unit {
  out.write_string(" ")
  out.write_string(name)
  out.write_string("=\"")
  write_obj(out, value)
  out.write_string("\"")
}

///|
fn finish_builder(out : StringBuilder) -> String {
  out.to_string()
}
