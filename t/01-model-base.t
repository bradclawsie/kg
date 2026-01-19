use v5.42;
use strictures 2;
use Crypt::Misc             qw( random_v4uuid );
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing note ok subtest );
use Test2::Tools::Exception qw( dies lives );
use Kg::Model::Attribute    qw( $ROLE_ADMIN $STATUS_ACTIVE );

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

{

  package TestBase;
  use Moo;
  with 'Kg::Model::Base';
}

subtest 'valid TestBase' => sub {
  ok(
    lives {
      my $c = TestBase->new;
      $c->signature(random_v4uuid);
      $c->status($STATUS_ACTIVE);
      $c->ctime(time);
      $c->mtime(time);
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

subtest 'invalid attr mutations' => sub {
  ok(
    lives {
      TestBase->new;
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      TestBase->new(role => 12);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      TestBase->new(status => 12);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      my $c = TestBase->new;
      $c->ctime(7);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      my $c = TestBase->new;
      $c->id(random_v4uuid);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      my $c = TestBase->new;
      $c->mtime(7);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      my $c = TestBase->new;
      $c->role($ROLE_ADMIN);
    },
  ) or note($EVAL_ERROR);

  ok(
    dies {
      my $c = TestBase->new;
      $c->schema_version(1);
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

done_testing;
