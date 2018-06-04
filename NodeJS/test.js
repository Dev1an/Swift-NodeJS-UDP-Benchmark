const dgram = require("dgram")
const peerA = dgram.createSocket('udp4')
const peerB = dgram.createSocket('udp4')
const description = 'read and write 65535 UDP messages'
var finished = false

addHandlerTo(peerA)
addHandlerTo(peerB)
peerB.on('listening', initiate)
peerA.bind()
peerB.bind()

function initiate() {
    console.time(description)
    peerA.send( Buffer.from([ 0,0 ]), peerB.address().port)
}

function addHandlerTo(peer) {
    peer.on('message', plusOne)

    function plusOne(buffer, remote) {
        const number = buffer.readUInt16BE(0)
        if (number == 0xFFFF) {
            if (finished) console.timeEnd(description)
            peer.send(buffer, remote.port, () => peer.close())
            finished = true
        } else {
            const newBuffer = Buffer.alloc(2)
            newBuffer.writeUInt16BE(number+1)
            peer.send(newBuffer, remote.port)
        }
    }
}