use strict;
use warnings;

use Test::More;

use File::chdir;

local $CWD;
push @CWD, qw/examples Alien-DontPanic/;

my $builder = do 'Build.PL';
isa_ok( $builder, 'Module::Build' );
isa_ok( $builder, 'Alien::Base::ModuleBuild' );

$builder->depends_on('alien');
ok( -d '_install', "ACTION_alien creates _install (share) directory" );
ok( -d '_alien',   "ACTION_alien creates _alien (build) directory" );
{
  local $CWD = '_install';
  {
    local $CWD = 'lib';
    ok( -e 'libdontpanic.so.1.0', "ACTION_alien installs lib" );
  }
  {
    local $CWD = 'include';
    ok( -e 'libdontpanic.h', "ACTION_alien installs header" );
  }
}

my $pc_objects = $builder->config_data('pkgconfig');
my $dontpanic_pc = $pc_objects->{dontpanic};
isa_ok( $dontpanic_pc, 'Alien::Base::PkgConfig', "Generate pkgconfig" );

$builder->depends_on('build');

$builder->depends_on('realclean');
ok( ! -e 'Build'   , "realclean removes Build script" );
ok( ! -d '_install', "realclean removes _install (share) directory" );
ok( ! -d '_alien'  , "realclean removes _alien (build) directory" );

done_testing;