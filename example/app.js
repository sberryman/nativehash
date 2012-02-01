// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});

// TODO: write your module tests here
var nativehash = require('com.shaunberryman.nativehash');
Ti.API.info("module is => " + nativehash);

// input data
var input_string = 'this is a test string',
input_expecting = 'f6774519d1c7a3389ef327e9c04766b999db8cdfb85d1346c471ee86d65885bc';

Ti.API.info('Expecting:');
Ti.API.info('Input: "' + input_string + '" - Sha256: ' + input_expecting)
Ti.API.info('-------------------------------------');

var result = nativehash.sha256(input_string);
Ti.API.info('Input: "' + input_string + '" - Sha256: ' + result);

if (result === input_expecting) {
  Ti.API.info('SUCCESS!');
} else {
  Ti.API.info('ERROR, hash does not match!');
}

// get all the contacts and hash the phone numbers and email addresses
var results = nativehash.hashContacts();
for (var i=0; i < results.length; i++) {
  Ti.API.info('Object: ' + results[i]);
};

window.open();
