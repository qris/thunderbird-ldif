thunderbird-ldif
================

Converts Thunderbird MAB files to LDIF for exchange and corruption
repair.

Based on:

* Jamie Zawinski's [File::Mork](http://search.cpan.org/~simonw/File-Mork-0.3/lib/File/Mork.pm) code for Perl,
  kindly packaged by Simon Wistow.
* [LDIF specification](http://tools.ietf.org/html/rfc2849)
* [Example LDIF file](http://dig.csail.mit.edu/2007/01/camp/people.ldif)
* [Thunderbird LDIF schema](https://wiki.mozilla.org/MailNews:Mozilla_LDAP_Address_Book_Schema)
* Mike Robinson's [basic MAB rescue code](http://ubuntuforums.org/showthread.php?t=1397060),
which inspired me to try to do better.

Usage:

Install the File::Mork extension, for example using CPAN:

	perl -MCPAN -eshell
	<answer any prompts for information>
	install File::Mork

Run the script on your MAB file, saving the output to an LDIF text file:

	perl thunderbird-ldif.pl /path/to/abook.mab.bak

Import that LDIF file into Thunderbird.

