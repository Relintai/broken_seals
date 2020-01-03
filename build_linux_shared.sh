
export SCONS_CACHE=~/.scons_cache
export SCONS_CACHE_LIMIT=5000

cd engine
scons -j2 platform=x11 target=release_debug custom_modules_shared=yes

# use_llvm=yes


