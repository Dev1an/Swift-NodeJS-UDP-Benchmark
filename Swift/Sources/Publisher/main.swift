import MongoKitten

let swiftTime = CommandLine.arguments[1]
let nodeTime = CommandLine.arguments[2]
let machineInfo = CommandLine.arguments[3]

let databaseName = "benchmarks-devian"
let publicServer = try Server(hostname: "ds147180.mlab.com", port: 47180, authenticatedAs: .init(username: "benchmarks-public", password: "ewL-x4R-Zwx-CFN", database: databaseName))

let publicDb = publicServer[databaseName]
let token = String(try publicDb["public"].findOne(["_id": "5b15a6fdfb6fc02bcb8df0a6"])!["value"]!)!

let benchmarkServer = try Server(hostname: "ds147180.mlab.com", port: 47180, authenticatedAs: .init(username: "nio-nodejs", password: token))
let benchmarkCollection = benchmarkServer[databaseName]["swiftNIO-nodeJS"]

try benchmarkCollection.insert([
	"swiftTime": swiftTime,
	"nodeTime": nodeTime,
	"machineInfo": machineInfo,
])
