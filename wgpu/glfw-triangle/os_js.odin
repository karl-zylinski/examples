package vendor_wgpu_example_triangle

import "core:sys/wasm/js"

import "vendor:wgpu"

OS :: struct {
	initialized: bool,
}

os_init :: proc() {
	ok := js.add_window_event_listener(.Resize, nil, size_callback)
	assert(ok)
}

// NOTE: frame loop is done by the runtime.js repeatedly calling `step`.
os_run :: proc() {
	state.os.initialized = true
}

@(private="file", export)
step :: proc(dt: f32) -> bool {
	if !state.os.initialized {
		return true
	}

	frame(dt)
	return true
}

os_get_render_bounds :: proc() -> (width, height: u32) {
	rect := js.get_bounding_client_rect("body")
	return u32(rect.width), u32(rect.height)
}

os_get_surface :: proc(instance: wgpu.Instance) -> wgpu.Surface {
	return wgpu.InstanceCreateSurface(
		instance,
		&wgpu.SurfaceDescriptor{
			nextInChain = &wgpu.SurfaceSourceCanvasHTMLSelector{
				sType = .SurfaceSourceCanvasHTMLSelector,
				selector = "#wgpu-canvas",
			},
		},
	)
}

@(private="file", fini)
os_fini :: proc() {
	js.remove_window_event_listener(.Resize, nil, size_callback)

	finish()
}

@(private="file")
size_callback :: proc(e: js.Event) {
	resize()
}
