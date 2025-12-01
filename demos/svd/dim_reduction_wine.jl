### A Pluto.jl notebook ###
# v0.20.18

using Markdown
using InteractiveUtils

# ╔═╡ e35f94a9-fd14-4617-ae89-6033d821a9c0
begin
	import Pkg; Pkg.activate()
	using CSV, DataFrames, LinearAlgebra, Statistics, CairoMakie, ColorSchemes
end

# ╔═╡ 5e1dee9b-b6d5-414d-a890-e756553bd16f
update_theme!(fontsize=16, resolution=(500, 300))

# ╔═╡ e7701be9-a8eb-4b44-9875-9e61d35a154d
md"# principal component analysis (PCA) of wines


_source_: UCI Machine Learning repository [here](https://archive.ics.uci.edu/ml/datasets/wine).

> these data are the results of a chemical analysis of wines grown in the same region in Italy but derived from three different cultivars. The analysis determined the quantities of 13 constituents found in each of the three types of wines.


!!! warning
	ignore the variety of the wine in the first column---the _labels_ of the wine. we are in the territory of unsupervised learning, where we only have attributes of the instances (wines) but no labels (variety). we will conduct PCA on the wines using their attributes only, then assess if the structure of the data set (the scatter of the wine attributes represented as vectors in the feature space) captures information about the variety of the wines.

🍷 read in the wine data as a `DataFrame`.
"

# ╔═╡ 03981f54-8d9b-4246-99e9-9f33c818266c
header = ["Variety", "Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium", "Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315 of diluted wines", "Proline"]

# ╔═╡ a94e462b-96d3-4b7f-b5e8-1e84eca5b7a5
download("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data", "wine.data")

# ╔═╡ 2e56c0eb-159f-4662-bac1-f8fe854af1cb
wine = CSV.read("wine.data", DataFrame, header=header)

# ╔═╡ dd39776a-b853-4617-ada9-16a50ff2044a
md"🍷 construct the (# wines) × (# attributes) feature matrix `X` that lists the attributes of the wines in the rows. so each row represents a wine, and each column represents an attribute of the wines. be sure not to include the `\"Variety\"`, as this is a label.

!!! hint
	`Matrix(data[:, [\"col x\", \"col y\"]])` will grab two columns from a data frame and convert it to a matrix.
"

# ╔═╡ f87ffcb2-c68a-4efa-8bc4-881e8a53aab4
md"🍷 PCA is most effective when the values of the features are standardized. loop through each column of the feature matrix `X` and standardize each feature by (i) subtracting the mean value of that feature among the instances and (ii) dividing by the standard deviation of the values of the feature among the instances. you should notice that each value of the feature tends to lie in $[-2, 2]$, but outliers can lie outside of the interval.
"

# ╔═╡ 24b78de1-d624-4e02-97c3-b4fb55234e46
md"🍷 do `PCA` via the `svd`. particularly, embed each wine, originally represented as a 13-dimensional (the # of attributes) feature vector, into a 2D space conducive for visualization. i.e. retain only the first two principal components."

# ╔═╡ 4727f313-b81a-4939-bb8d-5ffa2d9100c4
md"🍷 visualize the first two principal components of each wine. i.e. plot the 2D embeddings of the wines. color each point (representing a wine) by the variety of wine it belongs to, the labels in the first column of the wine data that we held-out from the unsupervised PCA. include a legend to indicate which color corresponds to which wine variety (1, 2, 3).
"

# ╔═╡ 043c47e5-1d82-4d4b-8740-85cffe445cad
md"🍷 what percentage of the variance among the 13-dimenionsal feature vectors were the first two principal components able to, together, capture? see the `explained_variance_ratio_` attribute of your fitted PCA model."

# ╔═╡ 89ff5664-358b-473f-8f17-0d0be550158c
md"🍷 can we capture the color of the wine?"

# ╔═╡ Cell order:
# ╠═e35f94a9-fd14-4617-ae89-6033d821a9c0
# ╠═5e1dee9b-b6d5-414d-a890-e756553bd16f
# ╟─e7701be9-a8eb-4b44-9875-9e61d35a154d
# ╠═03981f54-8d9b-4246-99e9-9f33c818266c
# ╠═a94e462b-96d3-4b7f-b5e8-1e84eca5b7a5
# ╠═2e56c0eb-159f-4662-bac1-f8fe854af1cb
# ╟─dd39776a-b853-4617-ada9-16a50ff2044a
# ╟─f87ffcb2-c68a-4efa-8bc4-881e8a53aab4
# ╟─24b78de1-d624-4e02-97c3-b4fb55234e46
# ╟─4727f313-b81a-4939-bb8d-5ffa2d9100c4
# ╟─043c47e5-1d82-4d4b-8740-85cffe445cad
# ╟─89ff5664-358b-473f-8f17-0d0be550158c
