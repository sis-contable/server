const getListAccountsPlan = require('./getListAccountsPlanRouter');
const getListAccountsPlanByKeyword = require('./getListAccountsPlanByKeywordRouter');
const deletAccount = require('./deletAccountRouter');

const allControlerAccountsPlan = {
    getListAccountsPlan,
    getListAccountsPlanByKeyword,
    deletAccount
}

module.exports = allControlerAccountsPlan;