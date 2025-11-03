use std::error::Error;
use arboard::Clipboard;
use random_str as random;
use slint::ToSharedString;

slint::include_modules!();

fn main() -> Result<(), Box<dyn Error>> {
    let ui: AppWindow = AppWindow::new()?;
    let mut clipboard = Clipboard::new().unwrap();

    ui.on_request_generate_password({
        let ui_handle = ui.as_weak();
        move || {
            let ui = ui_handle.unwrap();
            // TODO: add error handling
            let random_password = random::get_string(
                16,
                ui.get_lowercase(),
                ui.get_uppercase(),
                ui.get_numbers(),
                ui.get_symbols()
            );

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
