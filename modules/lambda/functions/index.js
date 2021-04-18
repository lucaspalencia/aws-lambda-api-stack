exports.handler = (event, context, callback) => {
    console.log('Event', event);
    console.log('Context', context);

    var response = {
        statusCode: 200,
        headers: {
        'Content-Type': 'text/html; charset=utf-8'
        },
        body: '<p>Hello from lambda_api :)</p>'
    }

    callback(null, response)
}