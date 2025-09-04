package haxeshim;
using StringTools;

class Neko {
  static public var PATH(default, null):String = Os.slashes(Scope.DEFAULT_ROOT + '/neko' + 
    switch [Sys.systemName(), if (js.Node.process.arch.contains('64')) '64' else "" ] {
        case ['Windows', arch]: arch;
        case _:"";
  });

  static var isset = false;  
  static public function setEnv() 
      if (!isset) {
          if (Os.IS_WINDOWS) {
              for (k in ENV.keys()) {
                  Sys.putEnv(k, ENV[k]);
              }
          }
          isset = true;
      }


  static public var ENV(default, null):Env = {
    var varName = switch Sys.systemName() {
      case 'Windows': 'PATH';
      case 'Mac': 'DYLD_LIBRARY_PATH';
      default: 'LD_LIBRARY_PATH';      
    }
    switch Sys.getEnv(varName) {
      case null: [varName => PATH];
      case withNeko if (withNeko.indexOf(PATH) != -1): {};
      case v: [varName => v + Os.DELIMITER + PATH];
    }
  }
}