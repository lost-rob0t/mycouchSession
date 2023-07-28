# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.


import mycouchSession
import prologue
import mycouch
import json
var db {.threadvar.}: AsyncCouchDBClient
db = newAsyncCouchDBClient("http://127.0.0.1", 5984)
echo waitFor db.cookieAuth("admin", "password")
setup(db)


proc hello*(ctx: Context) {.async, gcsafe.} =
  let ctx = CouchDBContext(ctx)
  let doc = await  ctx.database.getDoc("foo", "test")
  resp $doc
let settings = newSettings(debug = true)
var app = newApp(settings = settings)
#app.use(couchMiddleware(CouchDBContext))
app.addRoute("/", hello)
app.run(CouchDBContext)

