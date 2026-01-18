package Kg::Model::Base;
use v5.42;
use strictures 2;
use Carp                   qw( croak );
use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::UUID            qw( Uuid );
use Kg::Model::Attribute   qw(
  $ROLE_ADMIN
  $ROLE_NORMAL
  $ROLE_TEST
  $STATUS_ACTIVE
  $STATUS_INACTIVE
  $STATUS_UNCONFIRMED
);

use Moo::Role;

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

has [qw( ctime mtime )] => (
  is      => 'rw',
  isa     => PositiveOrZeroInt->where('$_ == 0 || $_ > 1768753518'),
  default => sub { 0 },
);

has id => (
  is      => 'ro',
  isa     => Uuid,
  coerce  => 1,
  default => Uuid->generator,
);

has insert_order => (
  is      => 'rw',
  isa     => PositiveOrZeroInt,
  default => sub { 0 },
);

has role => (
  is  => 'ro',
  isa => sub ($v) {
    croak 'bad role' if $v !~ m{
      ^[
        $ROLE_NORMAL
        $ROLE_ADMIN
        $ROLE_TEST
      ]$}x;
    return true;
  },
  default => sub { $ROLE_NORMAL },
);

has schema_version => (
  is      => 'ro',
  isa     => PositiveOrZeroInt,
  default => sub { 0 },
);

has signature => (
  is      => 'rw',
  isa     => Uuid,
  coerce  => 1,
  default => Uuid->generator,
);

has status => (
  is  => 'rw',
  isa => sub ($v) {
    croak 'bad role' if $v !~ m{
      ^[
        $STATUS_UNCONFIRMED
        $STATUS_ACTIVE
        $STATUS_INACTIVE
      ]$}x;
    return true;
  },
  default => sub { $STATUS_UNCONFIRMED },
);

__END__
