'use strict';

const os = require('os');
const Hapi = require('@hapi/hapi');
const redis = require('@redis/client')
const client = redis.createClient({ url: 'redis://redis:6379' });

client.on('error', (err) => {
    console.log('Error occured while connecting or accessing redis server');
});

const init = async () => {
    await client.connect();
    await client.set('numVisits', 0);

    const server = Hapi.server({
        port: 80,
        host: '0.0.0.0'
    });

    server.route({
        method: 'GET',
        path: '/',
        handler: async (request, h) => {
            let numVisits = await client.get('numVisits');
            await client.set('numVisits', ++numVisits);;
            return `${os.hostname()}: Number of visits is: ${numVisits}`;
        }
    });

    await server.start();
    console.log('Server running on %s', server.info.uri);
};

process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});

init();
