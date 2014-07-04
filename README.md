コンカレント・プログラミング
============================
並列・分散処理の勉強を目的とする，大学院の講義で作ったプログラム．  
言語は指定されていないので，Rubyで書いている．

1. Network
----------
+ TCP
	$ irb_server.rb
	[NEW CLIENT] 127.0.0.1
	[127.0.0.1] a = 1; b = 2; a + b

	$ irb_client.rb localhost 3000
	CLIENT > a = 1; b = 2; a + b
	SERVER > 3

+ UDP
	$ dns_server.rb
	[127.0.0.1:54744] github.com

	$ dns_client.rb
	CLIENT > github.com
	SERVER > 192.30.252.131
