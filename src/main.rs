use std::error::Error;
use random_str as random;

slint::include_modules!();

fn main() -> Result<(), Box<dyn Error>> {
    let ui: AppWindow = AppWindow::new()?;
    println!("Hello");

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

            println!("Password: {}", random_password);
        }
    });

    ui.run()?;

    Ok(())
}
