import base64
coded_string = '''cmV2ZXJzZTo5UldZaTkxYno5RmR1TlhZMzlGZGhoR2Q3WkVWRGRIVTo0NmVzYWI='''
print(base64.b64decode(coded_string))
coded_string = '''9RWYi91bz9FduNXY39FdhhGd7ZEVDdHU'''[::-1]
print(base64.b64decode(coded_string))
