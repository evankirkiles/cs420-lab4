#=========================================================================
# pv2speco Subpackage
#=========================================================================

pv2speco_deps = \
  vc \
  imuldiv \
  pcache \

pv2speco_srcs = \
  pv2speco-CoreDpath.v \
  pv2speco-CoreDpathRegfile.v \
  pv2speco-CoreDpathAlu.v \
  pv2speco-CoreScoreboard.v \
  pv2speco-CoreReorderBuffer.v \
  pv2speco-CoreCtrl.v \
  pv2speco-Core.v \
  pv2speco-InstMsg.v \

pv2speco_test_srcs = \
  pv2speco-InstMsg.t.v \

pv2speco_prog_srcs = \
  pv2speco-sim.v \
  pv2speco-randdelay-sim.v \

