@primitive  sum(x),dy        (dy.+zeros(x))
@primitive  sum(x,i...),dy   (dy.+zeros(x))
@primitive  sum(x::Tuple),dy  ntuple(i->dy,length(x))
addtest(sum, rand(2))
addtest(sum, (rand(2)...))
addtest(sum, rand(2,2), 1)
addtest(sum, rand(2,2), 2)

# TODO: implement more general sum ops
# TODO: other functions in reduce.jl:
# r_promote: Not exported
# mapfoldl_impl: Not exported
# mapfoldl
# foldl
# mapfoldr_impl: Not exported
# mapfoldr
# foldr
# mapreduce_seq_impl: Not exported
# mapreduce_pairwise_impl: Not exported
# mapreduce
# mapreduce_impl: Not exported
# mr_empty: Not exported
# _mapreduce: Not exported
# reduce
# shortcircuits: Not exported
# shorted: Not exported
# sc_finish: Not exported
# mapreduce_sc_impl: Not exported
# mapreduce_no_sc: Not exported
# mapreduce_sc: Not exported
# sum_pairwise_blocksize: Not exported
# sum
# sumabs
# sumabs2
# sum_kbn
# prod
# maximum
# minimum
# maxabs
# minabs
# extrema
# any
# all
# in
# ∉
# ∋
# ∌
# contains
# count
# call
# countnz
