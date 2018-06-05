# Comparing UDP throughput

This is a benchmark that compares the performance of the same UDP application written in

- **Swift** using the [NIO networking library](https://github.com/apple/swift-nio)
- **Javascript** using the `"dgram"` [module](https://nodejs.org/dist/latest-v8.x/docs/api/dgram.html) of **NodeJS**

## The application

1. Opens two different UDP (IPv4) sockets on the loopback interface
2. Sends the numbers 0x0000 to 0xFFFF from one socket to the another. This is done in an interleaved way. When a socket receives a number it increments it and sends the result back to the originating socket. This process is bootstrapped by one socket sending number 0 to the other socket. The sockets then increment the number while sending it back and forth. When the number 0xFFFF is reached the application stops. It goes as follows:
   - socket A sends number 0 to socket B
   - when socket B receives 0, it increments it and sends number 1 to socket A
   - when socket A receives 1, it increments it and sends number 2 to socket B
   - when socket B receives 2, it increments it and sends number 3 to socket A
   - ...

   The numbers are encoded and decoded as unsigned 16 bit integers.

## The result

I ran the applications on both my Macbook and a Raspberry Pi 3 Model B. The resulting execution times are plotted in the diagram below. Although the same amount of bytes are sent over the UDP sockets, it is clear that swift is able to transfer them (about 1.47 times) faster.

![results](https://dev1an.github.io/Swift-NodeJS-UDP-Benchmark/results.svg)

<p align="center">Execution time in milliseconds</p>

## Run it yourself

**Requirements**

- Swift 4.1
- NodeJS
- git
- awk

**Usage**

```sh
# Shell
git clone https://github.com/Dev1an/Swift-NodeJS-UDP-Benchmark.git
cd Swift-NodeJS-UDP-Benchmark
scripts/benchmark.sh
```

