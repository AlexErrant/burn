use burn::{
    backend::{ndarray::NdArrayDevice, Autodiff, NdArray},
    train::util,
};
use wasm_bindgen::prelude::*;

mod train;

#[wasm_bindgen(start)]
pub fn start() {
    console_error_panic_hook::set_once();
    console_log::init().expect("Error initializing logger");
}

#[wasm_bindgen]
pub fn run(worker_url: String) -> Result<(), String> {
    log::info!("Hello from Rust");
    util::init(worker_url)?;
    train::run::<Autodiff<NdArray<f32>>>(NdArrayDevice::Cpu);
    Ok(())
}

#[wasm_bindgen]
pub fn child_entry_point(ptr: u32) {
    let work = unsafe { Box::from_raw(ptr as *mut Box<dyn FnOnce()>) };
    (*work)();
}
