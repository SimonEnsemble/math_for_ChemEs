### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 545ffe44-b69f-11f0-9c04-6b630043aedf
begin
	import Pkg; Pkg.activate()
	using CairoMakie, DelimitedFiles, LinearAlgebra, ColorSchemes, PlutoUI
end

# ╔═╡ 205f49d6-aeff-4d85-af31-1844b02b96c4
md"🎨 stuff for data visualizations..."

# ╔═╡ 1591fca0-a408-43ca-9a41-021f0b4470a8
colors = ColorSchemes.sanzo_131[2:3]

# ╔═╡ d964fbf9-04e8-484b-b9f2-b45d78bb2b9a
update_theme!(fontsize=15)

# ╔═╡ 186e5184-b8bb-4e50-b81e-75a9830cbd51
md"# linear transformations and the determinant of a matrix

!!! note \"learning resources\"
	please watch the two short YouTube videos by math animator _3Blue1Brown_:
    1. Linear transformations and matrices | Chapter 3, Essence of linear algebra [link](https://www.youtube.com/watch?v=kYB8IZa5AuE&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab)
	2. The determinant | Chapter 6, Essence of linear algebra [link](https://www.youtube.com/watch?v=Ip3X9LOh2dk&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=6)
	you may also want to check out the [linear transformations chapter](https://textbooks.math.gatech.edu/ila/matrix-transformations.html) of \"Interactive Linear Algebra\".

✏ our learning objectives are:
- understand how a linear transformation $\mathbf{x} \mapsto A \mathbf{x}$ and a matrix $A$ is completely characterized by how it transforms the coordinate unit vectors.
- visualize how $A$ transforms space
- understand what the determinant of $A$ tells us about the linear transformation.

☁ below, we read in coordinates for a cloud of points from `point_cloud.txt`.
"

# ╔═╡ 545caee9-5968-4e8a-97db-ec7a7f2ea61b
X = readdlm("point_cloud.txt")

# ╔═╡ fb2e2943-784d-4c13-b636-b4b0979116a2
function viz(X::Matrix{Float64})
	n = size(X)[2]
	i_to_color(i) = get(ColorSchemes.cyclic_mygbm_30_95_c78_n256, i / n)
	
	fig = Figure()
	ax = Axis(fig[1, 1], xlabel="x", ylabel="y", aspect=DataAspect())
	hidespines!(ax)
	# draw axes
	hlines!(0, color="black", linewidth=1)
	vlines!(0, color="black", linewidth=1)
	xlims!(-1, 1)
	ylims!(-1, 1)
	# draw points
	scatter!(X[1, :], X[2, :], color=[i_to_color(i) for i = 1:n], markersize=10)
	fig
end

# ╔═╡ 31e0862b-f20f-4867-a0d9-f44556ff85cc
viz(X)

# ╔═╡ b96939d4-c7b5-4f47-956a-e37245a44e98
viz(X)

# ╔═╡ 576f8a46-a47a-4b28-9e4e-f65d95c27bbd
md"
!!! note
	my function `viz_transformation` in the hidden cell below visualizes a matrix $A$ according to how it transforms the coordinate unit vectors $\mathbf{e}_1=\begin{bmatrix}1\\ 0\end{bmatrix}$ and $\mathbf{e}_1=\begin{bmatrix}0\\ 1\end{bmatrix}$.
"

# ╔═╡ db032be5-00ee-49fb-a5aa-f76a0b7114e9
function _draw_vector!(ax, x, color)
	arrows2d!(ax, [0], [0], [x[1]], [x[2]], color=color, shaftwidth=3)
end

# ╔═╡ 1002ae9f-97ae-4efd-b450-154cdf834848
function viz_transformation(A::Matrix)
	@assert size(A) == (2, 2)
	
	fig = Figure()
	axs = [
		Axis(
			fig[1, i], xlabel="x", ylabel="y", aspect=DataAspect()
		) for i = 1:2
	]
	linkaxes!(axs...)
	
	axs[1].title = "domain"
	axs[2].title = "range"
	
	# draw axes
	for ax in axs
		hidespines!(ax)

		xlims!(ax, -3.1, 3.1)
		ylims!(ax, -3.1, 3.1)
		hlines!(ax, 0, color="black", linewidth=1)
		vlines!(ax, 0, color="black", linewidth=1)
	end
	# draw original vectors and their transformations
	
	e₁ = [1.0, 0.0]
	e₂ = [0.0, 1.0]
	
	for (i, e) in enumerate([e₁, e₂])
		# domain
		_draw_vector!(axs[1], e, colors[i])

		# range
		t = A * e
		_draw_vector!(axs[2], t, colors[i])
	end
	fig
end

# ╔═╡ bcfbd1f5-e3c4-4ad4-b5d2-28c2ce70b2b2
md"## visualizing transformations and the determinant
☁  use the selector to pick different matrices and visualize how they transform the coordinate unit vectors $\mathbf{e}_{1,2}$ and transform the cloud of points. note the determinant. 
"

# ╔═╡ add76556-d82b-4601-bac1-56c7d6766077
θ = π / 4 # angle, for reflection

# ╔═╡ fe404425-362a-44e9-9643-593125dd0c38
u = [1.0; 2.0] # direction, for projection

# ╔═╡ 50e2966e-529a-4051-8e1f-facf742da086
matrices = Dict(
	"identity matrix" => [1 0; 0 1],
	"dilation matrix" => [1.5 0; 0 1.5],
	"contraction matrix" => [0.5 0; 0 0.5],
	"x-dilation & y-contraction matrix" => [2/3 0; 0 3/2],
	"shearing matrix" => [1 1; 0 1],
	"rotation matrix" => [cos(θ) -sin(θ); sin(θ) cos(θ)],
	"reflection matrix" => [-1 0; 0 1],
	"projection matrix" => u * u' / dot(u, u),
)

# ╔═╡ 855e9048-f038-4706-ba3a-86cc7a54dc5f
@bind matrix Select(collect(keys(matrices)))

# ╔═╡ ef660e74-9284-4ac2-8e5b-c44ec1945bd7
A = matrices[matrix]

# ╔═╡ c37b5e86-dc4b-4ed3-b855-51e57e94b5a1
try inv(A)
	println("A is invertible!")
catch SingularException
	println("A is singular!")
end

# ╔═╡ 1f5474bd-d8cd-449e-ad61-f1c2e9d24e37
println("determinant of A: ", det(A))

# ╔═╡ 7564b3d4-d815-4d32-b12d-a928f9fcee52
# visualize transformation of e₁ and e₂
viz_transformation(A)

# ╔═╡ 7c9eecb8-ecd5-4689-b806-5a3b6aebbcbf
# visualize transformation of point cloud
viz(A * X)

# ╔═╡ 4f18075b-422e-4be0-a16e-8100a115ba6d
md"# questions
1. which transformations give a determinant of zero? why? when the determinant is zero, what happens to the point cloud? what happens to the area of the triangle formed by the transformed coordinate vectors?

2. which transformations give a determinant of one? why?

3. which transformations give a negative determinant? why?

4. what transformation gives the smallest non-zero determinant, and why? same question, but for the largest non-zero determinant.
"

# ╔═╡ Cell order:
# ╠═545ffe44-b69f-11f0-9c04-6b630043aedf
# ╟─205f49d6-aeff-4d85-af31-1844b02b96c4
# ╠═1591fca0-a408-43ca-9a41-021f0b4470a8
# ╠═d964fbf9-04e8-484b-b9f2-b45d78bb2b9a
# ╟─186e5184-b8bb-4e50-b81e-75a9830cbd51
# ╠═545caee9-5968-4e8a-97db-ec7a7f2ea61b
# ╠═31e0862b-f20f-4867-a0d9-f44556ff85cc
# ╠═fb2e2943-784d-4c13-b636-b4b0979116a2
# ╠═b96939d4-c7b5-4f47-956a-e37245a44e98
# ╟─576f8a46-a47a-4b28-9e4e-f65d95c27bbd
# ╠═db032be5-00ee-49fb-a5aa-f76a0b7114e9
# ╠═1002ae9f-97ae-4efd-b450-154cdf834848
# ╟─bcfbd1f5-e3c4-4ad4-b5d2-28c2ce70b2b2
# ╠═add76556-d82b-4601-bac1-56c7d6766077
# ╠═fe404425-362a-44e9-9643-593125dd0c38
# ╠═50e2966e-529a-4051-8e1f-facf742da086
# ╠═855e9048-f038-4706-ba3a-86cc7a54dc5f
# ╠═ef660e74-9284-4ac2-8e5b-c44ec1945bd7
# ╠═c37b5e86-dc4b-4ed3-b855-51e57e94b5a1
# ╠═1f5474bd-d8cd-449e-ad61-f1c2e9d24e37
# ╠═7564b3d4-d815-4d32-b12d-a928f9fcee52
# ╠═7c9eecb8-ecd5-4689-b806-5a3b6aebbcbf
# ╟─4f18075b-422e-4be0-a16e-8100a115ba6d
