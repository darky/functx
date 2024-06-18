import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}

pub type Ctx(data) =
  #(data, Dict(Dynamic, Dynamic))

pub fn call(
  ctx: Ctx(data),
  fun: fn(Ctx(data)) -> #(fun_resp, Ctx(data)),
  cb: fn(fun_resp, Ctx(data)) -> resp,
) -> resp {
  let #(_, cache) = ctx
  case dict.get(cache, fun |> dynamic.from) {
    Ok(resp) -> cb(resp |> unsafe_coerce, ctx)
    Error(Nil) -> {
      let #(resp, #(ctx_data, cache)) = fun(ctx)
      let cache = dict.insert(cache, fun |> dynamic.from, resp |> dynamic.from)
      cb(resp, #(ctx_data, cache))
    }
  }
}

pub fn make_ctx(data) {
  #(data, dict.new())
}

@external(erlang, "gleam_stdlib", "identity")
@external(javascript, "../gleam_stdlib/gleam_stdlib.mjs", "identity")
fn unsafe_coerce(a: Dynamic) -> a
