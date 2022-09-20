use cli::prelude::*
use regex::prelude::*

// NOTE: help_msg only tells you the first part, the other stuff is auto generated

@cli(author, version, about, propagate)
@help_msg(help_msg)
data Args {
    # extended pattern to match (use this instead of pattern if it exists)
    @sflag e: String?
    # file to retrieve the pattern from (not to match)
    @sflag f: String?

    pattern: String

    # input string or file
    input: String
}

fn main(args: Args) -> Status {
    mut working_string = String()

    // if x is File is a std:: lib parser hook that implicity calls std::fs::read(x)
    // but we just use read_to_string
    if let Ok(file_contents) = read_to_string(args.input) {
        working_string = file_contents
    }

    // retrieve the pattern
    let pattern = args.e? : args.pattern

    // go through each line of the string to see if the string exists
    // for_each_line/filter_line is impl'd from the ReadLine trait in std
    let res = working_string.filter_line(l => regex::find(pattern, l)).collect()

    println(res)
}

fn help_msg() -> String {
    "Grep, a utility to match certain substrings and retrieve their contexts (lines)"
}
