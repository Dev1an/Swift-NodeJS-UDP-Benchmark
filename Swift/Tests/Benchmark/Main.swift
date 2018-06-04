import XCTest
@testable import Numbering

import NIO

final class Benchmark: XCTestCase {
	let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

	func testBench() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		
		let peerA = DatagramBootstrap(group: group)
			.channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.channelInitializer { $0.pipeline.add(handler: SequenceHandler()) }
			.bind(host: "127.0.0.1", port: 0)
		let peerB = DatagramBootstrap(group: group)
			.channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.channelInitializer { $0.pipeline.add(handler: SequenceHandler()) }
			.bind(host: "127.0.0.1", port: 0)
		
		do {
			let (channel1, channel2) = try peerA.and(peerB).wait()
			var zero = channel1.allocator.buffer(capacity: 1)
			zero.write(integer: UInt16(0))
			
			if let address = channel2.localAddress {
				let envelope = AddressedEnvelope(remoteAddress: address, data: zero)
				
				measure {
					let _ = channel1.writeAndFlush(envelope)
					do { try channel1.closeFuture.wait() }
					catch { XCTFail(error.localizedDescription) }
				}
			} else {
				XCTFail("unable to get bound port")
			}
			
		} catch {
			XCTFail(error.localizedDescription)
		}

    }

    static var allTests = [
        ("testBench", testBench),
    ]
}
