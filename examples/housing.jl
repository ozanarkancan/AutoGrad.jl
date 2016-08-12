using Knet
using AutoGrad

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data"
file=Pkg.dir("Knet/data/housing.data")
if !isfile(file)
    info("Downloading $url to $file")
    download(url, file)
end
data = readdlm(file)'
@show size(data)
x = data[1:13,:]
y = data[14,:]
x = (x .- mean(x,2)) ./ std(x,2) # Data normalization
srand(42)                        # replicatibility
r = randperm(size(x,2))          # trn/tst split
xtrn=x[:,r[1:400]]
ytrn=y[:,r[1:400]]
xtst=x[:,r[401:end]]
ytst=y[:,r[401:end]]

housing(w, x, y)=qloss(y, w[1]*x + w[2]) # TODO: implement .+, quadloss

function qloss(ygold::Array, ypred::Array)
    @show map(size, (ygold, ypred))
    loss = 0.0
    for i=1:length(ypred)
        loss += (ypred[i]-ygold[i]).^2
    end
    return loss / (2*size(ypred,2))
end

qloss(::D1, loss, ygold, ypred)=(g->g*(ygold-ypred))
qloss(::D2, loss, ygold, ypred)=(g->g*(ypred-ygold))

@primitive qloss

w = (0.1*randn(1,13), 0)
lr = .001
grad_housing = grad(housing)
println((0, housing(w,xtrn,ytrn), housing(w,xtst,ytst)))

for epoch=1:20
    g = grad_housing(w, xtrn, ytrn)
    for i in 1:length(w)
        w[i] -= lr * g[i]
    end
    println((epoch, housing(w,xtrn,ytrn), housing(w,xtst,ytst)))
end



# @knet function housing(x)       # knet functions
#     w = par(dims=(1,13), init=Gaussian(0,.1))      # TODO: 0 size unspecified
#     b = par(dims=(1,),   init=Constant(0))        # TODO: do we need init? yes.
#     return w * x .+ b           # TODO: maybe cover dot/add first?
# end                             # TODO: keyword args

# net = compile(:housing)         # TODO: knet functions as new op
# #setp(net; adagrad=true)              # TODO: setting properties, lr
# #setp(net; momentum=.01)
# #setp(net; lr=.0001)
# setp(net; lr=.001)

# function test(f, x, y, loss)
#     ypred = forw(f,x)           # forw
#     return loss(ypred, y)       # loss fns, 2 and 3 arg (3 arg not needed by user)
# end

# function train(f, x, y, loss)
#     for i=1:size(x,2)
#         forw(net, x[:,i])       # TODO: minibatching
#         back(net, y[:,i], loss) # back
#         update!(net)            # update
#     end
# end

# for epoch=1:20
#     train(net, xtrn, ytrn, quadloss)
#     trnloss = test(net, xtrn, ytrn, quadloss)
#     tstloss = test(net, xtst, ytst, quadloss)
#     println((epoch, trnloss, tstloss))
# end

# # (1000,10.42231344167744,13.540365138552836) lr=.0005
# # (1000,10.406989532354851,13.519196251929689) lr=.0001
# # (1000,10.434297477316601,13.54778461998077) lr=.00005
