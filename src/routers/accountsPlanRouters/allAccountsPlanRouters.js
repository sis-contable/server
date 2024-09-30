const getListAccountsPlan = require('./getListAccountsPlanRouter');
const getListAccountsPlanByKeyword = require('./getListAccountsPlanByKeywordRouter');

const allControlerAccountsPlan = {
    getListAccountsPlan,
    getListAccountsPlanByKeyword
}

module.exports = allControlerAccountsPlan;