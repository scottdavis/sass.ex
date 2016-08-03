defmodule SassTest do
  use ExUnit.Case

  test "Sass.compile/1 compiles a SCSS string to CSS" do
	scss_string = "/* sample_scss.scss */#navbar {width: 80%;height: 23px;ul { list-style-type: none; }; li {float: left; a { font-weight: bold; } } }"
	{ :ok, expected_css } = File.read("test/sample_scss.css")
	{ :ok, result_css }   = Sass.compile(scss_string)

	assert expected_css == result_css
  end
end
