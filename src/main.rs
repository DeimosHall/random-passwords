use std::error::Error;

slint::include_modules!();

fn main() -> Result<(), Box<dyn Error>> {
    let ui: AppWindow = AppWindow::new()?;
    println!("Hello");

    ui.run()?;

    Ok(())
}
