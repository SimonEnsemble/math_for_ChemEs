### A Pluto.jl notebook ###
# v0.20.19

using Markdown
using InteractiveUtils

# ╔═╡ ca58b618-a887-11f0-2102-4de0fd403b51
using LinearAlgebra

# ╔═╡ b4c4a21f-8b07-497f-9c59-021853696759
md"# the $P A=LU$ factorization"

# ╔═╡ 14a925c5-4eaf-4b0a-97e3-eb84a9a3cef1
@doc lu

# ╔═╡ 3d782c16-5dd0-4048-8865-0bfe6ddb1800
md"🍕 define the matrix $A$."

# ╔═╡ 2b3314cc-5435-436a-8ee6-b4ecf006dec8
A = [
	5 3 1;
	1 1 1;
	3 3 1
]

# ╔═╡ 9ce538dc-1239-4c4b-8c0d-30fc663d6cab
md"🍕 factorize as $PA = L U$."

# ╔═╡ 57b086c0-64e9-48b0-b4f7-a1cae6e5a2b2
f = lu(A) # "f" for "factorization"

# ╔═╡ 8607a8e4-7b8d-4134-aa23-4a12ef67f288
md"...unpack (not necessary, but clear)."

# ╔═╡ 50d4cc54-d4ba-4c3d-b9c9-e3df24c6fd2b
L = f.L # lower-triangular

# ╔═╡ f76a6647-c513-4533-9745-697007ec6ec7
U = f.U # upper-triangular

# ╔═╡ 429ef08d-ca51-4cb9-bec9-b218c532131f
P = f.P # permutation matrix

# ╔═╡ 043759f3-8876-4c95-acd3-eef7ef58c971
md"🍕 check that $PA=LU$."

# ╔═╡ ef1abdd7-eb4a-4543-b984-748f7152f131
P * A # just A with permuted rows

# ╔═╡ eab7dfa4-4ffa-49b2-b873-37a04b797515
L * U # should = PA

# ╔═╡ 1ea30374-c52d-4312-8718-dde50767e8e3
P * A ≈ L * U # formal check

# ╔═╡ 4f0b8595-65ac-44b6-9a58-b408507803aa
md"🍕 solve $A\mathbf{x}=\mathbf{b}$.

here's a $\mathbf{b}$ vector."

# ╔═╡ 1329b320-2a1b-4028-aabb-db2bd7964d8d
b = [6, 2, 4] # first column of A plus third column of A

# ╔═╡ 4d8b49be-d464-4f48-a692-03cf156a778c
md"... first, using Julia's built-in solver."

# ╔═╡ cec9450c-c8b2-4ada-a654-365d025ba415
A \ b

# ╔═╡ 66f7caf1-7ad2-46fd-a12a-ed82f2d9657e
md"...second, using the $P A = LU$ factorization.


$A\mathbf{x}=\mathbf{b}$ implies 

$PA\mathbf{x}=P\mathbf{b}$

or

$LU\mathbf{x}=P\mathbf{b}$

*step 1* solve $L\mathbf{c}=P\mathbf{b}$ for $\mathbf{c}$. (a lower-triangular system; fast.)

*step 2* solve $U\mathbf{x}=P\mathbf{c}$ for $\mathbf{x}$. (an upper-triangular system; fast.)

"

# ╔═╡ c103c21e-2198-427d-b4b8-c359409c3d67
c = L \ (P * b)

# ╔═╡ b9596c10-bfbd-4e76-86a9-0582d8891822
x = U \ c

# ╔═╡ 3ed29b37-b1cf-49e9-a657-88d8a4461525
md"🥳 same answer as `A \ b`!"

# ╔═╡ 7aabded6-1caf-48c6-9f96-9e5956bbc854
md"## almost never compute the inverse of a matrix for solving $A \mathbf{x} = \mathbf{b}$!"

# ╔═╡ 7af1dcbb-806a-4052-a88e-5f4bc656f37c
A_big = rand(1000, 1000)

# ╔═╡ f09f7b46-20e2-46de-9821-896338f45868
b_big = rand(1000)

# ╔═╡ 5738cbb9-fa20-4ae1-9bbe-de08b0abdaa7
@time A_big \ b_big

# ╔═╡ f4120062-ce7d-4d0a-b2cb-68f389eb00c5
@time inv(A_big) * b_big

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╟─b4c4a21f-8b07-497f-9c59-021853696759
# ╠═ca58b618-a887-11f0-2102-4de0fd403b51
# ╠═14a925c5-4eaf-4b0a-97e3-eb84a9a3cef1
# ╟─3d782c16-5dd0-4048-8865-0bfe6ddb1800
# ╠═2b3314cc-5435-436a-8ee6-b4ecf006dec8
# ╟─9ce538dc-1239-4c4b-8c0d-30fc663d6cab
# ╠═57b086c0-64e9-48b0-b4f7-a1cae6e5a2b2
# ╟─8607a8e4-7b8d-4134-aa23-4a12ef67f288
# ╠═50d4cc54-d4ba-4c3d-b9c9-e3df24c6fd2b
# ╠═f76a6647-c513-4533-9745-697007ec6ec7
# ╠═429ef08d-ca51-4cb9-bec9-b218c532131f
# ╟─043759f3-8876-4c95-acd3-eef7ef58c971
# ╠═ef1abdd7-eb4a-4543-b984-748f7152f131
# ╠═eab7dfa4-4ffa-49b2-b873-37a04b797515
# ╠═1ea30374-c52d-4312-8718-dde50767e8e3
# ╟─4f0b8595-65ac-44b6-9a58-b408507803aa
# ╠═1329b320-2a1b-4028-aabb-db2bd7964d8d
# ╟─4d8b49be-d464-4f48-a692-03cf156a778c
# ╠═cec9450c-c8b2-4ada-a654-365d025ba415
# ╟─66f7caf1-7ad2-46fd-a12a-ed82f2d9657e
# ╠═c103c21e-2198-427d-b4b8-c359409c3d67
# ╠═b9596c10-bfbd-4e76-86a9-0582d8891822
# ╟─3ed29b37-b1cf-49e9-a657-88d8a4461525
# ╟─7aabded6-1caf-48c6-9f96-9e5956bbc854
# ╠═7af1dcbb-806a-4052-a88e-5f4bc656f37c
# ╠═f09f7b46-20e2-46de-9821-896338f45868
# ╠═5738cbb9-fa20-4ae1-9bbe-de08b0abdaa7
# ╠═f4120062-ce7d-4d0a-b2cb-68f389eb00c5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
