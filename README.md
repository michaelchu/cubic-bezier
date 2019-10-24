# CubicBezier

[![Hex.pm Version](https://img.shields.io/hexpm/v/cubic_bezier.svg)](https://hex.pm/packages/cubic_bezier)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://hexdocs.pm/cubic_bezier/)

Elixir port of the CSS cubic-bezier(p1x, p1y, p2x, p2y) timing function.

## Installation

The package can be installed by adding `cubic_bezier` 
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cubic_bezier, "~> 0.0.2"}
  ]
end
```

## Why?

Let's say you want to "tween" (animate / transition) an object's position.
You might take the travel distance, and divide by the steps ("frames")
of your tween. On every frame, you'd increment the object's position.
This would be the equivelant of a linear Cubic Bezier; and it tends 
to look / feel very unnatural. To make the movement feel more natural,
you'd use an "easing equation". To further make the animation feel more 
natural, you'd want to compute the object's position about 60 times 
per second (60 fps). This will smooth out the position changes to make it 
feel more fluid. The combination is natural and fluid tweens!
