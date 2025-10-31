### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 3072df64-b4ea-11f0-900f-9d704223bdbd
begin
	import Pkg; Pkg.activate()
	using CairoMakie, CSV, DataFrames, LinearAlgebra, ColorSchemes
end

# ╔═╡ 94e47358-9f4b-4a28-aa03-d0f375407b63
update_theme!(fontsize=18)

# ╔═╡ 9727b36d-97a0-4f4a-8d23-414347eb3d65
md"
# least-squares fitting of ellipses to outlines of biological cells


## background
❓ what's an ellipse?

> an ellipse is a plane curve surrounding two focal points, such that for all points on the curve, the sum of the two distances to the focal points is a constant. -Wikipedia

see how to draw a good ellipse with a pencil on [YouTube](https://www.youtube.com/shorts/c-MO1gM2BKE).
"

# ╔═╡ 33862541-8b98-474c-a90c-a759f571d70b
html"<img src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Ellipse-def-e.svg/1024px-Ellipse-def-e.svg.png\" width=400>"

# ╔═╡ 59eb1cc5-d17b-4203-b9a1-307ef3bce5cd
md"an ellipse is a [conic section](https://en.wikipedia.org/wiki/Conic_section) i.e. obtained by an intersection of a plane with the surface of a cone in 3D space.
"

# ╔═╡ 441c4050-f83b-490e-a8da-049a839c6696
html"<img src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Ellipse-conic.svg/800px-Ellipse-conic.svg.png\" width=300>"

# ╔═╡ 4e79ee19-9a8f-4eb6-bb99-2d7cd37119ed
md"
as an implicit equation for an ellipse, all points $(x, y)$ in the plane must satisfy
```math
x^2 + B x y + C y^2 + D x + E y+ F = 0
```
with $B,C,D,E,F$ constants that satisfy two conditions: (1) the discriminant $\Delta := B^2-4C<0$ and (2) [non-degeneracy](https://en.wikipedia.org/wiki/Conic_section#Degenerate_cases).
to arrive at this implicit eqn, we could (1) combine the equation for the surface of a cone and the equation for a plane or (2) enforce the sum of the two distances of any point from the two focal points is constant.

the constants $B,C,D,E,F$ determine:
* the two focal points in the plane
* the sum of distances from the two focal points
and, thus:
* the length of the semi-major and semi-minor axes, $a$ & $b$
* the center of the ellipse, $(x_o, y_o)$
* the orientation/tilt/angle of the ellipse, $\theta$

see [Wikipedia](https://en.wikipedia.org/wiki/Ellipse#General_ellipse).
"


# ╔═╡ 8fe67928-b30b-4ede-8f3e-55cb7c7deace
html"<img src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/General_ellipse.png/800px-General_ellipse.png\" width=500>"

# ╔═╡ efe2d926-b047-4e96-af3e-a839d0be5b75
md"
❓ given a set of points tracing out an ellipse-like shape, how do I find the equation of the ellipse that fit them best?

!!! note
	for background on least-squares fitting of an ellipse, see the \"best-fit ellipse\" example in:
	> D. Margalit, J. Rabinoff. \"The Method of Least Squares\". _Interactive Linear Algebra_ [link](https://textbooks.math.gatech.edu/ila/least-squares.html)"

# ╔═╡ ae368aed-1662-4a41-807d-c49df67437dd
md"
❓ fitting an ellipse to the outline of biological cells? why?

images of biological cells can be analyzed for statistics on their size and shape. this can help diagnose disease, track health, and/or inform research. given ellipse-shaped cells, fitting an ellipse to each cell in the image is one method to characterize the distribution of the cell sizes and shapes.

see:

> Abera, M.K., Verboven, P., Defraeye, T., Fanta, S.W., Hertog, M.L., Carmeliet, J. and Nicolai, B.M., 2014. A plant cell division algorithm based on cell biomechanics and ellipse-fitting. _Annals of Botany_, 114(4), pp.605-617. [link](https://academic.oup.com/aob/article/114/4/605/2769029)

> Kothari, S., Chaudry, Q. and Wang, M.D., 2009, June. Automated cell counting and cluster segmentation using concavity detection and ellipse fitting techniques. In 2009 IEEE International Symposium on Biomedical Imaging: From Nano to Macro (pp. 795-798). IEEE. [link](https://ieeexplore.ieee.org/abstract/document/5193169)

> Bai, X., Sun, C. and Zhou, F., 2009. Splitting touching cells based on concave points and ellipse fitting. Pattern Recognition, 42(11), pp.2434-2446. [link](https://www.sciencedirect.com/science/article/abs/pii/S0031320309001435)
"

# ╔═╡ 65536468-295b-4bb7-a4d9-efca7c1bd1fa
md"
## let's do an example!
🩸 read in the data tracing the outlines of six different red blood cells of a patient with hereditary elliptocytosis. the data are stored in the CSV file `cell_outlines.csv`.


> Elliptocytes, also known as ovalocytes or cigar cells, are abnormally shaped red blood cells that appear oval or elongated, from slightly egg-shaped to rod or pencil forms. They have normal central pallor with the hemoglobin appearing concentrated at the ends of the elongated cells when viewed through a light microscope. 
> -- \"Elliptocyte\". Wikipedia. [link](https://en.wikipedia.org/wiki/Elliptocyte)
" 

# ╔═╡ 06844870-ce5b-47f8-aceb-5a9bb582104e
md"!!! note
	I plot-digitized the outlines of a few cells from this image here. the length-scales are reasonable, but I made them up since they were not provided via a scale bar in the image.
"

# ╔═╡ ab1abdcb-d9f8-470b-a87c-42330d9d4423
html"<img src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Hereditary_Elliptocytosis_in_a_70-year-old_man.tif/lossy-page1-2560px-Hereditary_Elliptocytosis_in_a_70-year-old_man.tif.jpg\" width=400>"

# ╔═╡ d2228c64-045c-4cf7-bbb6-24e4cd49f54a
data = CSV.read("cell_outlines.csv", DataFrame)

# ╔═╡ 99a67856-159c-422b-980b-3da76438fae4
md"🩸 plot the data in the 2D plane. make each cell a different color.

!!! hint
	see the `filter` function for data frames. check out `ColorSchemes.jl` for color schemes.
"

# ╔═╡ 96af5e8c-da34-4057-bd54-9b8424a6c840
# list of unique cells
cells = unique(data[:, "cell"])

# ╔═╡ 2b5c8387-bbda-4db1-b593-7ef4d399db32
# dictionary to map cells to color
cell_to_color = Dict(zip(cells, ColorSchemes.Dark2_6))

# ╔═╡ 0d755969-4a57-496e-8dab-000b37c47845
begin
	fig = Figure()
	ax = Axis(fig[1, 1], aspect=DataAspect(), xlabel="x [µm]", ylabel="y [µm]")
	for cell in cells
		# filter out data pertaining to this cell only
		data_cell = filter(row -> row["cell"] == cell, data)
		
		# plot the outline of this cell
		scatter!(
			data_cell[:, "x [µm]"], data_cell[:, "y [µm]"], 
			label=cell, color=cell_to_color[cell]
		)
	end
	axislegend("cell", position=:cc)
	fig
end

# ╔═╡ 10ff22f6-5d67-4237-8926-4ac8d4bfbbbe
md"🩸 write a function that takes in a data frame with the outlines of the cells and a particular cell label, then
1. filters the data that pertain to that cell
2. builds the linear system $A\mathbf{x}=\mathbf{b}$ for fitting an ellipse to that cell outline
it should return the coefficient matrix $A$ and right hand size vector $b$. 

here, the unknown vector $\mathbf{x}=[B, C, D, E, F]$ constitutes the parameters of the ellipse (we check it's a valid ellipse later).
"

# ╔═╡ d994330e-e52d-445f-b543-937f83f5d5ff
"""
	build_linear_system(data, cell)

build linear system A x = b for fitting an ellipse to 
a particular cell.

here x = [B, C, D, E, F]
in the implicit eqn for an ellipse:
x^2 + B x y + C y^2 + D x + E y + F = 0
"""
function build_linear_system(data, cell)
	# filter data pertaining to this cell
	data_cell = filter(row -> row["cell"] == cell, data)
	
	# coordinates of the cell outline
	x = data_cell[:, "x [µm]"]
	y = data_cell[:, "y [µm]"]

	# A x = b
	b = - x .^ 2
	A = hcat(x .* y, y .^ 2, x, y, ones(length(x)))
	
	return A, b
end

# ╔═╡ a6f9944c-74aa-4bcc-a858-4d120325b7c3
A, b = build_linear_system(data, "A")

# ╔═╡ 3a0c46bb-b9d1-41af-aa31-972aec9eede7
md"🩸 write a function that takes in the entire data and a particular cell label then:
1. builds the linear system $A\mathbf{x}=\mathbf{b}$ for the ellipse of best fit to that cell outline
2. uses least squares to solve the linear system for $\mathbf{x}$. 

the function should return the $B, C, D, E, F$ parameters in the implicit ellipse equation that fit the data best.
"

# ╔═╡ af73310e-5da4-4fd3-b9d4-7b8918c36389
function fit_ellipse(data, cell)
	A, b = build_linear_system(data, cell)

	# B, C, D, E, F = (A' * A) \ (A' * b) # not efficient
	B, C, D, E, F = A \ b # solves least-squares problem with A = QR
end

# ╔═╡ d19083b6-1759-4ad3-bbdd-351dca81e4f0
fit_ellipse(data, "A")

# ╔═╡ f959fb3a-e95a-4def-a83a-fc725438fe8f
md"🩸 fit an ellipse to all cells. draw the ellipses on top of the data outlining the cells."

# ╔═╡ 9f7ee7bc-52d2-4f00-8f70-0613e8773f3a
# data structure for an ellipse, for plotting purposes
struct Ellipse
	# length of semi-major and semi-minor axis
	a::Float64
	b::Float64
	# center
	x₀::Float64
	y₀::Float64
	# angle
	θ::Float64
end

# ╔═╡ f66b26d6-fc55-4347-ba0f-4fe91467dbc0
# form ellipse with coeffs. from implicit eqn.
function build_ellipse(B, C, D, E, F)
	# https://en.wikipedia.org/wiki/Ellipse#Parametric_representation
	Δ = B ^ 2 - 4 * C
	@assert Δ < 0.0

	a = -sqrt(2*(E^2 + C*D^2 - B*D*E + Δ*F) * (1+C + sqrt((1-C)^2 + B^2))) / Δ
	b = -sqrt(2*(E^2 + C*D^2 - B*D*E + Δ*F) * (1+C - sqrt((1-C)^2 + B^2))) / Δ
	
	x₀ = (2 * C * D - B * E) / Δ
	y₀ = (2 * 1 * E - B * D) / Δ
	
	θ = 1/2 * atan(-B, C - 1)

	println("\tcenter: ", (round(x₀, digits=2), round(y₀, digits=2)))
	println("\ta, b = ", (round(a, digits=2), round(b, digits=2)))
	println("\ta/b = ", round(a / b, digits=2))
	println("\teccentricity = ", round(sqrt(1 - (b/a)^2), digits=2))
	
	return Ellipse(a, b, x₀, y₀, θ)
end

# ╔═╡ 4ccc0563-ab71-4501-aebf-b8e9b1e4ef32
# draw an ellipse on an axis
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
	for cell in cells
		println("cell: ", cell)
		
		B, C, D, E, F = fit_ellipse(data, cell)
		
		ellipse = build_ellipse(B, C, D, E, F)
		
		viz!(ax, ellipse, "black")
	end
	fig
end

# ╔═╡ 17981371-a213-4061-b998-8cd472570d5b
md"🩸 which cell is most [essentric](https://en.wikipedia.org/wiki/Ellipse#Eccentricity_and_the_directrix_property)? least essentric?

cell F is least eccentric, while cell E is most eccentric. 
"

# ╔═╡ d8ce94b8-1bb3-46e1-afd9-0a1800b4b887
md"🩸 more manually solving the least squares problem with the $A=QR$ factorization.

the normal eqn is
```math
A^\intercal A \hat{\mathbf{x}} = A^\intercal \mathbf{b}.
```
applying the $A=QR$ factorization, where $Q$ has orthonormal columns and $R$ is triangular:
```math
R^\intercal Q^\intercal QR \hat{\mathbf{x} } = R^\intercal Q^\intercal \mathbf{b}.
```
and using $Q^\intercal Q=I$:
```math
R^\intercal R \hat{\mathbf{x} } = R^\intercal Q^\intercal \mathbf{b}.
```
so the eqn is really just the following triangular system:
```math
 R \hat{\mathbf{x}} = Q^\intercal \mathbf{b}.
```
it is more efficient and numerically stable to solve _this_ system instead of directly computing $A^\intercal A$.
"

# ╔═╡ 8c04a8f8-a7ea-4e7c-ab87-0d41e04edbc4
qr_fact = qr(A)

# ╔═╡ b0597c76-53dd-4099-839c-f95126f3aa19
R = qr_fact.R

# ╔═╡ eaef0e2b-8fb4-4fd6-b665-4f47867cb449
Q = Matrix(qr_fact.Q)

# ╔═╡ 152787db-65f9-4b1f-9089-cdead02a7329
md"note all three give the same result for the best-fit ellipse."

# ╔═╡ 67ae8b1f-d534-4cd0-b530-416888387f00
x̂ = R \ (Q' * b)

# ╔═╡ c0f22b24-8980-4503-b865-101bdf098d88
A \ b

# ╔═╡ 6cf55a71-dcf2-4a5b-9e54-bf2bea2a434e
(A' * A) \ (A' * b)

# ╔═╡ dd1984d5-55ac-4476-a087-dd43328a9fed
fit_ellipse(data, "A")

# ╔═╡ Cell order:
# ╠═3072df64-b4ea-11f0-900f-9d704223bdbd
# ╠═94e47358-9f4b-4a28-aa03-d0f375407b63
# ╟─9727b36d-97a0-4f4a-8d23-414347eb3d65
# ╟─33862541-8b98-474c-a90c-a759f571d70b
# ╟─59eb1cc5-d17b-4203-b9a1-307ef3bce5cd
# ╟─441c4050-f83b-490e-a8da-049a839c6696
# ╟─4e79ee19-9a8f-4eb6-bb99-2d7cd37119ed
# ╟─8fe67928-b30b-4ede-8f3e-55cb7c7deace
# ╟─efe2d926-b047-4e96-af3e-a839d0be5b75
# ╟─ae368aed-1662-4a41-807d-c49df67437dd
# ╟─65536468-295b-4bb7-a4d9-efca7c1bd1fa
# ╟─06844870-ce5b-47f8-aceb-5a9bb582104e
# ╟─ab1abdcb-d9f8-470b-a87c-42330d9d4423
# ╠═d2228c64-045c-4cf7-bbb6-24e4cd49f54a
# ╟─99a67856-159c-422b-980b-3da76438fae4
# ╠═96af5e8c-da34-4057-bd54-9b8424a6c840
# ╠═2b5c8387-bbda-4db1-b593-7ef4d399db32
# ╠═0d755969-4a57-496e-8dab-000b37c47845
# ╟─10ff22f6-5d67-4237-8926-4ac8d4bfbbbe
# ╠═d994330e-e52d-445f-b543-937f83f5d5ff
# ╠═a6f9944c-74aa-4bcc-a858-4d120325b7c3
# ╟─3a0c46bb-b9d1-41af-aa31-972aec9eede7
# ╠═af73310e-5da4-4fd3-b9d4-7b8918c36389
# ╠═d19083b6-1759-4ad3-bbdd-351dca81e4f0
# ╟─f959fb3a-e95a-4def-a83a-fc725438fe8f
# ╠═9f7ee7bc-52d2-4f00-8f70-0613e8773f3a
# ╠═f66b26d6-fc55-4347-ba0f-4fe91467dbc0
# ╠═4ccc0563-ab71-4501-aebf-b8e9b1e4ef32
# ╠═cf7cdd9e-d2d8-4b5a-b301-227dce4d9c7a
# ╟─17981371-a213-4061-b998-8cd472570d5b
# ╟─d8ce94b8-1bb3-46e1-afd9-0a1800b4b887
# ╠═8c04a8f8-a7ea-4e7c-ab87-0d41e04edbc4
# ╠═b0597c76-53dd-4099-839c-f95126f3aa19
# ╠═eaef0e2b-8fb4-4fd6-b665-4f47867cb449
# ╟─152787db-65f9-4b1f-9089-cdead02a7329
# ╠═67ae8b1f-d534-4cd0-b530-416888387f00
# ╠═c0f22b24-8980-4503-b865-101bdf098d88
# ╠═6cf55a71-dcf2-4a5b-9e54-bf2bea2a434e
# ╠═dd1984d5-55ac-4476-a087-dd43328a9fed
