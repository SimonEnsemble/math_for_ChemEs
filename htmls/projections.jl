### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ e4c2d62a-b352-11f0-8be7-6d27d600dab1
begin
	import Pkg
	Pkg.activate()
	using CairoMakie, LinearAlgebra
end

# ╔═╡ 4e6a9120-3cf9-4c70-9b3e-16d3477a1a22
begin
	set_theme!(theme_minimal())
	update_theme!(fontsize=15, markersize=14, linewidth=3)
end

# ╔═╡ f9feae51-fa73-4bc1-a67e-3d96298fefe7
begin
	function vectorspace()
		fig = Figure()
	    ax = Axis(
			fig[1, 1], 
			xlabel="x₁",
			ylabel="x₂",
			aspect=DataAspect()
		)
	
		hlines!(ax, 0.0, color="black", linewidth=1)
		vlines!(ax, 0.0, color="black", linewidth=1)
		hidespines!(ax)
		return fig, ax
	end
		
	function add_vector!(
		ax, a::Vector{Float64}; 
		color=:blue, linewidth=2, arrowsize=10, label=""
	)   
	    # Plot the vector line
	    lines!(ax, [0, a[1]], [0, a[2]], 
	           color=color, linewidth=linewidth)
	    
	    # Add arrowhead
	    arrows2d!(ax, [0], [0], [a[1]], [a[2]], 
	            color=color)
	
		if ! isempty(label)
	        text!(ax, a[1]/2, a[2]/2 * 1.1, text=label, color=color)
	    end
	end
	nothing
end

# ╔═╡ 962923b7-afe2-43c0-8aec-41ec2a7d1eb8
md"# projection onto a line

we have a vector $\mathbf{b}$ we want to project onto a line thru the vector $\mathbf{a}$.
"

# ╔═╡ 29d84e7f-8298-4a9c-bc64-bd0c70517da8
a = [5.0, 4]

# ╔═╡ 75cd9e67-1aa6-4756-b7a4-0788a824edd2
b = [2.2, 1]

# ╔═╡ 9e9964d8-f815-4386-b4d3-813ea8c3c591
begin
	local fig, ax = vectorspace()
	add_vector!(ax, a, label="a")
	add_vector!(ax, b, label="b", color=:red)
	fig
end

# ╔═╡ 511ec408-324c-4b23-94a8-e74c9ab105c3
md"
direct formula for the projected vector.
```math
\mathbf{p} = \frac{\mathbf{a}^\intercal \mathbf{b}}{\mathbf{a}^\intercal\mathbf{a}}\mathbf{a}
```
"

# ╔═╡ 727d811e-a8c0-40f1-8d04-3b099a115ffc
p = a' * b / (a' * a) * a

# ╔═╡ 34112f2a-49e5-4ac0-996e-b88b5200412e
md"
formula for the projection matrix that projects any vector onto the line thru $\mathbf{a}$.
```math
P = \frac{\mathbf{a}\mathbf{a}^\intercal}{\mathbf{a}^\intercal\mathbf{a}}
```
"

# ╔═╡ ea5924cb-3a49-4032-8147-0b8fac995126
P = a * a' / (a' * a)

# ╔═╡ ee49cd11-7d10-4be9-bc35-c32be7d805d9
P * b # == p

# ╔═╡ 757a2a0a-f679-4ef9-85fb-2ec1520fb5e7
begin
	local fig, ax = vectorspace()
	add_vector!(ax, a, label="a")
	add_vector!(ax, b, label="b", color=:red)
	add_vector!(ax, p, label="p", color=:green)
	fig
end

# ╔═╡ e9e4fa82-6107-4a2b-b581-fd8d28823063
md"# projection onto a subspace
we have a vector $\boldsymbol \beta$ we want to project onto the subspace spanned by vectors $a_1, ..., a_n$ in the columns of a matrix $A$.
"

# ╔═╡ 59b40359-2db7-4476-b409-4b95d7a8439d
A = [1 0; 1 1; 1 2] # has independent columns

# ╔═╡ 28cdb964-69bd-4376-80c7-939bf7fd6e9c
β = [6; 0; 0]

# ╔═╡ 6dd89c8e-678c-4c37-9c29-c7aa3643388a
md"solve the normal equations $A^\intercal A \hat{\mathcal{x}} =A^\intercal \boldsymbol \beta$ for the coefficients for the projection $\boldsymbol \rho=A \hat{\mathcal{x}}$."

# ╔═╡ be8cff24-72a6-4514-b5a1-de9cdc53de1d
A' * A # square, invertible matrix

# ╔═╡ 889425fd-7f14-49cf-88e1-e95e10006ac0
x̂ = (A' * A) \ (A' * β)

# ╔═╡ de536e0a-3c09-4a83-822e-6297497225fc
ρ = A * x̂

# ╔═╡ 4d911e2b-4fb0-46a2-90c2-dc50534cc25f
# or... (less efficient)
A * inv(A' * A) * A' * β

# ╔═╡ f0eb8825-3143-425b-942e-0fef485f88dd
md"the error vector $\mathbf{e}=\boldsymbol \beta - A \hat{\mathbf{x}}$ should be perpendicular to the columns of $A$ that span the subspace we're projecting onto."

# ╔═╡ dc0e73a0-9fc0-4d32-9ca8-dcea31af8668
e = β - ρ

# ╔═╡ a6174f90-6574-4600-8cf5-b96bbd810ed7
A' * e # ✔

# ╔═╡ Cell order:
# ╠═e4c2d62a-b352-11f0-8be7-6d27d600dab1
# ╠═4e6a9120-3cf9-4c70-9b3e-16d3477a1a22
# ╟─f9feae51-fa73-4bc1-a67e-3d96298fefe7
# ╟─962923b7-afe2-43c0-8aec-41ec2a7d1eb8
# ╟─9e9964d8-f815-4386-b4d3-813ea8c3c591
# ╠═29d84e7f-8298-4a9c-bc64-bd0c70517da8
# ╠═75cd9e67-1aa6-4756-b7a4-0788a824edd2
# ╠═511ec408-324c-4b23-94a8-e74c9ab105c3
# ╠═727d811e-a8c0-40f1-8d04-3b099a115ffc
# ╟─34112f2a-49e5-4ac0-996e-b88b5200412e
# ╠═ea5924cb-3a49-4032-8147-0b8fac995126
# ╠═ee49cd11-7d10-4be9-bc35-c32be7d805d9
# ╟─757a2a0a-f679-4ef9-85fb-2ec1520fb5e7
# ╟─e9e4fa82-6107-4a2b-b581-fd8d28823063
# ╠═59b40359-2db7-4476-b409-4b95d7a8439d
# ╠═28cdb964-69bd-4376-80c7-939bf7fd6e9c
# ╟─6dd89c8e-678c-4c37-9c29-c7aa3643388a
# ╠═be8cff24-72a6-4514-b5a1-de9cdc53de1d
# ╠═889425fd-7f14-49cf-88e1-e95e10006ac0
# ╠═de536e0a-3c09-4a83-822e-6297497225fc
# ╠═4d911e2b-4fb0-46a2-90c2-dc50534cc25f
# ╟─f0eb8825-3143-425b-942e-0fef485f88dd
# ╠═dc0e73a0-9fc0-4d32-9ca8-dcea31af8668
# ╠═a6174f90-6574-4600-8cf5-b96bbd810ed7
