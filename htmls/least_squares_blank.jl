### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ e4c2d62a-b352-11f0-8be7-6d27d600dab1
begin
	import Pkg
	Pkg.activate()
	using CairoMakie, DataFrames, CSV
end

# ╔═╡ 4e6a9120-3cf9-4c70-9b3e-16d3477a1a22
begin
	set_theme!(theme_ggplot2())
	update_theme!(fontsize=15, markersize=14, linewidth=3)
end

# ╔═╡ 962923b7-afe2-43c0-8aec-41ec2a7d1eb8
md"# modeling the density of saline solution

to characterize the density of saline solution as a function of salt concentration at constant [room] temperature, we wish to fit the linear  model
```math
\rho(x) = \rho_0 + \alpha x
```
to the data below.
*  $\rho$ [g/cm³]: density of the saline solution
*  $x$ [wt %]: weight percent NaCl comprising the solution
*  $\alpha$: [(g/cm³)/(wt %)] rate of increase of density with respect to NaCl wt %
*  $\rho_0$ [g/cm³]: density of pure water

data are from:
> Wikipedia. \"Saline water\". [link](https://en.wikipedia.org/wiki/Saline_water).

🧂 put the raw data in a data frame.
"

# ╔═╡ edc34540-f8cd-4f4b-a7c9-559211b75d24
data = DataFrame(
    "NaCl [wt %]" => [0, 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20],
    "ρ [g/cm³]" => [0.99984, 1.0018, 1.0053, 1.0125, 1.0196, 1.0268, 1.0340, 1.0413, 1.0486, 1.0559, 1.0633, 1.0707, 1.0857, 1.1008, 1.1162, 1.1319, 1.1478]
)

# ╔═╡ 9ea05763-0fb3-460b-959f-caa93c0a80a2
md"🧂 visualize the data."

# ╔═╡ 3957af0e-cdea-495c-a07d-b2200db80865
md"🧂build linear system $A\mathbf{x}=\mathbf{b}$ with the unknowns $\mathbf{x}:=[\alpha, \rho_0]$."

# ╔═╡ f5405869-b39a-4a8a-9267-38aaad1468d6
md"🧂 solve the normal equation $A^\intercal A\mathbf{x}=A^\intercal \mathbf{b}$ for the params of best fit."

# ╔═╡ 2c6230e3-74f6-4d7f-a85b-a89813dc06ec
md"🧂 plot the model on top of the data to assess fit."

# ╔═╡ Cell order:
# ╠═e4c2d62a-b352-11f0-8be7-6d27d600dab1
# ╠═4e6a9120-3cf9-4c70-9b3e-16d3477a1a22
# ╟─962923b7-afe2-43c0-8aec-41ec2a7d1eb8
# ╠═edc34540-f8cd-4f4b-a7c9-559211b75d24
# ╟─9ea05763-0fb3-460b-959f-caa93c0a80a2
# ╟─3957af0e-cdea-495c-a07d-b2200db80865
# ╟─f5405869-b39a-4a8a-9267-38aaad1468d6
# ╟─2c6230e3-74f6-4d7f-a85b-a89813dc06ec
