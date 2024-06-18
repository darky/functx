import functx
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn call_test() {
  let resp =
    10
    |> functx.make_ctx
    |> nums_summary

  resp.0
  |> should.equal("Nums: 1,2,3,4,5,6,7,8,9,10 Sum: 55")

  { resp.1 }.0
  |> should.equal(10)

  { resp.1 }.1
  |> dict.size
  |> should.equal(3)
}

fn nums(ctx) {
  io.debug("hit")

  let #(n, _) = ctx

  #([1, 2, 3, 4, 5, 6, 7, 8, 9, n], ctx)
}

fn nums_as_string(ctx) {
  use ns, ctx <- functx.call(ctx, nums)

  let resp =
    ns
    |> list.map(fn(n) { n |> int.to_string })
    |> string.join(",")

  #(resp, ctx)
}

fn nums_to_sum(ctx) {
  use ns, ctx <- functx.call(ctx, nums)

  let resp = {
    use acc, n <- list.fold(ns, 0)
    acc + n
  }

  #(resp, ctx)
}

fn nums_summary(ctx) {
  use ns_str, ctx <- functx.call(ctx, nums_as_string)
  use ns_sum, ctx <- functx.call(ctx, nums_to_sum)

  let resp = "Nums: " <> ns_str <> " Sum: " <> ns_sum |> int.to_string

  #(resp, ctx)
}
