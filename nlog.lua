-- Written by Pedro Martelletto in November 2009. Public domain.
-- This script approximates a set of values in the form of a
-- curve t(n)=10^x*n^k*log(n)/log(y).

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
			local w = math.log(n[i])/math.log(n[i-1])
			d = d + (t[i]/f(n[i], k+0.001))/
			    (t[i-1]/f(n[i-1], k+0.001))/w
		end
		d = math.abs(1-d/(#n-1))
	until e and e <= d

	return k
end

function approximateR(n,t) -- residue
	local r = 0
	for i=2,#n do
		r = r + (t[i] - t[i-1])/
		    (g(n[i],k) - g(n[i-1], k))
	end
	return r/(#n-1)
end

function approximateX(r)
	local x = math.floor(math.log(r, 10))
	return x
end

function approximateY(r,x)
	local y = math.exp(1/(r * 10^-x))
	return y
end

function f(n,k)
	return n^k
end

function g(n,k)
	return f(n,k)*math.log(n)
end

if #arg ~= 1 or arg[1] == nil then
	io.stderr:write("usage: approx <file>\n")
	os.exit(1)
end

n,t = loadResults(arg[1])
k = approximateK(n,t)
r = approximateR(n,t)
x = approximateX(r)
y = approximateY(r,x)
u = {}
for i=1,#n do
	u[i] = 10^x*n[i]^k*math.log(n[i],y)
end
a,s = stddev(t,u)
print(string.format("t(n)=10^%s*n^%s*log(n)/log(%s)",x,k,y))
print(string.format("with precision avg=%.3f%%, stddev=%.3f%%", a*100,s*100))
