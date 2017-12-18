-- Written by Pedro Martelletto in November 2009. Public domain.

function avg(x)
	local a = 0
	for i=1,#x do
		a = a + x[i]
	end
	return a/#x
end

function stddev(x,y)
	local e = {}
	for i=1,#x do
		e[#e+1] = math.min(x[i],y[i])/math.max(x[i],y[i])
	end
	local a = avg(e)
	local v = 0
	for i=1,#e do
		v = v + (e[i]-a)^2
	end
	return a,math.sqrt(v)
end

return stddev
