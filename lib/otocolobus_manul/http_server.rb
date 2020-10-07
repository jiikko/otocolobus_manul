module OtocolobusManul::HTTPServer
  def initialize
  end

  def start
    listeners = create_listeners(address, port)

    if svrs = IO.select(@listeners)
    end
  end

  def create_listeners(part: 1025)
    address = '127.0.0.1'
    sockets = Socket.tcp_server_sockets(address, port)
    sockets = sockets.map {|s|
      s.autoclose = false
      ts = TCPServer.for_fd(s.fileno)
      s.close
      ts
    }
    return sockets
  end
end
