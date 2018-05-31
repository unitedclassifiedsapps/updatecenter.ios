//: Playground - noun: a place where people can play

import UpdateCenter

let versionString = "1.0.0-alpha-1"
let version = SemVersion(versionString)

let major = version.major
let minor = version.minor
let patch = version.patch
let tag = version.tag

let a = SemVersion("1.0.0") >  SemVersion("1.0.0-beta")
let b = SemVersion("1.0.0") <  SemVersion("1.0.0-beta")
let c = SemVersion("1.0.0-beta") ==  SemVersion("1.0.0-beta")
let d = SemVersion("1.0.1-beta") ==  SemVersion("1.0.0-beta")
let e = SemVersion("1.0.1-beta") >  SemVersion("1.0.0-beta")
