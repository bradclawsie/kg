package Kg::Controller::Test;
use v5.42;
use strictures 2;
use Kelp::Base 'Kelp::Module';

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

sub test ($self) {
  $self->template(
    'test',
    {
      name => __PACKAGE__,
    }
  );
}

__END__
