fn reverse(input: &str) -> String {
    input.chars().rev().collect()
}

pub fn main() {
    let result: String = reverse("testing");
    println!("{result}");
}
