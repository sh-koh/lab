use std::{
    io::{BufReader, Read},
    fs::File,
    path::Path,
};

struct Colors {
    black:       &'static str,
    red:         &'static str,
    green:       &'static str,
    brown:       &'static str,
    blue:        &'static str,
    purple:      &'static str,
    cyan:        &'static str,
    yellow:      &'static str,
    bold:        &'static str,
    faint:       &'static str,
    italic:      &'static str,
    underline:   &'static str,
    blink:       &'static str,
    negative:    &'static str,
    crossed:     &'static str,
    nc:          &'static str,
}

const COLORS: Colors = Colors {
    black:       "\x1B[0;30m",
    red:         "\x1B[0;31m",
    green:       "\x1B[0;32m",
    brown:       "\x1B[0;33m",
    blue:        "\x1B[0;34m",
    purple:      "\x1B[0;35m",
    cyan:        "\x1B[0;36m",
    yellow:      "\x1B[0;33m",
    bold:        "\x1B[0m",
    faint:       "\x1B[2m",
    italic:      "\x1B[3m",
    underline:   "\x1B[4m",
    blink:       "\x1B[5m",
    negative:    "\x1B[7m",
    crossed:     "\x1B[9m",
    nc:          "\x1B[0m",
};


#[derive(Debug)]
struct Fetch {
    hostname: String,
    uptime: String,
    os: String,
    kernel: String,
    cpu: String,
    mem_total: u32,
    mem_used: u32,
    mem_available: u32,
    pkgs: u16, // /run/current-system/sw/bin
}

impl Fetch {
    fn new() -> std::io::Result<Self> {
        Ok(Self {
            hostname: format!("{}atrebois{}", COLORS.red, COLORS.nc),
            uptime: "13:43:25".to_string(),
            os: "NixOS Unstable".to_string(),
            kernel: "6.11.2-zen1".to_string(),
            cpu: "AMD Ryzen 2700X 8c 16t".to_string(),
            mem_total: 32792764,
            mem_used: 25560312,
            mem_available: 28422692,
            pkgs: 1156, /* /run/current-system/sw/bin */
        })
    }
    fn prop(&self, cmd: &str) -> String {
        match cmd {
            "all" => {
                format!("{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}",
                    self.prop("hostname"),
                    self.prop("uptime"),
                    self.prop("os"),
                    self.prop("kernel"),
                    self.prop("cpu"),
                    self.prop("mem_total"),
                    self.prop("mem_used"),
                    self.prop("mem_available"),
                    self.prop("pkgs")
                )
            }
            "hostname"      => format!("{}Hostname:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.hostname),
            "uptime"        => format!("{}Uptime:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.uptime),
            "os"            => format!("{}OS:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.os),
            "kernel"        => format!("{}Kernel:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.kernel),
            "cpu"           => format!("{}CPU:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.cpu),
            "mem_total"     => format!("{}Mem[Total]:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.mem_total),
            "mem_used"      => format!("{}Mem[Used]:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.mem_used),
            "mem_available" => format!("{}Mem[Available]:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.mem_available),
            "pkgs"          => format!("{}Packages:{} {}", String::from(COLORS.cyan), String::from(COLORS.nc), self.pkgs),
            _               => format!("{}{:?}{}", String::from(COLORS.red), self, String::from(COLORS.nc)),
        }
    }
}

pub fn main() {
    let my_pc = Fetch::new().unwrap();
    println!("{}", my_pc.prop("all"));
}
