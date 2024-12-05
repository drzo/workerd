"""workerd rust crate dependencies analogous to Cargo.toml file.
"""

load("@rules_rust//crate_universe:defs.bzl", "crate")

# We prefer single-digit dependencies to stay up to date as much as possible
PACKAGES = {
    # When adding packages here, please only enable features as needed to keep compile times and
    # binary sizes bounded.
    "anyhow": crate.spec(version = "1"),
    "capnp": crate.spec(version = "0"),
    "capnpc": crate.spec(version = "0"),
    "clang-ast": crate.spec(version = "0"),
    "clap": crate.spec(version = "4", default_features = False, features = ["derive"]),
    "codespan-reporting": crate.spec(version = "0"),
    "cxx": crate.spec(version = "1"),
    "cxxbridge-cmd": crate.spec(version = "1"),
    "flate2": crate.spec(version = "1"),
    # Commit hash refers to lol-html v2.1.0. We then access the nested lol_html_c_api crate within.
    # TODO(npaun): Seems like some changes are still ongoing on the lol-html side. Recheck this in a couple weeks.
    "lol_html_c_api": crate.spec(git = "https://github.com/cloudflare/lol-html.git", rev = "cac9f2f59aea8ad803286b0aae0d667926f441c7"),
    "nix": crate.spec(version = "0"),
    "pico-args": crate.spec(version = "0"),
    "proc-macro2": crate.spec(version = "1"),
    "quote": crate.spec(version = "1"),
    "serde_json": crate.spec(version = "1"),
    "serde": crate.spec(version = "1", features = ["derive"]),
    "syn": crate.spec(version = "2"),
    # tokio is huge, let's enable only features when we actually need them.
    "tokio": crate.spec(version = "1", default_features = False, features = ["net", "rt", "rt-multi-thread", "time"]),
    "tracing": crate.spec(version = "0", default_features = False, features = ["std"]),
}
