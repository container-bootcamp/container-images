var http = require("http");
var createHandler = require("github-webhook-handler");
var fs = require("fs");

var handler = createHandler({ path: "/webhook", secret: process.env.SECRET });

var branch = process.env.BRANCH;
var repo = process.env.REPO;
var location = process.env.LOCATION;
var autoPull = process.env.AUTOPULL;

var init = function() {
  console.log("Cloning %s origin/%s into %s", repo, branch, location);

  try {
    fs.rmdirSync(location);
  } catch (err) {}
  fs.mkdirSync(location);

  var g = require("simple-git")(location);

  g.clone(repo, location, function(err, update) {
    if (!err) {
      console.log("INIT :: ", "       repo pulled");
      g.checkout(branch, function(err, res) {
        if (!err) {
          console.log("INIT ::       branch %s pulled", branch);
        } else {
          console.warn("INIT :: ", err, update);
          if (err.indexOf("fatal: destination path") == 0) {
            return doPull();
          }
          return process.exit(1);
        }
      });
    } else {
      console.warn("INIT :: ", err, update);
      return doPull();
    }
  });
};

var doPull = function() {
  console.log("Pulling origin/%s into %s", branch, location);
  require("simple-git")(location).pull("origin/" + branch, function(
    err,
    update
  ) {
    console.log(err, update);
    console.log("RESTAGE :: ", "       new version pulled");
  });
};

setTimeout(function() {
  http
    .createServer(function(req, res) {
      handler(req, res, function(err) {
        res.statusCode = 404;
        res.end("no such location");
      });
    })
    .listen(7777);

  handler.on("error", function(err) {
    console.error("Error:", err.message);
  });

  handler.on("push", function(event) {
    var r = event.payload.repository.full_name;
    var ref = event.payload.ref;
    if (r == repo && ref == "refs/heads/" + branch)
      console.log("Received a push event for %s on branch %s", r, ref);
    if (autoPull && location) doPull();
  });

  handler.on("*", function(emitData) {
    if (process.env.DEBUG)
      setTimeout(function() {
        console.log(JSON.stringify(emitData));
      }, 1000);
  });

  setTimeout(function() {
    init();
  }, 10000);
}, 3500);
