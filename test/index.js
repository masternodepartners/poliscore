'use strict';

var should = require('chai').should();
var poliscore = require('../');

describe('Library', function() {
  it('should export primatives', function() {
    should.exist(poliscore.crypto);
    should.exist(poliscore.encoding);
    should.exist(poliscore.util);
    should.exist(poliscore.errors);
    should.exist(poliscore.Address);
    should.exist(poliscore.Block);
    should.exist(poliscore.MerkleBlock);
    should.exist(poliscore.BlockHeader);
    should.exist(poliscore.HDPrivateKey);
    should.exist(poliscore.HDPublicKey);
    should.exist(poliscore.Networks);
    should.exist(poliscore.Opcode);
    should.exist(poliscore.PrivateKey);
    should.exist(poliscore.PublicKey);
    should.exist(poliscore.Script);
    should.exist(poliscore.Transaction);
    should.exist(poliscore.URI);
    should.exist(poliscore.Unit);
  });
});
