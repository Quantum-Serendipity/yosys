set -e
rm -f plugin.so
rm -rf plugin_search
CXXFLAGS=$(bash ${YOSYS_CONFIG} --cxxflags)
DATDIR=$(bash ${YOSYS_CONFIG} --datdir)
DATDIR=${DATDIR//\//\\\/}
CXXFLAGS=${CXXFLAGS//$DATDIR/$BUILD_DIR/share}
bash ${YOSYS_CONFIG} --exec --cxx ${CXXFLAGS} --ldflags -shared -o plugin.so plugin.cc
${YOSYS} -m ./plugin.so -p "test" | grep -q "Plugin test passed!"
mkdir -p plugin_search
mv plugin.so plugin_search/plugin.so
YOSYS_PLUGIN_PATH=$PWD/plugin_search ${YOSYS} -m plugin.so -p "test" | grep -q "Plugin test passed!"
