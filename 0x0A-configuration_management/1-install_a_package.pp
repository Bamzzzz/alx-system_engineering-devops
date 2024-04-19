#!/usr/bin/pup
# Install a flask package (2.1.0)
package {'flask':
	ensure   => '2.1.0',
	provider => 'pip3'
}
