#!/usr/bin/perl -w

use strict;
use warnings;

use File::Mork;
use Data::Dumper;

unless (@ARGV and $ARGV[0])
{
	die "Usage: $0 <mab-file>\n";
}

my $mork = File::Mork->new($ARGV[0], verbose => 1) 
    || die $File::Mork::ERROR."\n";

print "version: 1\n";


my $foo = '
  WorkAddress2 = 
       Custom1 = 
     HomeState = 
    FamilyName = 
     RecordKey = 31e
   HomeCountry = 
      LastName = 
       Custom2 = 
   WorkCountry = 
  HomeAddress2 = 
       Custom3 = 
       Company = 
AnniversaryDay = 
         Notes = 
AnniversaryMonth = 
   WorkZipCode = 
CellularNumber = 
   HomeAddress = 
      Category = 
      WebPage2 = 
 WorkPhoneType = 
PagerNumberType = 
     FirstName = Denise
      HomeCity = 
DefaultAddress = 
      WebPage1 = 
      WorkCity = 
PhoneticLastName = 
    Department = 
  PrimaryEmail = dehealy@rkd.ie
   SecondEmail = 
LastModifiedDate = 0
LowercasePrimaryEmail = dehealy@rkd.ie
     WorkPhone = 
   DisplayName = Denise Healy
 LastVisitDate = 0
     FaxNumber = 
      JobTitle = 
AnniversaryYear = 
_AimScreenName = 
      CardType = 
    BirthMonth = 
   PagerNumber = 
 HomePhoneType = 
     BirthYear = 
     HomePhone = 
CellularNumberType = 
PreferMailFormat = 0
PhoneticFirstName = 
   WorkAddress = 
  DefaultEmail = 
    SpouseName = 
 FaxNumberType = 
   HomeZipCode = 
      BirthDay = 
      NickName = 
            ID = 4AD
     WorkState = 
       Custom4 = 
';

foreach my $entry ($mork->entries) {
	next if $entry->{'ListName'};
	my @dn;
	push @dn, "cn=$entry->{'DisplayName'}" if $entry->{'DisplayName'};
	push @dn, "mail=$entry->{'PrimaryEmail'}" if $entry->{'PrimaryEmail'};
	die "unrecognised entry: ".Dumper($entry) unless @dn;
	print "dn: ".join(",", @dn)."\n";
	print <<EOF;
objectclass: top
objectclass: person
objectclass: organizationalPerson
objectclass: inetOrgPerson
objectclass: mozillaAbPersonAlpha
EOF
	my $fields = {
		DisplayName => 'cn',
		PrimaryEmail => 'mail',
		FirstName => 'givenName',
		LastName => 'sn',
		LastModifiedDate => 'modifytimestamp',
		HomeAddress => 'mozillaHomeStreet',
		HomeAddress2 => 'mozillaHomeStreet2',
		HomeCity => 'mozillaHomeLocalityName',
		HomeState => 'mozillaHomeState',
		HomeZipCode => 'mozillaHomePostalCode',
		HomeCountry => 'mozillaHomeCountryName',
		NickName => 'mozillaNickname',
		SecondEmail => 'mozillaSecondEmail',
		PreferMailFormat => 'mozillaUseHtmlMail',
		Custom1 => 'mozillaCustom1',
		Custom2 => 'mozillaCustom2',
		Custom3 => 'mozillaCustom3',
		Custom4 => 'mozillaCustom4',
		Company => 'company',
		_AimScreenName => 'nsAIMid',
		WorkPhone => 'telephoneNumber',
		FaxNumber => 'facsimileTelephoneNumber',
		CellularNumber => 'mobile',
	};

	my %valuable_fields;
	foreach my $fieldname (keys %$entry)
	{
		if ($entry->{$fieldname})
		{
			$valuable_fields{$fieldname} = $entry->{$fieldname};
		}
	}

	delete $valuable_fields{RecordKey};
	delete $valuable_fields{ID};
	delete $valuable_fields{LowercasePrimaryEmail};
	delete $valuable_fields{PopularityIndex};
	delete $valuable_fields{DbRowID};
	delete $valuable_fields{PhotoURI};
	delete $valuable_fields{PhotoType};
	delete $valuable_fields{AllowRemoteContent};

	foreach my $fieldname (keys %$fields)
	{
		if ($valuable_fields{$fieldname})
		{
			my $ldif_name = $fields->{$fieldname};
			print "$ldif_name: ".$valuable_fields{$fieldname}."\n";
		}
		delete $valuable_fields{$fieldname};
	}
	
	if (keys %valuable_fields)
	{
		die "unused fields in entry: ".Dumper(\%valuable_fields);
	}
	print "\n";
}

=pod
foreach my $entry ($mork->entries) {
	my $keys = [sort keys %$entry];
        foreach my $key (@$keys)
	{
            printf ("%14s = %s\n", $key, $entry->{$key});
        }
	print "\n";
    }
=cut
