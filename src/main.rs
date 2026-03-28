use arboard::Clipboard;
use random_str::random::{self, CharBuilder};
use slint::ToSharedString;
use std::error::Error;

slint::include_modules!();

fn main() -> Result<(), Box<dyn Error>> {
    let ui: AppWindow = AppWindow::new()?;
    let mut clipboard = Clipboard::new().unwrap();

    ui.on_request_generate_password({
        let ui_handle = ui.as_weak();
        move || {
            let ui = ui_handle.unwrap();
            
            let mut builder =
                random::RandomStringBuilder::new().with_length(ui.get_length() as usize);

            if ui.get_lowercase() {
                builder = builder.with_lowercase();
            }

            if ui.get_uppercase() {
                builder = builder.with_uppercase();
            }

            if ui.get_numbers() {
                builder = builder.with_numbers();
            }

            if ui.get_symbols() {
                builder = builder.with_symbols();
            }

            let random_password = builder
                .build()
                .unwrap_or_else(|| "Select at least one option".into());

            ui.set_password(random_password.to_shared_string());
        }
    });

    ui.on_request_copy_to_clipboard({
        let ui_handler = ui.as_weak();
        move || {
            let ui = ui_handler.unwrap();
            let password = ui.get_password();
            if !password.eq("Press Generate") {
                clipboard.set_text(password.as_str()).unwrap();
            }
        }
    });

    ui.run()?;

    Ok(())
}
