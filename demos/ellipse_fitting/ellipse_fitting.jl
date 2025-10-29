### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 3072df64-b4ea-11f0-900f-9d704223bdbd
begin
	import Pkg; Pkg.activate()
	using CairoMakie, CSV, DataFrames, LinearAlgebra, ColorSchemes
end

# ╔═╡ 563c54e8-0245-468e-a0d1-7d43f9a7bb5d
md"!!! note
	for background on least-squares fitting of an ellipse, see 
	> D. Margalit, J. Rabinoff. \"The Method of Least Squares\". _Interactive Linear Algebra_ [link](https://textbooks.math.gatech.edu/ila/least-squares.html)
"

# ╔═╡ 65536468-295b-4bb7-a4d9-efca7c1bd1fa
md"🩸 read in the data tracing the outlines of six different blood cells. the data are stored in the CSV file `cell_outlines.csv`.


> Elliptocytes, also known as ovalocytes or cigar cells, are abnormally shaped red blood cells that appear oval or elongated, from slightly egg-shaped to rod or pencil forms. They have normal central pallor with the hemoglobin appearing concentrated at the ends of the elongated cells when viewed through a light microscope. 
> -- \"Elliptocyte\". Wikipedia. [link](https://en.wikipedia.org/wiki/Elliptocyte)
" 

# ╔═╡ d2228c64-045c-4cf7-bbb6-24e4cd49f54a


# ╔═╡ 99a67856-159c-422b-980b-3da76438fae4
md"🩸 plot the data in the 2D plane. make each cell a different color.

!!! hint
	see the `filter` function for data frames. check out `ColorSchemes.jl` for color schemes.
"

# ╔═╡ 2b5c8387-bbda-4db1-b593-7ef4d399db32


# ╔═╡ 0d755969-4a57-496e-8dab-000b37c47845


# ╔═╡ 10ff22f6-5d67-4237-8926-4ac8d4bfbbbe
md"🩸 write a function that takes in a data frame tracing the outline of a single cell, then builds the linear system $A\mathbf{x}=\mathbf{b}$ for fitting an ellipse to the cell outline. use the implicit formula for the general ellipse ([link](https://en.wikipedia.org/wiki/Ellipse#General_ellipse)):

```math
B x y + C y^2 + D x + E y+ F = 0
```
the function should return $A$ and $\mathbf{b}$.
"

# ╔═╡ d994330e-e52d-445f-b543-937f83f5d5ff


# ╔═╡ 3a0c46bb-b9d1-41af-aa31-972aec9eede7
md"🩸 write a function that takes in the entire data and a particular cell label then (i) filters the data pertaining to that cell then (ii) builds the linear system $A\mathbf{x}=\mathbf{b}$ for the ellipse of best fit then (iii) uses least squares to solve the linear system. the function should return the $B, C, D, E, F$ parameters in the implicit ellipse equation that fit the data best.
"

# ╔═╡ af73310e-5da4-4fd3-b9d4-7b8918c36389


# ╔═╡ f959fb3a-e95a-4def-a83a-fc725438fe8f
md"🩸 fit an ellipse to all cells. draw the ellipses on top of the data. my function for visualization should help."

# ╔═╡ 9f7ee7bc-52d2-4f00-8f70-0613e8773f3a
struct Ellipse
	a::Float64
	b::Float64
	x₀::Float64
	y₀::Float64
	θ::Float64
end

# ╔═╡ 09ba9a57-f47d-43dd-86da-512f06be0345
function convert_to_standard_ellipse(B, C, D, E, F)
	# https://en.wikipedia.org/wiki/Ellipse#Parametric_representation
	Δ = B ^ 2 - 4 * C

	a = -sqrt(2*(E^2 + C*D^2 - B*D*E + Δ*F) * ((1 + C) + sqrt((1 - C)^2 + B^2)))/Δ
	b = -sqrt(2*(E^2 + C*D^2 - B*D*E + Δ*F) * ((1 + C) - sqrt((1 - C)^2 + B^2)))/Δ
	x₀ = (2 * C * D - B * E) / Δ
	y₀ = (2 * 1 * E - B * D) / Δ
	θ = 1/2 * atan(-B, C - 1)

	println("\tcenter: ", (round(x₀, digits=2), round(y₀, digits=2)))
	println("\ta, b = ", (round(a, digits=2), round(b, digits=2)))
	println("\ta/b = ", round(a / b, digits=2))
	return Ellipse(a, b, x₀, y₀, θ)
end

# ╔═╡ 4ccc0563-ab71-4501-aebf-b8e9b1e4ef32
function viz!(ax, ellipse::Ellipse, color)
	# rotation matrix
	R = [cos(ellipse.θ) -sin(ellipse.θ); sin(ellipse.θ) cos(ellipse.θ)]

	# parameterization for canonical ellipse
	t = range(0.0, 2 * π, length=100)
	X = hcat(ellipse.a * cos.(t), ellipse.b * sin.(t))'

	# rotate
	X = R * X

	# translate
	X = X .+ [ellipse.x₀, ellipse.y₀]
	
	lines!(ax, X[1, :], X[2, :], color=color)
end

# ╔═╡ cf7cdd9e-d2d8-4b5a-b301-227dce4d9c7a
begin
end

# ╔═╡ 17981371-a213-4061-b998-8cd472570d5b
md"🩸 which cell is most spherical? most elliptical?"

# ╔═╡ Cell order:
# ╠═3072df64-b4ea-11f0-900f-9d704223bdbd
# ╟─563c54e8-0245-468e-a0d1-7d43f9a7bb5d
# ╟─65536468-295b-4bb7-a4d9-efca7c1bd1fa
# ╠═d2228c64-045c-4cf7-bbb6-24e4cd49f54a
# ╟─99a67856-159c-422b-980b-3da76438fae4
# ╠═2b5c8387-bbda-4db1-b593-7ef4d399db32
# ╠═0d755969-4a57-496e-8dab-000b37c47845
# ╟─10ff22f6-5d67-4237-8926-4ac8d4bfbbbe
# ╠═d994330e-e52d-445f-b543-937f83f5d5ff
# ╟─3a0c46bb-b9d1-41af-aa31-972aec9eede7
# ╠═af73310e-5da4-4fd3-b9d4-7b8918c36389
# ╟─f959fb3a-e95a-4def-a83a-fc725438fe8f
# ╠═9f7ee7bc-52d2-4f00-8f70-0613e8773f3a
# ╠═09ba9a57-f47d-43dd-86da-512f06be0345
# ╠═4ccc0563-ab71-4501-aebf-b8e9b1e4ef32
# ╠═cf7cdd9e-d2d8-4b5a-b301-227dce4d9c7a
# ╟─17981371-a213-4061-b998-8cd472570d5b
