defmodule CubicBezier do
  @moduledoc """
  Elixir port of the the JavaScript port of Webkit implementation of 
  CSS cubic-bezier(p1x.p1y,p2x,p2y) by http://mck.me

  http://svn.webkit.org/repository/webkit/trunk/Source/WebCore/platform/graphics/UnitBezier.h
  https://gist.github.com/mckamey/3783009
  """


  # Duration value to use when one is not specified 
  # 400ms is a common value
  @default_duration 400
  

  @doc """
  The epsilon value we pass to UnitBezier::solve given that the animation 
  is going to run over |dur| seconds.

  The longer the animation, the more precision we need in the timing function 
  result to avoid ugly discontinuities.

	http://svn.webkit.org/repository/webkit/trunk/Source/WebCore/page/animation/AnimationBase.cpp
  """
  def solve_epsilon(duration) do
    1.0 / (200.0 * duration)
  end


  @doc """
  Defines a cubic-bezier curve given the middle two control points.
	NOTE: first and last control points are implicitly (0,0) and (1,1).
  
    @param p1x {number} X component of control point 1
	  @param p1y {number} Y component of control point 1
	  @param p2x {number} X component of control point 2
	  @param p2y {number} Y component of control point 2
  """
  def calculate_coefficients({p1x, p1y, p2x, p2y}) do
    # Calculate the polynomial coefficients, implicit first and last control points are (0,0) and (1,1).

    # X component of Bezier coefficient C
		cx = 3.0 * p1x

    # X component of Bezier coefficient B
		bx = 3.0 * (p2x - p1x) - cx

    # X component of Bezier coefficient A
		ax = 1.0 - cx - bx

    # Y component of Bezier coefficient C
		cy = 3.0 * p1y

    # Y component of Bezier coefficient B
		by = 3.0 * (p2y - p1y) - cy

		# Y component of Bezier coefficient A
    ay = 1.0 - cy - by
    
    {ax, bx, cx, ay, by, cy}
  end


  @doc """
    @param t {number} parametric timing value
    @return {number}
  """
  def sample_curve_x(t, {ax, bx, cx, _ay, _by, _cy}) do
    # `ax t^3 + bx t^2 + cx t' expanded using Horner's rule.
    ((ax * t + bx) * t + cx) * t
  end

    
  @doc """
    @param t {number} parametric timing value
    @return {number}
  """
  def sample_curve_y(t, {_ax, _bx, _cx, ay, by, cy}) do
    ((ay * t + by) * t + cy) * t
  end


  @doc """
    @param t {number} parametric timing value
    @return {number}
  """
  def sample_curve_derivative_x(t, {ax, bx, cx, _ay, _by, _cy}) do
    (3.0 * ax * t + 2.0 * bx) * t + cx
  end


  @doc """
  Given an x value, find a parametric value it came from.

	  @param x {number} value of x along the bezier curve, 0.0 <= x <= 1.0
		@param epsilon {number} accuracy limit of t for the given x
		@return {number} the t value corresponding to x
  """
  def solve_curve_x(x, epsilon, coefficients) do
    t2 = x

    t2 =
      Enum.reduce_while(Enum.to_list(1..8), t2, fn (_i, t2) ->
        x2 = sample_curve_x(t2, coefficients) - x

        if abs(x2) < epsilon do
					{:halt, t2}
        else
          d2 = sample_curve_derivative_x(t2, coefficients) 
          if abs(d2) < :math.exp(-6),
            do: {:halt, nil},
            else: {:cont, t2 - x2 / d2}
        end
      end)

    if t2 != nil do
      t2
    else
      IO.puts "COULD NOT SOLVE CURVE X"
      x

      # Fall back to the bisection method for reliability.
      # t0 = 0.0;
      # t1 = 1.0;
      # t2 = x;

      # if (t2 < t0) {
      #   return t0;
      # }
      # if (t2 > t1) {
      #   return t1;
      # }

      # while (t0 < t1) {
      #   x2 = sampleCurveX(t2);
      #   if (Math.abs(x2 - x) < epsilon) {
      #     return t2;
      #   }
      #   if (x > x2) {
      #     t0 = t2;
      #   } else {
      #     t1 = t2;
      #   }
      #   t2 = (t1 - t0) * 0.5 + t0;
      # }

      # # Failure.
      # return t2;
    end
  end

    
  @doc """
    @param x {number} the value of x along the bezier curve, 0.0 <= x <= 1.0
		@param epsilon {number} the accuracy of t for the given x
    @return {number} the y value along the bezier curve
    
    Renamed from `solve`
  """
  def solve_with_epsilon(x, epsilon, coefficients) do
    sample_curve_y(solve_curve_x(x, epsilon, coefficients), coefficients)
  end


  @doc """
  Given `x` (a float between `0.0` and `1.0`), compute the `y`; which 
  essentially acts a "speed". Optioanally, a duration can be provided
  which can provide greater accuracy. The default is 400 (ms), which
  is a common animation / transition duration.
  """
  def solve(x, easing, duration \\ @default_duration)
  when is_atom(easing) do
    control_points = control_points(easing)
    solve(x, control_points, duration)
  end

  def solve(x, control_points, duration)
  when is_tuple(control_points) do
    coefficients = calculate_coefficients(control_points)
    solve_with_epsilon(x, solve_epsilon(duration), coefficients)
  end
  


  @doc """
  Return a control points tuple based on 
  the easing equation name.

  See: https://gist.github.com/terkel/4377409
  """
  def control_points(atom) when is_atom(atom) do
    easing = %{
      linear:             {0.250,  0.250,  0.750,  0.750},
      ease:               {0.250,  0.100,  0.250,  1.000},
      ease_in:            {0.420,  0.000,  1.000,  1.000},
      ease_out:           {0.000,  0.000,  0.580,  1.000},
      ease_in_out:        {0.420,  0.000,  0.580,  1.000},

      ease_in_quad:       {0.550,  0.085,  0.680,  0.530},
      ease_in_cubic:      {0.550,  0.055,  0.675,  0.190},
      ease_in_quart:      {0.895,  0.030,  0.685,  0.220},
      
      ease_out_quad:      {0.250,  0.460,  0.450,  0.940},
      ease_out_cubic:     {0.215,  0.610,  0.355,  1.000},
      ease_out_quart:     {0.165,  0.840,  0.440,  1.000},
      ease_out_back:      {0.175,  0.885,  0.320,  1.275},

      ease_in_out_quad:   {0.455,  0.030,  0.515,  0.955},
      ease_in_out_cubic:  {0.645,  0.045,  0.355,  1.000},
      ease_in_out_quart:  {0.770,  0.000,  0.175,  1.000},
      ease_in_out_back:   {0.680, -0.550,  0.265,  1.550}
    }
    
    Map.get(easing, atom, easing.linear)
  end
end
