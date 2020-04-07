import sys

def application(env, start_response):
    version = "{}.{}".format(sys.version_info.major, sys.version_info.minor)
    start_response("200 OK", [("Content-Type", "text/plain")])
    message = "Hello, World! This is the default message of a nginx uWSGI python {} app deployed in a Docker container".format(
        version
    )
    return [message.encode("utf-8")]
