-- Written by Pedro Martelletto in November 2009. Public domain.
-- This script approximates a set of values in the form of a
-- curve t(n)=x*n^k.

stddev = require("stddev")

function loadResults(path)
	local f, err = io.open(path, "r")
	if f == nil or err ~= nil then
		io.stderr:write(err.."\n")
		os.exit(1)
	end

	local n, t = {}, {}
	for l in f:lines() do
		local x, y = l:match("(.+)%s+(.+)")
		x, y = tonumber(x), tonumber(y)
		if not x or not y then
			io.stderr:write(string.format(
			    "couldn't parse line %d: %q\n",
			    #n+1, l))
			os.exit(1)
		end
		n[#n+1],t[#t+1] = x,y
	end

	if #n < 3 then
		io.stderr:write("not enough data to " ..
		    "approximate; sorry!")
		os.exit(1)
	end

	return n,t
end

function approximateK(n,t)
	local d, e, k
	k = 0

	repeat
		e, d = d, 0
		k = k + 0.001
		for i=2,#n do
			d = d + (t[i]/f(n[i], k+0.001))/
			    (t[i-1]/f(n[i-1], k+0.001))
		end
		d = math.abs(1-d/(#n-1))
	until e and e <= d

	return k
end

function approximateX(n,t,k)
	local x = 0
	for i=2,#n do
		x = x + (t[i] - t[i-1])/
		    (f(n[i],k) - f(n[i-1], k))
	end
	return x/(#n-1)
end

function f(n,k)
	return n^k
end

if #arg ~= 1 or arg[1] == nil then
	io.stderr:write("usage: lua n.lua <file>\n")
	os.exit(1)
end

n,t = loadResults(arg[1])
k = approximateK(n,t)
x = approximateX(n,t,k)
u = {}
for i=1,#n do
	u[i] = x*n[i]^k
end
a,s = stddev(t,u)
print(string.format("t(n)=%sn^%s",x,k))
print(string.format("with precision avg=%.3f%%, stddev=%.3f%%", a*100,s*100))
