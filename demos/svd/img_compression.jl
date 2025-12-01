### A Pluto.jl notebook ###
# v0.20.18

using Markdown
using InteractiveUtils

# ╔═╡ 217b66c0-cedf-11f0-bb6f-f34bad88e85f
begin
	import Pkg; Pkg.activate()
	using CairoMakie, LinearAlgebra, Images
end

# ╔═╡ cb0dec00-286b-49bb-9ecd-6e278460175b
md"# image compression"

# ╔═╡ 6f314a1f-d1cd-41da-8aec-bff068c9373e
img = Gray.(load("oslo.jpeg"))

# ╔═╡ 63adc917-5750-4b9b-99ab-6532f07d750a
A = Float64.(img)

# ╔═╡ 10fb84a2-1536-4fa6-af04-bd518011baf1
image(A',  axis=(aspect = DataAspect(), yreversed=true, title="OG"))

# ╔═╡ Cell order:
# ╠═217b66c0-cedf-11f0-bb6f-f34bad88e85f
# ╟─cb0dec00-286b-49bb-9ecd-6e278460175b
# ╠═6f314a1f-d1cd-41da-8aec-bff068c9373e
# ╠═63adc917-5750-4b9b-99ab-6532f07d750a
# ╠═10fb84a2-1536-4fa6-af04-bd518011baf1
