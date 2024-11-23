const getLedger = require('./getLedgerRouter');
const getLookForLedger = require('./getLookForLedgerRouter');

const allLedgerRouters = {
    getLedger,
    getLookForLedger
}

module.exports = allLedgerRouters;