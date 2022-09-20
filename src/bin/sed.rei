// maybe soemthing like clap integrated?
use cli::prelude::*
use regex::prelude::*

/*
    sflag => short flag -sac composable. But if you have a non bool sflag, you cant compose them. E.g. -sl=3 or -sl 3
    flag => long flag --quiet, --no-std, --key=val, --key val
*/

@cli(author, version, about, propagate)
data Args {
    @sflag i: bool
    @sflag c: bool
    # quiet
    @sflag n: bool
    # line length
    @sflag l: Int

    # regex replacement scheme
    scheme: String

    # should be last argument
    file: String
}

fn main(args: Args) -> Status {
    // since only one real "command", most of the logic can be placed here
    mut file = args.file

    // if not in place
    if !args.i {
        file = file + ".copy"
        // or maybe try to directly create it using OS and get its name
    }

    // try to parse scheme
    let capture = Regex(substr("/s".."/")(scheme))
    // try to get the replacement string
    let replacement_string = substr("/".."/g")(scheme)

    let working_string = read_to_string(file).expect("Couldn't read file!")

    let res = working_string.regex_replace(capture, replacement_string).stats()
    println("Replaced {res.count} instances of {capture}")
}
