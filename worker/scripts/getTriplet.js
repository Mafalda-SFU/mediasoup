const {arch, platform} = require('os');

// const { getTriplet } = require('../../node/lib/utils');
function getTriplet()
{
	return `${platform()}-${arch()}`;
}

process.stdout.write(getTriplet());
