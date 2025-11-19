### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ b066bf9a-a363-4371-8433-47011b7e64c1
begin
	import Pkg; Pkg.activate()
	using DataFrames, CSV, CairoMakie, ColorSchemes, Optim
end

# ╔═╡ 702c01c6-1160-4513-9bfc-3e4b4d4bb22b
update_theme!(
	fontsize=20, linewidth=3, markersize=16, 
	palette=(color=ColorSchemes.Accent_3,)
)

# ╔═╡ 5c3827f0-64c6-4a39-a7f2-e4917bec4fd1
pwd()

# ╔═╡ 2862c8f2-dbf2-11ee-21b1-df277ba573ab
md"# modeling heat transfer to a lime fruit

!!! note
	this assignment uses experimental data from:
	> \"A tutorial on the Bayesian statistical approach to inverse problems.\" F. Waqar, S. Patel, C. Simon. _APL Machine Learning_. 2023. [link](https://pubs.aip.org/aip/aml/article/1/4/041101/2919936/A-tutorial-on-the-Bayesian-statistical-approach-to).

## experimental setup

we allowed a lime fruit (∼5 cm diameter) to reside in a refrigerator for several days. then, at time $t=0$ (min), we removed the lime from the refrigerator, placed it on a thin slab of insulating styrofoam, and allowed it to exchange heat with the indoor air via natural convection. an electrical-resistance-based temperature sensor inserted into the lime measures the internal temperature of the lime at any given time $t$, giving a data point $(t_i, \theta_i)$. 
"

# ╔═╡ b3412774-d3e7-431b-9ff7-d1a4e3f3d0d5
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE361_W2024/main/studios/lime_setup.jpeg\" width=320>"

# ╔═╡ 3c967f38-ef8d-40f5-9447-0899dc9ab529
md"## the training data

first, we measured the [assume, constant] temperature of:
* the ambient air $\theta^{\rm air}$
* the refrigerator $\theta_0$ (same as initial lime temperature)
"

# ╔═╡ ccd9459f-045a-41b7-bfd1-592023b8cc59
θᵃⁱʳ = 18.7 # °C

# ╔═╡ 459e734a-455e-479e-84d7-23c48f3f3a47
θ₀ = 6.5 # °C

# ╔═╡ 8873aa4e-64dc-4f94-9ebd-d07c93a6195b
md"second, we measured the lime temperature at different times over the course of the heat transfer experiment, giving time series data $\{(t_i, \theta_i)\}_{i=0}^{N=12}$.

🐛 read in the data in `train_data.csv` as a `DataFrame`.
"

# ╔═╡ d762ac6d-8627-4e70-a23c-9bb74ee644ae


# ╔═╡ 739a6587-f74e-4b55-b8cf-2ef7e3210e35
md"🐛 plot the time series data as scattered points. include an x- and y-axis label. does the shape of the data make sense?

!!! hint
	this should look like Fig. 7a in Waqar et al. 
"

# ╔═╡ 06605daf-d220-4b53-b7e1-56def7d6f665


# ╔═╡ f476d4ae-5084-4e28-ba9f-8ed66975127c


# ╔═╡ a3f0e6c7-abe6-407b-b510-2eff67094481
md"## formulate a model for the lime temperature

formulate a mathematical model (a differential equation) for the lime temperature $\theta(t)$ [°C] that characterizes the heat transfer into the lime, given the ambient air temperature $\theta^{\rm air}$ and initial temperature $\theta_{0}$. the model should constitute a differential equation with a *single* unknown, lumped parameter---a time constant $\tau$ [min]. 
* invoke Newton's law of cooling
* treat the temperature of the lime as spatially uniform

!!! hint
	read Sec. IIB of Waqar et al.

## code up the model

🐛 write a function `θ(t, τ)` that returns the predicted lime temperature at time $t$ for a given time constant $\tau$.

!!! note
	the time constant τ is unknown at this point. this function will allow us to assess how well different τ's fit the time series data of the lime temperature.
"

# ╔═╡ 8b520989-ba01-42ea-9a0c-f9b94e5cd75e


# ╔═╡ 5bbf9f40-a515-4db4-bf9a-af465f1faa43
md"## a rough approach to determine $\tau$

