use inc::Module::Install;
name 'Test-Cukes';
all_from 'lib/Test/Cukes.pm';

requires
  "Any::Moose"           => "0.07",
  "Exporter::Lite"       => "0.02";

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

auto_include;
WriteAll;