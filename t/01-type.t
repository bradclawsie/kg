use v5.42;
use strictures 2;
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing ok subtest );
use Test2::Tools::Exception qw( dies lives );
use Kg::Crypt::IV           qw( rand_iv );
use Kg::Crypt::Key          qw( rand_key );
use Kg::Model::Attribute    qw(
  $ROLE_ADMIN
  $ROLE_NORMAL
  $ROLE_TEST
  $STATUS_ACTIVE
  $STATUS_INACTIVE
  $STATUS_UNCONFIRMED
);
use Kg::Type qw( assert_IV assert_Key assert_Role assert_Status );

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

subtest 'IV' => sub {
  ok(
    lives {
      assert_IV(rand_iv);
    },
  );

  ok(
    dies {
      assert_IV(q{});
    },
  );

  done_testing;
};

subtest 'Key' => sub {
  ok(
    lives {
      assert_Key(rand_key);
    },
  );

  ok(
    dies {
      assert_Key(q{});
    },
  );

  done_testing;
};

subtest 'Role' => sub {
  ok(
    lives {
      assert_Role($ROLE_NORMAL);
      assert_Role($ROLE_ADMIN);
      assert_Role($ROLE_TEST);
    },
  );

  ok(
    dies {
      assert_Role(0);
    },
  );

  done_testing;
};

subtest 'Status' => sub {
  ok(
    lives {
      assert_Status($STATUS_UNCONFIRMED);
      assert_Status($STATUS_ACTIVE);
      assert_Status($STATUS_INACTIVE);
    },
  );

  ok(
    dies {
      assert_Status(0);
    },
  );

  done_testing;
};

done_testing;

