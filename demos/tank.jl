### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 1e7f21be-c02a-11f0-a128-a16feebd85d7
begin
	import Pkg; Pkg.activate()
	using LinearAlgebra, CairoMakie, Statistics, OrdinaryDiffEq, DataFrames
end

# ╔═╡ 8ba2b9af-4d2d-4a57-8b96-74cddb8a6f32
update_theme!(fontsize=20, linewidth=3)

# ╔═╡ e1e11355-0a48-43f6-bf22-b55ffd91c3e5
md"# liquid level dynamics in a draining tank

first, we specify the geometry of our tank, whose cross section is a square of length $L(h)$.
"

# ╔═╡ b2a9505e-bfeb-4dfe-8444-76fe23fc36fa
begin
	# height
	H = 14.0 # cm
	
	# dimension of top square
	L_t = 34.8 / 4 # cm
	
	# dimension of bottom square
	L_b = 33.5 / 4 # cm

	# horizontal cross-sectional area profile
	function a(h)
		# fraction full
		θ = h / H
		# dimension of square at this height
		L = (θ * L_t + (1 - θ) * L_b)
		return L ^ 2
	end
end

# ╔═╡ b7286549-3e73-466e-8260-65df1345557b
# acceleration due to gravity
g = 9.8 * 100 # cm / s²

# ╔═╡ c27b6aec-13d0-4efd-9073-7c6f75ccf4af
md"radius of the hole in the tank's side"

# ╔═╡ f8f22c93-2287-40e7-a510-b1a956c856d3
rₒ = 3 / 32 * 2.54 / 2 # cm

# ╔═╡ b119fc78-2de8-429c-810b-d4fe8b907b73
md"discharge coefficient"

# ╔═╡ 3e6a01be-fc70-44b2-be43-c8b6875bb808
c = 0.42

# ╔═╡ 62361da5-5cd1-4a3f-bf52-003b7c1fea7d
md"numerically solve the ODE."

# ╔═╡ 77805a15-1035-41e3-98d5-1faaaa562371
begin
	h₀ = 14.0                      # cm
	time_span = (0.0, 60.0 * 6.5)  # s
	
	function f(h, p, t)
		if h ≤ 0.0
			return 0.0
		else
			return - c * π * rₒ ^ 2 * sqrt(2 * g * h) / a(h)
		end
	end
	
	prob = ODEProblem(f, h₀, time_span)
	h_of_t = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
end

# ╔═╡ 316f3176-8a1d-4cfa-89d1-e266d11d0001
md"drainage data collected during classtime"

# ╔═╡ 32d155ce-e87f-42f7-9dd4-9bdf8fc21f4f
begin
	local Δts = [
		24.43, 24.73, 25.67, 28.23, 28.35, 31.95, 34.45, 35.73, 41.25, 43.87, 52.62, 67.59
	]
	local hs = [14 - i for i = 0:length(Δts)-1]
	data = DataFrame(
		"time [s]" => vcat([0], [sum(Δts[1:n]) for n = 1:length(Δts)-1]),
		"h [cm]" => hs
	)
end

# ╔═╡ 6b883537-bf43-4b9a-9033-a681e1eba144
begin
	fig = Figure()
	ax = Axis(fig[1, 1], xlabel="time [s]",  ylabel="h [cm]")
	ts = range(0.0, time_span[2], length=250)
	lines!(
		ts, h_of_t.(ts), label="model"
	)
	scatter!(
		data[:, "time [s]"], data[:, "h [cm]"], label="data", color=Cycled(2), markersize=16
	)
	axislegend()
	fig
end

# ╔═╡ 4c8c2b7f-829c-4ee9-aa0c-f334e8eb7931
md"# circulation between two tanks"

# ╔═╡ 5c7fb56c-c142-4abc-846a-fb97a711a451
u(t) = [0.75; 0.75] + [-0.75; 0.75] * exp(-0.04 * t)

# ╔═╡ ba072116-128a-42f7-b532-8817daada1f1
begin
	local ts = range(0.0, 100.0, length=100)
	us = [u(tᵢ) for tᵢ in ts]
	
	local fig = Figure()
	local ax = Axis(fig[1, 1], xlabel="time [min]", ylabel="uᵢ(t) [lb/gal]")
	lines!(ts, [u[1] for u in us], label="tank 1")
	lines!(ts, [u[2] for u in us], label="tank 2")
	hlines!(0.75, linewidth=1, color="gray", linestyle=:dash)
	axislegend()
	fig
end

# ╔═╡ Cell order:
# ╠═1e7f21be-c02a-11f0-a128-a16feebd85d7
# ╠═8ba2b9af-4d2d-4a57-8b96-74cddb8a6f32
# ╟─e1e11355-0a48-43f6-bf22-b55ffd91c3e5
# ╠═b2a9505e-bfeb-4dfe-8444-76fe23fc36fa
# ╠═b7286549-3e73-466e-8260-65df1345557b
# ╟─c27b6aec-13d0-4efd-9073-7c6f75ccf4af
# ╠═f8f22c93-2287-40e7-a510-b1a956c856d3
# ╟─b119fc78-2de8-429c-810b-d4fe8b907b73
# ╠═3e6a01be-fc70-44b2-be43-c8b6875bb808
# ╟─62361da5-5cd1-4a3f-bf52-003b7c1fea7d
# ╠═77805a15-1035-41e3-98d5-1faaaa562371
# ╟─316f3176-8a1d-4cfa-89d1-e266d11d0001
# ╠═32d155ce-e87f-42f7-9dd4-9bdf8fc21f4f
# ╠═6b883537-bf43-4b9a-9033-a681e1eba144
# ╟─4c8c2b7f-829c-4ee9-aa0c-f334e8eb7931
# ╠═5c7fb56c-c142-4abc-846a-fb97a711a451
# ╠═ba072116-128a-42f7-b532-8817daada1f1
