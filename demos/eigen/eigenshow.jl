### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 9c4c1df8-bdd8-11f0-97de-b9d5501b6f88
begin
	import Pkg; Pkg.activate()
	using CairoMakie, LinearAlgebra, PlutoUI
	using Test
end

# ╔═╡ 704f15f0-acaf-43f9-9164-5693ddec550c
set_theme!(theme_minimal())

# ╔═╡ 178fa6d9-1177-4f58-98d7-f074118d674e
md"# eigenvalues and eigenvectors

see [Ch. 5](https://textbooks.math.gatech.edu/ila/chap-eigenvalues.html) of \"Interactive Linear Algebra\".

🐶 define a matrix.
"

# ╔═╡ f6d53a9e-f79e-4fab-9e09-6b5e39bc5eca
A = [
	2.0 2.0
	0.0 1.0
]

# ╔═╡ 8ab1c7b2-f84a-4e1b-acb6-bb5759df3f2d
md"🐶 compute eigenvalues and eigenvectors"

# ╔═╡ b9a22015-a36a-4287-8a6e-e746b5035429
# compute eigenvalues and eigenvectors
λs, X = eigen(A)

# ╔═╡ 513aabce-8ad9-4ad3-b072-1ea95f813465
# unpack eigenvalues
λ₁, λ₂ = λs

# ╔═╡ 0aeb0b4e-5897-4b01-b73c-6a95195dfe90
x₁ = X[:, 1] # eigenvector 1

# ╔═╡ 8f0f5f7e-2cba-414e-9f62-e69406e371ef
x₂ = X[:, 2] # eigenvector 2

# ╔═╡ 0416dc56-81cd-4fba-bd92-6b9a040c70d1
md"🐶 test $A\mathbf{x}=\lambda \mathbf{x}$."

# ╔═╡ 61e64d14-6b6f-4569-aaa9-14203cec7d12
@test A * x₁ ≈ λ₁ * x₁

# ╔═╡ 095904ea-c4ab-4ac3-8503-b77423bb63d3
@test A * x₂ ≈ λ₂ * x₂

# ╔═╡ 0fd6b926-584d-4562-bb3f-c68d7b95aba8
md"🐶 visualize the linear transformations."

# ╔═╡ 93305175-4233-42df-9ff4-ef9cee8faf01
function _draw_vector!(ax, x, color, label, Δ; alpha=0.5)
    arrows2d!(
		ax, [0], [0], [x[1]], [x[2]], color=color, shaftwidth=3, alpha=alpha
	)
	text!([x[1]], [x[2]+Δ], text=[rich(label, font=:bold, color=color)])
end

# ╔═╡ f18ed671-d333-4bb7-b6ed-39b3670f969d
begin
	fig = Figure()
	ax = Axis(fig[1, 1], xlabel="x₁", ylabel="x₂", aspect=DataAspect())
	hidespines!(ax)
	hlines!(0.0, color="gray")
	vlines!(0.0, color="gray")
	
	_draw_vector!(ax, x₁, "green", "x₁", 0.1)
	_draw_vector!(ax, x₂, "green", "x₂", 0.1)

	_draw_vector!(ax, A * x₁, "blue", "Ax₁", -0.35)
	_draw_vector!(ax, A * x₂, "blue", "Ax₂", -0.25)
	
	xlims!(-2.3, 2.3)
	ylims!(-2.3, 2.3)
	fig
end

# ╔═╡ d2f663aa-e1c2-4bc4-9b96-45b11c961c9b
md"🐶 diagonization of the matrix $A=X\Lambda X^{-1}$"

# ╔═╡ 27c6abc5-b49b-4557-aa5b-f313ec7c3a28
Λ = diagm(λs)

# ╔═╡ b0855605-3ff8-47f6-8511-52ea1b0cb313
X # eigenvectors in cols

# ╔═╡ fd8f1214-0b83-443f-9aa7-d90321e5489b
@test A ≈ X * Λ * inv(X)

# ╔═╡ Cell order:
# ╠═9c4c1df8-bdd8-11f0-97de-b9d5501b6f88
# ╠═704f15f0-acaf-43f9-9164-5693ddec550c
# ╟─178fa6d9-1177-4f58-98d7-f074118d674e
# ╠═f6d53a9e-f79e-4fab-9e09-6b5e39bc5eca
# ╟─8ab1c7b2-f84a-4e1b-acb6-bb5759df3f2d
# ╠═b9a22015-a36a-4287-8a6e-e746b5035429
# ╠═513aabce-8ad9-4ad3-b072-1ea95f813465
# ╠═0aeb0b4e-5897-4b01-b73c-6a95195dfe90
# ╠═8f0f5f7e-2cba-414e-9f62-e69406e371ef
# ╟─0416dc56-81cd-4fba-bd92-6b9a040c70d1
# ╠═61e64d14-6b6f-4569-aaa9-14203cec7d12
# ╠═095904ea-c4ab-4ac3-8503-b77423bb63d3
# ╟─0fd6b926-584d-4562-bb3f-c68d7b95aba8
# ╠═93305175-4233-42df-9ff4-ef9cee8faf01
# ╠═f18ed671-d333-4bb7-b6ed-39b3670f969d
# ╟─d2f663aa-e1c2-4bc4-9b96-45b11c961c9b
# ╠═27c6abc5-b49b-4557-aa5b-f313ec7c3a28
# ╠═b0855605-3ff8-47f6-8511-52ea1b0cb313
# ╠═fd8f1214-0b83-443f-9aa7-d90321e5489b
