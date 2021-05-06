const katex = require("katex");
const zmq = require("zeromq");



let html = katex.renderToString("( \\big( \\Big( \\bigg( \\Bigg(",true );

console.log(`Sending\n${html}`);