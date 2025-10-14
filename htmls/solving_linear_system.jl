### A Pluto.jl notebook ###
# v0.20.17

using Markdown
using InteractiveUtils

# ╔═╡ 968e8d82-9810-11f0-0051-e1b995ba6aa3
begin
	import Pkg
	Pkg.activate()
	using UnicodePlots
end

# ╔═╡ d47139d2-c84e-4979-9d18-15fb50f5a812
md"# numerically solving a system of linear equations

the linear system of equations is represented in matrix-vector form:
```math
\mathbb{A} \mathbf{x} = \mathbf{b}
```
where $\mathbb{A}$ is the [known] coefficient matrix, $\mathbf{b}$ is a known vector, and $\mathbf{x}$ is the unknown vector.

suppose there are $n$ unknown variables and $e$ equations. then, $\mathbb{A}$ is an $e \times n$ matrix, $\mathbf{x}\in\mathbb{R}^n$, and $\mathbf{b} \in \mathbb{R}^e$.


!!! note
	see Julia's linear algebra docs [here](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/).

🍓 define the variable names for interpretation.
"

# ╔═╡ f8512cc4-74bb-4973-8d31-798115a19a3b
var_names = [
	"strawberries in [kg]", "sugar in [kg]", "water out [kg]", "jam out [kg]"
]

# ╔═╡ aeb0e003-c573-4cfd-9869-e3c1389e1a58
md"🍓 define the coefficient matrix $\mathbb{A}$."

# ╔═╡ bcb75038-a2bc-453c-817c-582496c8809f
A = [
	1     1    -1   -1;
  0.85    0    -1  -0.3; 
	1   -0.8   0    0; 
	0     0    0    1
]

# ╔═╡ 48606781-ad16-4da8-8270-7bda41af607c
md"🍓 define the vector $\mathbf{b}$."

# ╔═╡ f91d1840-abd6-4967-9f3b-abdc4bca86ee
b = [0, 0, 0, 1]

# ╔═╡ 5da2a489-78ed-4096-b696-aed6321e9609
md"🍓 solve the linear system of eqns for the unknown vector $\mathbf{x}$."

# ╔═╡ 7abf201d-797c-4a30-98e5-c0c8386333a8
x = A \ b

# ╔═╡ fb062879-08d7-41fb-b457-5b17974034aa
md"🍓 check that (i) $\mathbb{A}\mathbf{x}=\mathbf{b}$ is satisfied and (ii) the strawberry to sugar ratio is indeed satisfied."

# ╔═╡ 2e8a161f-0f1b-4f2c-92a7-032a6d406455
A * x ≈ b

# ╔═╡ 4a4bc574-1f0a-4d51-b3df-8c1197ef0de6
x[1] / x[2] ≈ 0.8

# ╔═╡ cc2a6e7e-56cb-40cf-8d6a-88f16359a891
md"🍓 how much [kg] strawberries and sugar are needed to make the 1 kg of jam?"

# ╔═╡ 8c6c167b-4401-4b6f-ae91-bda06dd96a3d
print("strawberries needed [kg]: ", x[1])

# ╔═╡ 0924bf47-d594-4b78-82e7-5b99adffac1d
print("sugar needed [kg]: ", x[2])

# ╔═╡ 50ec622b-f418-4e42-aec0-8f966ed0feeb
md"🍓 how much water vapor exits the oven?"

# ╔═╡ 7c6e0629-1075-4502-b343-7f76ff658787
print("water exiting [kg]: ", x[3])

# ╔═╡ dd40f04d-6ae4-4f99-81a1-074626eae0d3
md"🍓 make a nice bar plot of the unknowns using the lightweight UnicodePlots.jl package."

# ╔═╡ f9634046-76e2-430e-b092-40bbb29f9f42
barplot(
	var_names, 
	x, 
	title="Population"
)

# ╔═╡ Cell order:
# ╠═968e8d82-9810-11f0-0051-e1b995ba6aa3
# ╟─d47139d2-c84e-4979-9d18-15fb50f5a812
# ╠═f8512cc4-74bb-4973-8d31-798115a19a3b
# ╟─aeb0e003-c573-4cfd-9869-e3c1389e1a58
# ╠═bcb75038-a2bc-453c-817c-582496c8809f
# ╟─48606781-ad16-4da8-8270-7bda41af607c
# ╠═f91d1840-abd6-4967-9f3b-abdc4bca86ee
# ╟─5da2a489-78ed-4096-b696-aed6321e9609
# ╠═7abf201d-797c-4a30-98e5-c0c8386333a8
# ╟─fb062879-08d7-41fb-b457-5b17974034aa
# ╠═2e8a161f-0f1b-4f2c-92a7-032a6d406455
# ╠═4a4bc574-1f0a-4d51-b3df-8c1197ef0de6
# ╟─cc2a6e7e-56cb-40cf-8d6a-88f16359a891
# ╠═8c6c167b-4401-4b6f-ae91-bda06dd96a3d
# ╠═0924bf47-d594-4b78-82e7-5b99adffac1d
# ╟─50ec622b-f418-4e42-aec0-8f966ed0feeb
# ╠═7c6e0629-1075-4502-b343-7f76ff658787
# ╟─dd40f04d-6ae4-4f99-81a1-074626eae0d3
# ╠═f9634046-76e2-430e-b092-40bbb29f9f42
