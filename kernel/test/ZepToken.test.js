const ZepToken = artifacts.require('ZepToken');

// TODO: Add integration tests

contract('ZepToken', () => {
  beforeEach(async function () {
    this.zepToken = await ZepToken.new();
  });

  it('has a name', async function () {
    const name = await this.zepToken.name();
    assert.equal(name, "Zep Token");
  });

  it('has a symbol', async function () {
    const symbol = await this.zepToken.symbol();
    assert.equal(symbol, "ZEP");
  });

  it('has an amount of decimals', async function () {
    const decimals = await this.zepToken.decimals();
    assert.equal(decimals, 18);
  });
});