🐛  to roughly determined $\tau$, plot a range of 7 models on top of the data for $\tau \in [0.5, 2]$ hr. use a colormap to color the models according to τ and a legend to match the color with the τ value.
"

# ╔═╡ 01fc3ad9-b947-4935-a99d-6d35a39ee002


# ╔═╡ ec24e83d-ed92-4ee2-be38-0005df4b0a27
md"## parameter identification

use the lime temperature time series data to identify the unknown time constant $\tau$ governing the dynamics of heat transfer from air into the lime via natural convection.

* 🐛 code-up a least squares loss function of τ
* 🐛 plot the loss function to see an optimum
* 🐛 use `Optim.jl` to solve for the optimum τ (see [here](https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/#minimizing-a-univariate-function-on-a-bounded-interval))
* 🐛 plot the fit model (ie. the model $θ(t, \tau_{\rm opt})$ with the optimal $\tau$, $\tau_{\rm opt}$) on top of the time series data to assess quality of fit.
"

# ╔═╡ 68c62f2a-010a-4177-b627-60c5a90851ab


# ╔═╡ a578a859-c1aa-4939-9a16-c9ff07f04bc6


# ╔═╡ 41ce3b17-170c-426f-b2e6-497ca5b6cd6d


# ╔═╡ f7f6a81c-836f-4a77-9041-879462d0921f


# ╔═╡ c8c39543-6c88-43bf-aed5-254120cb7932
md"## test the model on a new situation

🐛 assess how predictive the model is in a new situation, with a different ambient air temperature and initial temperature. see `new_test_data.csv`.
"

# ╔═╡ 41def129-1108-4206-b190-c06842b7ddc2
θ₀_new = 10.44 # °C

# ╔═╡ b1805815-a6dd-4ce6-85e8-d2ac5de33700
θᵃⁱʳ_new = 18.54 # °C

# ╔═╡ ce058ff4-45f4-4ce7-b137-0005472a386e


# ╔═╡ 1c0b2a03-c7f0-48b4-851a-9a7ff37b0942


# ╔═╡ Cell order:
# ╠═b066bf9a-a363-4371-8433-47011b7e64c1
# ╠═702c01c6-1160-4513-9bfc-3e4b4d4bb22b
# ╠═5c3827f0-64c6-4a39-a7f2-e4917bec4fd1
# ╟─2862c8f2-dbf2-11ee-21b1-df277ba573ab
# ╟─b3412774-d3e7-431b-9ff7-d1a4e3f3d0d5
# ╟─3c967f38-ef8d-40f5-9447-0899dc9ab529
# ╠═ccd9459f-045a-41b7-bfd1-592023b8cc59
# ╠═459e734a-455e-479e-84d7-23c48f3f3a47
# ╟─8873aa4e-64dc-4f94-9ebd-d07c93a6195b
# ╠═d762ac6d-8627-4e70-a23c-9bb74ee644ae
# ╟─739a6587-f74e-4b55-b8cf-2ef7e3210e35
# ╠═06605daf-d220-4b53-b7e1-56def7d6f665
# ╠═f476d4ae-5084-4e28-ba9f-8ed66975127c
# ╟─a3f0e6c7-abe6-407b-b510-2eff67094481
# ╠═8b520989-ba01-42ea-9a0c-f9b94e5cd75e
# ╟─5bbf9f40-a515-4db4-bf9a-af465f1faa43
# ╠═01fc3ad9-b947-4935-a99d-6d35a39ee002
# ╟─ec24e83d-ed92-4ee2-be38-0005df4b0a27
# ╠═68c62f2a-010a-4177-b627-60c5a90851ab
# ╠═a578a859-c1aa-4939-9a16-c9ff07f04bc6
# ╠═41ce3b17-170c-426f-b2e6-497ca5b6cd6d
# ╠═f7f6a81c-836f-4a77-9041-879462d0921f
# ╟─c8c39543-6c88-43bf-aed5-254120cb7932
# ╠═41def129-1108-4206-b190-c06842b7ddc2
# ╠═b1805815-a6dd-4ce6-85e8-d2ac5de33700
# ╠═ce058ff4-45f4-4ce7-b137-0005472a386e
# ╠═1c0b2a03-c7f0-48b4-851a-9a7ff37b0942
