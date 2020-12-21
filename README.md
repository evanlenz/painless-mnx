# painless-mnx
This software (musicxml-to-mnx.xsl) will convert [MusicXML](https://www.musicxml.com/) documents to [MNX](https://w3c.github.io/mnx/) format using XSLT.

See [MNX by example](https://w3c.github.io/mnx/by-example/) and the [MNX Draft Specification](https://w3c.github.io/mnx/specification/common/).

## Inspiration
The project title is earnest but tongue-in-cheek. It's inspired by the question "Why not XSLT?" and Adrian Holovaty's invitation/challenge given here: https://youtu.be/x2OZ5i2oD8U?t=5749

See also his Python-based [mnxconverter](https://github.com/w3c/mnxconverter) project, which is included as a submodule for its test cases.

## Running the tests
Run run-tests.sh (from the tests directory) after putting these jar files in your CLASSPATH environment variable:

 * the [Saxon-HE](https://sourceforge.net/projects/saxon/files/Saxon-HE/10/Java/) jar file (for XSLT processing)
 * resolver.jar from the [Apache xml-commons project](http://xerces.apache.org/xml-commons/) (for DTD resolution)

NOTE: The tests don't pass yet, since this project is just getting started.
