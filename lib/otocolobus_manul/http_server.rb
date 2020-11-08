require 'socket'

class OtocolobusManul::HTTPServer
  class Request

    attr_accessor :sock

    def initialize(sock)
      @sock = sock
    end

    def parse!
      binding.pry
      puts line
      sock.close
    end

    private

    def line
      @line ||= sock.gets
    end
  end

  attr_accessor :address, :port
  attr_accessor :shutdown_pipe

  def initialize
    require 'pry'
    self.address = '127.0.0.1'
    self.port = '1025'
    self.shutdown_pipe = IO.pipe
  end

  def self.start
    instance = new
    listeners = instance.create_listeners
    sp = instance.shutdown_pipe[0]

    # クライアントからTCP接続があったら進む. それまでここでブロック
    if svrs = IO.select([sp, *listeners])
      if svrs[0].include?(sp)
        # TODO シャットダウンを検出したら停止する
      end

      svr = svrs[0].first
      if sock = self.accept_client(svr)
        self.run(sock)
      end
    end
  end

  def create_listeners
    sockets = Socket.tcp_server_sockets(address, port)
    sockets = sockets.map {|s|
      s.autoclose = false
      ts = TCPServer.for_fd(s.fileno)
      s.close
      ts
    }
    return sockets
  end

  def self.accept_client(svr)
    case sock = svr.to_io.accept_nonblock(exception: false)
    when :wait_readable
      nil
    else
      sock
      return sock
    end
  end

  def self.run(sock)
    puts("hello #{sock.peeraddr}")
    request = Request.new(sock)
    request.parse!
  end
end
