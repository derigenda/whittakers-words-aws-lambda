import subprocess


def endpoint(event, context):
    body = subprocess.run(
        ['bin/words', event['pathParameters']['word']],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        stdin=subprocess.DEVNULL)

    response = {
        "statusCode": 200,
        "body": body.stdout.decode('ascii'),
        "headers": {
            'Content-Type': 'text/plain',
        },
    }

    return response
