require 'socket'
require 'tk'
require 'timeout'

class MulticlientTCPServer

  def initialize( port, timeout, verbose )
    @port = port        # the server listens on this port
    @timeout = timeout  # in seconds
    @verbose = verbose  # a boolean
    @connections = []
    @server =
        begin
          TCPServer.new('126.2.1.1', @port )
        rescue SystemCallError => ex
          raise "Cannot initialize tcp server for port #{@port}: #{ex}"
        end
  end

  def get_socket
    ios = select( [@server]+@connections, nil, @connections, @timeout ) or
        return nil
    ios[2].each do |sock|
      sock.close
      @connections.delete( sock )
      raise "socket #{sock.peeraddr.join(':')} had error"
    end

    ios[0].each do |s|

      s==@server or next
      client = @server.accept or
          raise "server: incoming connection, but no client"
      @connections << client
      @verbose and
          puts "server: incoming connection no. #{@connections.size} from #{client.peeraddr.join(':')}"

      ios = select( @connections, nil, nil, @timeout )
    end

    ios[0].each do |s|

      s==@server and next
      if s.eof?
        @verbose and
            puts "server: client closed #{s.peeraddr.join(':')}"
        @connections.delete(s)
        next
      end
      @verbose and
          puts "server: incoming message from #{s.peeraddr.join(':')}"
      return s
    end
    return nil
  end
end # class MulticlientTCPServer

class ServerMain < MulticlientTCPServer

  def initialize
    puts "hi"
  end
  def setupServer
    srv = MulticlientTCPServer.new(20000, 30, true )

    loop do
      if sock = srv.get_socket
        # a message has arrived, it must be read from sock
        message = sock.gets( "\r\n" ).chomp( "\r\n" )
        # arbitrary examples how to handle incoming messages:
        if message == 'quit'
          raise SystemExit
        elsif message =~ /^puts (.*)$/
          puts "message from #{sock.peeraddr.join(':')}: '#{$1}'"
        elsif message =~ /^echo (.*)$/
          # send something back to the client
          sock.write( "server echo: '#{$1}'\r\n" )
        else
          puts "unexpected message from #{sock.peeraddr}: '#{$1}'"
        end
      else
        sleep 0.01 # free CPU for other jobs, humans won't notice this latency
      end
    end
  end

  def setupGraphics
    $pk = { 'padx' => 10, 'pady' => 10 }
    Thread.new{
      $xi = proc {clientConnect}
    }
    $start = proc {setupServer}
    $root = TkRoot.new {title "Ruby Server"}
    frame = TkFrame.new($root)
    $output1 = TkLabel.new(frame) {text ''; pack($pk)}
    $output2 = TkLabel.new(frame) {text ''; pack($pk)}
    TkButton.new(frame) {text 'Start Server'; command $start; pack($pk)}
    TkButton.new(frame) {text 'Connect to Server'; command $xi; pack($pk)}
    frame.pack('fill'=>'both', 'side' =>'top')
  end

  def clientConnect
    sock = begin
      Timeout::timeout( 30 ) { TCPSocket.open( '126.2.1.1', 20000) }
    rescue StandardError, RuntimeError => ex
      raise "cannot connect to server: #{ex}"
    end

# send sample messages:

    puts "sending one-way message"
    sock.write( "puts This is a one-way message\r\n" )
    sleep( 2 )

    puts "sending a request that should be answered"
    sock.write( "echo This message should be echoed\r\n" )
    response = begin
      Timeout::timeout( 1 ) { sock.gets( "\r\n" ).chomp( "\r\n" ) }
    rescue StandardError, RuntimeError => ex
      raise "no response from server: #{ex}"
    end
    puts "received response: '#{response}'"
    sleep( 2 )

    puts "sending a goodbye message"
    sock.write( "puts bye\r\n" )
    sock.close
  end
end

serv = ServerMain.new
serv.setupGraphics
Tk.mainloop