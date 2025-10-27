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
	update_theme!(fontsize=16, markersize=14, linewidth=3)
end

# ╔═╡ 962923b7-afe2-43c0-8aec-41ec2a7d1eb8
md"# modeling the volume of a water-ethanol solution

> Every bartender knows well that mixing 50 mL of water with 50 mL of ethanol does not give an alcohol drink of 100 mL.

we wish to model the density $\rho$ [g/mL] of an ethanol-water mixture as a function of the weight fraction ethanol, $x\in [0, 1]$, at 22°C. specifically, our objective is to use Bernstein basis polynomials to fit a nonlinear curve to experimental data to obtain a model $\rho(x)$. 

📖 see [Wikipedia](https://en.wikipedia.org/wiki/Bernstein_polynomial) for the Bernstein basis polynomials $b_{\nu, n}(x)$---quite natural for approximating smooth functions on the domain $x\in[0, 1]$. in this assignment, we'll fix $n$ to restrict the smoothness of the resulting model and use the $n+1$ basis functions $b_{0, n}(x),...,b_{n, n}(x)$.

specifically, our model is a linear combination of the Bernstein basis polynomials:
```math
\rho(x)=\sum_{\nu=0}^n a_\nu b_{\nu, n}(x),
```
where the $a_\nu$'s are the $n+1$ coefficients you need to determine using least-squares fitting.

💡 though the model is nonlinear in $x$, it is linear in terms of the coefficients on the basis functions, $a_1, ..., a_n$. this allows us to use the normal equation $A^\intercal A \mathbf{a}= A^\intercal \mathbf{b}$ to fit the coefficients to the data.

📖 source for data:
> T. Grubbs. \"Bartender's Conundrum - Partial Molar Volume in Water-Ethanol Mixtures\" _LibreTexts Chemistry_. [link](https://chem.libretexts.org/Bookshelves/Physical_and_Theoretical_Chemistry_Textbook_Maps/Exercises%3A_Physical_and_Theoretical_Chemistry/Data-Driven_Exercises/Bartender's_Conundrum_-_Partial_Molar_Volume_in_Water-Ethanol_Mixtures)
"

# ╔═╡ 3b731dec-6149-4221-a595-5729fc2558dd
md"🍸 construct a data frame `data` using the data [here](https://chem.libretexts.org/Bookshelves/Physical_and_Theoretical_Chemistry_Textbook_Maps/Exercises%3A_Physical_and_Theoretical_Chemistry/Data-Driven_Exercises/Bartender's_Conundrum_-_Partial_Molar_Volume_in_Water-Ethanol_Mixtures). it should have two columns, one for the EtOh weight fraction, another for the density of the mixture at 22°C."

# ╔═╡ ad722d4e-af08-4779-ae21-b0032e054ca1


# ╔═╡ 25164bc9-b0d9-4529-b1f0-1e1586cd74eb
md"🍸 plot the density against the ethanol weight fraction. note a nonlinear model in $x$ is needed to properly describe the shape of the data."

# ╔═╡ 64199a28-5a17-4048-9e09-cf46ede328b5


# ╔═╡ bbfce017-ef64-48f1-ab8b-dc9898555e0e
md"🍸 set $n=4$. write a function `bernstein_poly(x, ν)` that returns the value of the Bernstein polynomial $b_{\nu, 4}(x)$. plot all five $n=4$ Bernstein basis polynomails on the same plot, with different colors, to check your implementation. include x- and y-axis labels and legend to indicate which ν each colored curve corresponds to. (please use a `for` loop.)
"

# ╔═╡ 651b31d6-c9e0-411a-adc6-3c9283c4a7f1
n = 4

# ╔═╡ 33054297-f0b5-4004-a05b-ea6c0a415af7


# ╔═╡ 16938f56-0d04-4d70-825f-ab382ca604c6


# ╔═╡ d1f6f01b-85bd-4c3f-9799-d4c44abb9150
md"🍸 to fit the five coefficients $a_0, ..., a_5$ to the data, set up a linear system $A\mathbf{a}=\mathbf{b}$. i.e., construct the corresponding matrix $A$ and right-hand side vector $\mathbf{b}$, using the data frame `data` and your function `bernstein_poly(x, ν)`. (use a `for` loop or list comprehension to avoid copying-and-pasting the same line of code five times.)"

# ╔═╡ e26edb31-7cab-4459-be02-816c7eab4fb1


# ╔═╡ 43923aa8-239a-4c97-b0fc-af795a0d000f


# ╔═╡ 5fa84fd3-e1c8-4868-a7b6-3d40b54efeca
md"🍸 find the least-squares solution to $A\mathbf{a}=\mathbf{b}$ via solving the normal equation $A^\intercal A\mathbf{a}=A^\intercal\mathbf{b}$."

# ╔═╡ bace3c15-7fbb-434e-884a-a915a7d5be4f


# ╔═╡ 03e23ac9-39a0-4177-b4a6-50ff978939cc
md"🍸 assess the fit of your model by plotting $\rho(x)$ constructed via the Bernstein basis polynomials on top of the raw data." 

# ╔═╡ 68c72c49-2160-4481-9308-ef287059c82f


# ╔═╡ 99782090-1862-467a-a29a-e0270533011d


# ╔═╡ Cell order:
# ╠═e4c2d62a-b352-11f0-8be7-6d27d600dab1
# ╠═4e6a9120-3cf9-4c70-9b3e-16d3477a1a22
# ╟─962923b7-afe2-43c0-8aec-41ec2a7d1eb8
# ╟─3b731dec-6149-4221-a595-5729fc2558dd
# ╠═ad722d4e-af08-4779-ae21-b0032e054ca1
# ╟─25164bc9-b0d9-4529-b1f0-1e1586cd74eb
# ╠═64199a28-5a17-4048-9e09-cf46ede328b5
# ╟─bbfce017-ef64-48f1-ab8b-dc9898555e0e
# ╠═651b31d6-c9e0-411a-adc6-3c9283c4a7f1
# ╠═33054297-f0b5-4004-a05b-ea6c0a415af7
# ╠═16938f56-0d04-4d70-825f-ab382ca604c6
# ╟─d1f6f01b-85bd-4c3f-9799-d4c44abb9150
# ╠═e26edb31-7cab-4459-be02-816c7eab4fb1
# ╠═43923aa8-239a-4c97-b0fc-af795a0d000f
# ╟─5fa84fd3-e1c8-4868-a7b6-3d40b54efeca
# ╠═bace3c15-7fbb-434e-884a-a915a7d5be4f
# ╟─03e23ac9-39a0-4177-b4a6-50ff978939cc
# ╠═68c72c49-2160-4481-9308-ef287059c82f
# ╠═99782090-1862-467a-a29a-e0270533011d
