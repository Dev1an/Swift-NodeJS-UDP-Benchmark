import NIO

public final class SequenceHandler: ChannelInboundHandler {
	public typealias InboundIn = AddressedEnvelope<ByteBuffer>
	public typealias InboundOut = AddressedEnvelope<ByteBuffer>
	
	public var reachedEnd: EventLoopPromise<Void>
	public init(end: EventLoopPromise<Void>) {
		reachedEnd = end
	}
	
	public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
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
