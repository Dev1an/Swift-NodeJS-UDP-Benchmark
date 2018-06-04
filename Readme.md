# Comparing UDP throughput

This is a benchmark that compares the performance of the same UDP application written in

- **Swift** using the [NIO networking library](https://github.com/apple/swift-nio)
- **Javascript** using the `"dram"` [module](https://nodejs.org/dist/latest-v8.x/docs/api/dgram.html) of **NodeJS**

## The application

1. Opens two different UDP (IPv4) sockets on the loopback interface
2. Sends the numbers 0x0000 to 0xFFFF from one socket to the another. This is done in an interleaved and blocking way:
   - socket A sends number 0 to socket B
   - socket B reads the number, adds 1 to it, and then sends the result (number 2) to socket A
   - socket A reads the number, adds 1 to it, and then sends the result (number 3)  to socket B
   - socket B reads the number, adds 1 to it, and then sends the result (number 4)  to socket A
   - ...

## The result

I ran the applications on both my Macbook and a Raspberry Pi 3 Model B. The resulting execution times are plotted in the diagram below. Although the same amount of bytes are sent over the UDP sockets, it is clear that swift is able to transfer them quicker.

![results](https://dev1an.github.io/Swift-NodeJS-UDP-Benchmark/results.svg)