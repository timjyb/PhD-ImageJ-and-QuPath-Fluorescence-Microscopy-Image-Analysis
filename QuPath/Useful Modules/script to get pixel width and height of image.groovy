def server = getCurrentServer()
def metadata = server.getMetadata()
def width = metadata.getAt('width')
def height = metadata.getAt('height')
print metadata
print width
print height
