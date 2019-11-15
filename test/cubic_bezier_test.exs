defmodule CubicBezierTest do
  use ExUnit.Case

  import CubicBezier

  doctest CubicBezier

  describe "cubic bezier" do
    test "solve" do
      assert Float.ceil(solve(0.25, :ease_in, [duration: 400]), 5) == 0.09347
      assert Float.ceil(solve(0.50, :ease_in, [duration: 400]), 5) == 0.31536
      assert Float.ceil(solve(0.75, :ease_in, [duration: 400]), 5) == 0.62187

      assert Float.ceil(solve(0.25, :ease_in_quad, [duration: 400]), 5) == 0.07429
      assert Float.ceil(solve(0.50, :ease_in_quad, [duration: 400]), 5) == 0.25599
      assert Float.ceil(solve(0.75, :ease_in_quad, [duration: 400]), 5) == 0.59797

      assert Float.ceil(solve(0.25, :ease_out_quad, [duration: 400]), 5) == 0.45338
      assert Float.ceil(solve(0.50, :ease_out_quad, [duration: 400]), 5) == 0.77133
      assert Float.ceil(solve(0.75, :ease_out_quad, [duration: 400]), 5) == 0.93606
    end
  end
end
