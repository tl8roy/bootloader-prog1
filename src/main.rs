#![no_std]
#![no_main]

extern crate panic_semihosting; // logs messages to the host stderr; requires a debugger

use cortex_m::asm;
use cortex_m_semihosting::{hprintln};
//use stm32f3::stm32f303;
use alt_stm32f30x_hal::rcc::RccExt;
use alt_stm32f30x_hal::gpio::*;
use embedded_hal::digital::v2::{OutputPin,InputPin};




#[no_mangle]
pub extern "C" fn ProgramStart() -> ! {

    let _x = 42;

    hprintln!("Prog 1").unwrap();

    let p = alt_stm32f30x_hal::pac::Peripherals::take().unwrap();
 
    let mut rcc = p.RCC.constrain();
    let gpiob = p.GPIOB.split(&mut rcc.ahb);
    let gpioc = p.GPIOC.split(&mut rcc.ahb);


    let mut led1: PBx<PullNone,Output<PushPull,LowSpeed>> = gpiob
        .pb0
        .output()
        .downgrade()
        .into();


    let mut led2: PBx<PullNone,Output<PushPull,LowSpeed>> = gpiob
            .pb14
            .output()
            .downgrade()
            .into();

    let btn: PCx<PullNone,Input> = gpioc
            .pc13
            .input()
            .downgrade()
            .into();
    led1.set_high().unwrap();

    loop {

        if btn.is_high().unwrap() {
            led2.set_high().unwrap();
        } else {
            led2.set_low().unwrap();
        }

        // your code goes here
    }

}


#[link_section = ".program_start"]
#[no_mangle]
pub static PROGRAM_START: unsafe extern "C" fn() -> ! = ProgramStart;