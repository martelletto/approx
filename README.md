# approx: approximate O(n) and O(nlogn) curves

This repository contains a pair of Lua scripts to approximate curves
in the form t(n)=x*n^k and t(n)=10^x*n^k*log(n), which can be handy
when using performance metrics to gauge the complexity of a procedure.

## Examples

```
$ lua -e "function f(n) return 3.57*n^1.93 end for i=1,100 do print(i,f(i)) end" > /tmp/x
$ lua nlog.lua /tmp/x
t(n)=10^1*n^1.196*log(n)/log(1.6225644721121)
with precision avg=73.672%, stddev=213.080%
$ lua n.lua /tmp/x
t(n)=3.5700000000015n^1.9299999999999
with precision avg=100.000%, stddev=0.000%
```

```
$ lua -e "function f(n) return 10^-3*n^1.23*math.log(n,1.44) end for i=100,1000 do print(i,f(i)) end" > /tmp/x
t(n)=0.0056364978850545n^1.406
with precision avg=99.097%, stddev=16.923%
$ lua nlog.lua /tmp/x
t(n)=10^-3*n^1.23*log(n)/log(1.4399999999999)
with precision avg=100.000%, stddev=0.000%
```

## License

This repository is in the public domain.
