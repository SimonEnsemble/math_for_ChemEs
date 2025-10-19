### A Pluto.jl notebook ###
# v0.20.19

using Markdown
using InteractiveUtils

# ╔═╡ fd4e9c98-ad41-11f0-27a1-55133daad7e8
begin
	import Pkg; Pkg.activate()
	using Graphs, CairoMakie, GraphMakie, LinearAlgebra, Random
end

# ╔═╡ dcf701e9-c170-473e-850f-c884c26d5add
begin
	Random.seed!(13)
	g = erdos_renyi(6, 0.4)
end

# ╔═╡ 184716a8-942f-4cdd-ae1d-f620f6ecf2cb
repr.(1:ne(g))

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

# ╔═╡ 41fb4537-a52b-48ca-bdbd-19e09807dc70
A = Matrix(incidence_matrix(g, oriented=true)')

# ╔═╡ cdf3970c-4942-4302-a3f4-dba65a0b2570
md"\# of connected components"

# ╔═╡ c41e2417-8713-4922-8e02-851891a82f2c
size(nullspace(A))[2]

# ╔═╡ d9bbec76-b957-4c26-ade4-9f88ef304621
md"\# of loops"

# ╔═╡ c4335889-ea11-43d1-a802-0d7d54954cca
size(nullspace(A'))[2]

# ╔═╡ Cell order:
# ╠═fd4e9c98-ad41-11f0-27a1-55133daad7e8
# ╠═dcf701e9-c170-473e-850f-c884c26d5add
# ╠═184716a8-942f-4cdd-ae1d-f620f6ecf2cb
# ╠═a49cd8d8-db81-4576-9112-6d3a8c7d2d46
# ╠═0050dbe9-a7d6-4347-a46d-2ff8d5df9607
# ╠═9e2d4ddd-65db-43d6-a005-3edb91f825f3
# ╠═41fb4537-a52b-48ca-bdbd-19e09807dc70
# ╟─cdf3970c-4942-4302-a3f4-dba65a0b2570
# ╠═c41e2417-8713-4922-8e02-851891a82f2c
# ╟─d9bbec76-b957-4c26-ade4-9f88ef304621
# ╠═c4335889-ea11-43d1-a802-0d7d54954cca
