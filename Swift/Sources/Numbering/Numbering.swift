import NIO

final class SequenceHandler: ChannelInboundHandler {
	typealias InboundIn = AddressedEnvelope<ByteBuffer>
	typealias InboundOut = AddressedEnvelope<ByteBuffer>
	
	var reachedEnd: EventLoopPromise<Void>
	init(end: EventLoopPromise<Void>) {
		reachedEnd = end
	}
	
	func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
		let envelope = unwrapInboundIn(data)
		var buffer = envelope.data
		
		let number: UInt16 = buffer.readInteger()!
		if number == UInt16.max {
			reachedEnd.succeed(result: ())
		} else {
			var newBuffer = ctx.channel.allocator.buffer(capacity: 2)
			newBuffer.write(integer: number+1)
			
			let _ = ctx.writeAndFlush(wrapInboundOut(.init(remoteAddress: envelope.remoteAddress, data: newBuffer)))
		}
	}
}
