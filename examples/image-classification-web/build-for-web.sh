# Add wasm32 target for compiler.
rustup target add wasm32-unknown-unknown

if ! command -v wasm-pack &>/dev/null; then
    echo "wasm-pack could not be found. Installing ..."
    cargo install wasm-pack
    exit
fi

mkdir -p pkg

echo "Building SIMD version of wasm for web ..."
export RUSTFLAGS="-C lto=fat -C embed-bitcode=yes -C codegen-units=1 -C opt-level=3 -Ctarget-feature=+simd128 --cfg web_sys_unstable_apis"
wasm-pack build --dev --out-dir pkg/simd --target web --no-typescript

echo "Building Non-SIMD version of wasm for web ..."
export RUSTFLAGS="-C lto=fat -C embed-bitcode=yes -C codegen-units=1 -C opt-level=3 --cfg web_sys_unstable_apis"
wasm-pack build --dev --out-dir pkg/no_simd --target web --no-typescript
