# CL
Generates change log from version tags (vX.Y.Z) and lines beginning with "cl: "
in commit messages. This is a hack, pending proper implementation.

## Usage example
Right before release of v1.0:

    ./cl.rb v1.0 > CHANGES.md

## Demo
[![CL demo](https://asciinema.org/a/afjqzwb2f55fw4i5l5xn1eryf.png)](https://asciinema.org/a/afjqzwb2f55fw4i5l5xn1eryf?autoplay=1)

## Acknowledgements
* Albert Arvidsson <albert.arvidsson@gmail.com> for giving me the idea
* Markus Läll <markus.l2ll@gmail.com> for providing valuable input

## Licence
Copyright (c) 2015 Johan Sageryd <j@1616.se>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
