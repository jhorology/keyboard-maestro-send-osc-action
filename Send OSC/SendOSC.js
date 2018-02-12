var osc = require('osc');
var dgram = require('dgram');

// Keyboard Maestro paraameters
var $ = {
  host: process.env.KMPARAM_Remote_Host,
  port: parseInt(process.env.KMPARAM_Port),
  address: process.env.KMPARAM_Address,
  args: [
    {type: process.env.KMPARAM_Arg0_Type, value: process.env.KMPARAM_Arg0_Value},
    {type: process.env.KMPARAM_Arg1_Type, value: process.env.KMPARAM_Arg1_Value},
    {type: process.env.KMPARAM_Arg2_Type, value: process.env.KMPARAM_Arg2_Value}
  ]
};

var argTypes = {
  // int 32
  i: function(v) {
    return parseInt(v);
  },
  // int 64
  h: function(v) {
    var hilo = v.split(',');
    return {high: hilo[0], low: hilo[1]};
  },
  // float 32
  f: function(v) {
    return parseFloat(v);
  },
  // string
  s: function(v) {
    return v;
  },
  // string
  S: function(v) {
    return v;
  },
  // string
  T: function(v) {
    return true;
  },
  // string
  F: function(v) {
    return false;
  },
  // null
  N: function(v) {
    return null;
  },
  // Impulse
  I: function(v) {
    return null;
  },
  // float 64
  d: function(v) {
    return parseFloat(64);
  },
  // 32-bit ASCII character
  c: function(v) {
    return v;
  },
  r: function(v) {
    var rgba = v.split(',');
    return {
      r: parseInt(rgba[0]),
      g: parseInt(rgba[1]),
      b: parseInt(rgba[2]),
      a: parseInt(rgba[3])
    };
  }
}

// create send messeage
var packet = {
  address: $.address,
  args: []
}
for (var i = 0; i < 3; i++) {
  var type = $.args[i].type,
      value = $.args[i].value;
  if ($.args[i].type !== 'None') {
    packet.args.push({
      type: type,
      value: argTypes[type](value)
    });
  }
}
var buf = osc.nativeBuffer(osc.writePacket(packet));

// send UDP packet
var udp = dgram.createSocket('udp4');
udp.send(buf, $.port, $.host, function(err, bytes) {
  if (err)  throw err;
  udp.close();
});
