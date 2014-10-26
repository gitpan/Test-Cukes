package Test::Cukes;
use strict;
use warnings;
use Exporter::Lite;
use Test::More;
use Test::Cukes::Feature;

our $VERSION = "0.01";
our @EXPORT = qw(feature runtests Given When Then);

my $steps = {};
my $feature = {};

sub feature {
    my $caller = caller;
    my $text = shift;

    $feature->{$caller} = Test::Cukes::Feature->new($text)
}

sub runtests {
    my $caller = caller;
    for my $scenario (@{$feature->{$caller}->scenarios}) {
        my %steps = %{$steps->{$caller}};
        for my $step_text (@{$scenario->steps}) {
            Test::More::note( $step_text );

            my (undef, $step) = split " ", $step_text, 2;
            while (my ($step_pattern, $cb) = each %steps) {
                if ($step =~ m/$step_pattern/) {
                    $cb->();
                    next;
                }
            }
        }
    }
}

sub _add_step {
    my ($step, $cb) = @_;
    my $caller = caller;
    $steps->{$caller}{$step} = $cb;
}

*Given = *_add_step;
*When = *_add_step;
*Then = *_add_step;

1;
__END__

=head1 NAME

Test::Cukes - A BBD test tool inspired by Cucumber

=head1 SYNOPSIS

Write your test program like this:

  # test.pl
  use Test::More;
  use Test::Cukes;

  feature(<<TEXT);
  Feature: writing behavior tests
    In order to make me happy
    As a test maniac
    I want to write behavior tests

    Scenario: Hello World
      Given the test program is running
      When it reaches this step
      Then it should pass
  TEXT

  Given qr/the test program is running/, sub {
      pass("running");
  }

  When qr/it reaches this step/, sub {
      pass("reaches");
  }

  Then qr/it should pass/, sub {
      pass("passes");
  }

  plan tests => 3;
  runtests;

When it runs, it looks like this:

    > perl test.pl
    1..3
    # Given the test program is running
    ok 1 - running
    # When it reaches this step
    ok 2 - reaches
    # Then it should pass
    ok 3 - passes

=head1 DESCRIPTION

Test::Cukes is a testing tool inspired by Cucumber
(L<http://cukes.info>). It lets your write your module test with
scenarios. It is supposed to be used with L<Test::More> or other
family of C<Test::*> modules. It uses L<Test::More::note> function
internally to print messages.

This module implements the Given-When-Then clause only in English. To
uses it in the test programs, you feed your feature text into
C<feature> function, defines your step handlers, and then run all the
tests by calling C<runtests>.

For more info about how to define feature and scenarios, please read
the documents from L<http://cukes.info>.

=head1 AUTHOR

Kang-min Liu E<lt>gugod@gugod.orgE<gt>

=head1 SEE ALSO

The official Cucumber web-page, L<http://cukes.info/>.

cucumber.pl, L<http://search.cpan.org/dist/cucumber/>, another Perl
implementation of Cucumber tool.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
