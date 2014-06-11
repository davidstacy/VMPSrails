require 'net/telnet'


class CiscoTelnet
require 'net/telnet'

def initialize options
 @host     = options["Host"] || "localhost"
 @user     = options["User"] || "martin"
 @password = options["Password"] || "nopass"
 @enable   = options["Enable"] || "nopass"
 @debug    = options["Debug"] || false
 @prompt   = nil
end

def debug_out(msg)
 $stdout.puts ">> " + msg if @debug
end

def debug_in(msg)
 $stdout.puts "<< " + msg if @debug
end


def open
 @socket = Net::Telnet.new("Host" => @host)
end

def close
 @socket.close
end

# returns last line received
def expect(str)
  ret = @socket.waitfor("String" => str, "Timeout" => 10) { |rv| debug_in(rv) }
  return ret.split('\n').last.strip
end

# overwrite to match dynamic prompt
def cmd(command, timeout=10)
 debug_out command
 return @socket.cmd("String" => command, "Match" => Regexp.new(Regexp.escape(@prompt)), "Timeout" => timeout) { |c| debug_in(c) }
end

def print(s)
 @socket.print(s) { |c| debug_out c }
end

def puts(s)
 @socket.puts(s) { |c| debug_out c }
end

def login
 expect "Password:"
 puts @password
 @prompt = expect '>'
 $stdout.puts "prompt is " + @prompt if @debug
end

def enable
 puts "enable"
 expect "Password:"
 puts @enable
 @prompt = expect '#'
 $stdout.puts "new prompt is " + @prompt if @debug
end


end



