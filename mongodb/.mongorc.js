DBQuery.prototype._prettyShell = true
DBQuery.prototype.unpretty = function () {
        this._prettyShell = false;
        return this;
}
EDITOR= "vim"

stash={
  "save":
  function(name, func) {
    db.system.js.save({
      _id: name,
      value: func
    });
  }
}
