defmodule CubicBezierTest do
  use ExUnit.Case

  import CubicBezier

  doctest CubicBezier

  describe "cubic bezier" do
    test "solve" do
      assert Float.ceil(solve(0.25, :ease_in, 400), 5) == 0.09347
      assert Float.ceil(solve(0.50, :ease_in, 400), 5) == 0.31536
      assert Float.ceil(solve(0.75, :ease_in, 400), 5) == 0.62187

      assert Float.ceil(solve(0.25, :ease_in_quad, 400), 5) == 0.07429
      assert Float.ceil(solve(0.50, :ease_in_quad, 400), 5) == 0.25599
      assert Float.ceil(solve(0.75, :ease_in_quad, 400), 5) == 0.59797

      assert Float.ceil(solve(0.25, :ease_out_quad, 400), 5) == 0.45338
      assert Float.ceil(solve(0.50, :ease_out_quad, 400), 5) == 0.77133
      assert Float.ceil(solve(0.75, :ease_out_quad, 400), 5) == 0.93606
    end

    test "control_points/1" do
      assert control_points(:linear) == {0.250,  0.250,  0.750,  0.750}
      assert control_points(:ease_out) == {0.000,  0.000,  0.580,  1.000}
      assert control_points(:foobar) == {0.250,  0.250,  0.750,  0.750}
    end
  end
end
