import prologue
import mycouch

# BUG https://github.com/planety/prologue/issues/149

#type
#  CouchDBContext* = concept ctx
#    ctx is Context
#    ctx.database is AsyncCouchDBClient
type
  CouchDBContext* = ref object of Context
    database*: AsyncCouchDBClient


template setup*(db: AsyncCouchDBClient) =
  proc init[T: CouchDBContext](ctx: T) =
    ctx.database = db

  method extend(ctx: CouchDBContext) =
    ctx.database = db



proc couchMiddleware*[T: CouchDBContext](ctxType: typedesc[T]): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
    let ctx = ctxType(ctx)
    await switch(ctx)
