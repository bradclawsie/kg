package Kg::Model::Attribute;
use v5.42;
use strictures 2;
use Exporter qw( import );
use Readonly ();

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

Readonly::Scalar our $ROLE_NORMAL        => 1;
Readonly::Scalar our $ROLE_ADMIN         => 2;
Readonly::Scalar our $ROLE_TEST          => 3;
Readonly::Scalar our $STATUS_UNCONFIRMED => 1;
Readonly::Scalar our $STATUS_ACTIVE      => 2;
Readonly::Scalar our $STATUS_INACTIVE    => 3;

our @EXPORT_OK =
  qw( $ROLE_NORMAL $ROLE_ADMIN $ROLE_TEST $STATUS_UNCONFIRMED $STATUS_ACTIVE $STATUS_INACTIVE );
our %EXPORT_TAGS = (
  all => [
    qw( $ROLE_NORMAL $ROLE_ADMIN $ROLE_TEST $STATUS_UNCONFIRMED $STATUS_ACTIVE $STATUS_INACTIVE )
  ]
);

__END__

