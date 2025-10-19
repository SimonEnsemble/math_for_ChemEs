### A Pluto.jl notebook ###
# v0.20.19

using Markdown
using InteractiveUtils

# ╔═╡ fd4e9c98-ad41-11f0-27a1-55133daad7e8
begin
	import Pkg; Pkg.activate()
	using Graphs, CairoMakie, GraphMakie, LinearAlgebra, Random
end

# ╔═╡ 9c209a2c-10c5-47cb-8fdd-819fd8f27a60
md"create a random graph."

# ╔═╡ dcf701e9-c170-473e-850f-c884c26d5add
begin
	Random.seed!(14)
	g = erdos_renyi(8, 0.35)
end

# ╔═╡ a49cd8d8-db81-4576-9112-6d3a8c7d2d46
begin
	f, ax, p = graphplot(
		g,
		ilabels=repr.(1:nv(g)),
		elabels=repr.(1:ne(g))
	)
	hidedecorations!(ax); hidespines!(ax)
	ax.aspect = DataAspect()
	f
end

# ╔═╡ 0050dbe9-a7d6-4347-a46d-2ff8d5df9607
println("# edges: ", ne(g))

# ╔═╡ 9e2d4ddd-65db-43d6-a005-3edb91f825f3
println("# vertices: ", nv(g))

# ╔═╡ b35a4340-2c3d-473a-bfb3-3f46f912759b
md"construct the edge-node incidence matrix of the graph"

# ╔═╡ 41fb4537-a52b-48ca-bdbd-19e09807dc70
A = Matrix(incidence_matrix(g, oriented=true)')

# ╔═╡ cdf3970c-4942-4302-a3f4-dba65a0b2570
md"\# of connected components = dimension of null space of incidence matrix"

# ╔═╡ c41e2417-8713-4922-8e02-851891a82f2c
size(nullspace(A))[2]

# ╔═╡ d9bbec76-b957-4c26-ade4-9f88ef304621
md"\# of independent loops = dimension of left-null space of incidence matrix"

# ╔═╡ c4335889-ea11-43d1-a802-0d7d54954cca
size(nullspace(A'))[2]

# ╔═╡ Cell order:
# ╠═fd4e9c98-ad41-11f0-27a1-55133daad7e8
# ╟─9c209a2c-10c5-47cb-8fdd-819fd8f27a60
# ╠═dcf701e9-c170-473e-850f-c884c26d5add
# ╠═a49cd8d8-db81-4576-9112-6d3a8c7d2d46
# ╠═0050dbe9-a7d6-4347-a46d-2ff8d5df9607
# ╠═9e2d4ddd-65db-43d6-a005-3edb91f825f3
# ╟─b35a4340-2c3d-473a-bfb3-3f46f912759b
# ╠═41fb4537-a52b-48ca-bdbd-19e09807dc70
# ╟─cdf3970c-4942-4302-a3f4-dba65a0b2570
# ╠═c41e2417-8713-4922-8e02-851891a82f2c
# ╟─d9bbec76-b957-4c26-ade4-9f88ef304621
# ╠═c4335889-ea11-43d1-a802-0d7d54954cca
