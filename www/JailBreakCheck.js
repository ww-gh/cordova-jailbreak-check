var exec = require('cordova/exec');

exports.isJailBreak = function(success, error) {
    exec(success, error, "JailBreakCheck", "isJailBreak", []);
};
