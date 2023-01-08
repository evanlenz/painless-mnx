# painless-mnx
This software (musicxml-to-mnx.xsl) will convert [MusicXML](https://www.musicxml.com/) documents to [MNX](https://w3c.github.io/mnx/) format using XSLT.

See [MNX by example](https://w3c.github.io/mnx/by-example/) and the [MNX Draft Specification](https://w3c.github.io/mnx/docs/).

## Inspiration
The project title is earnest but tongue-in-cheek. It's inspired by the question "Why not XSLT?" and Adrian Holovaty's invitation/challenge given here: https://youtu.be/x2OZ5i2oD8U?t=5749

See also his Python-based [mnxconverter](https://github.com/w3c/mnxconverter) project, which is included as a submodule for its test cases.

## Running the tests
Run run-tests.sh (from the tests directory) after putting these jar files in your CLASSPATH environment variable:

 * the jar file for [Saxon-HE](https://saxon.sourceforge.net/#F11HE) version 11 or later (for XSLT processing)
 * resolver.jar from the [Apache xml-commons project](http://xerces.apache.org/xml-commons/) (for DTD resolution)

NOTE: The tests don't pass yet, since this project is just getting started.

## Visualizing the test-case conversions
Optionally, you can visualize the XSLT transformation for each test case (using the [xslt-visualizer](https://github.com/evanlenz/xslt-visualizer) project), by running visualize.sh.

For example, from the tests directory, run:

    visualize.sh basic

To view the results:

  1) Open visualized-conversions/basic.html in the browser.
  2) Drag the slider to inspect the transformation.
  3) Hover over the center column's match patterns (grouped by mode) to see the invoked XSLT.
