### A Pluto.jl notebook ###
# v0.20.19

using Markdown
using InteractiveUtils

# ╔═╡ 7c869bcc-a56b-11f0-3ca0-ab3ac9b86d69
begin
	import Pkg;Pkg.activate()
	using CairoMakie,Graphs, GraphMakie
end

# ╔═╡ 0c3087a9-6f38-4b5f-a8b5-07b29a5b55c0
begin
	g = Graph(6)
	add_edge!(g, 1, 2)
	add_edge!(g, 1, 3)
	add_edge!(g, 4, 3)
	add_edge!(g, 4, 5)
	add_edge!(g, 6, 5)
	add_edge!(g, 6, 1)
	add_edge!(g, 3, 6)
	add_edge!(g, 4, 6)
end

# ╔═╡ 1c76485a-2232-4c47-b472-c6e2b82ee8cf
begin
	fig = Figure(size=(300, 300))
	ax = Axis(fig[1, 1])
	hidedecorations!(ax); hidespines!(ax)
	graphplot!(g, ilabels=["$i" for i = 1:nv(g)])
	save("my_graph.pdf", fig)
	fig
end

# ╔═╡ 4f2c360b-6570-40c2-8bbd-d99ebdd71ef5
S = adjacency_matrix(g)

# ╔═╡ 5e92a891-afd8-468d-a04f-661f12270ff0
(S^4)[2, 4]

# ╔═╡ Cell order:
# ╠═7c869bcc-a56b-11f0-3ca0-ab3ac9b86d69
# ╠═0c3087a9-6f38-4b5f-a8b5-07b29a5b55c0
# ╠═1c76485a-2232-4c47-b472-c6e2b82ee8cf
# ╠═4f2c360b-6570-40c2-8bbd-d99ebdd71ef5
# ╠═5e92a891-afd8-468d-a04f-661f12270ff0
