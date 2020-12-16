#!/usr/bin/env perl -T

use Test::Spec;

use Life::Grid;

describe 'Life::Grid' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = Life::Grid->new({
            dimension      => 5,
            chr_tile_alive => q{#},
            chr_tile_dead  => q{O},
        });
    };

    describe '#modify_tile_at' => sub {
        context 'with valid coordinates' => sub {
            it 'should run a subroutine on the tile at the given coordinates' => sub {
                my ($x, $y) = (5, 5);

                my $expected = $vars{app}->tiles->[$x]->[$x];

                $vars{app}->modify_tile_at($x, $y, sub {
                    my $tile = shift;

                    is $expected, $tile;
                });
            };
        };

        context 'with invalid coordinates' => sub {
            it 'should not operate' => sub {
                my ($x, $y) = (999, 999);

                $vars{app}->modify_tile_at($x, $y, sub {
                    fail 'This should not run';
                });

                pass 'Method did not run';
            };
        };
    };

    describe '#lifecycle' => sub {};

    describe '#render' => sub {
        it 'should return a stringified version of the grid' => sub {
            $vars{app}->seed([
                { x => 1, y => 1 },
                { x => 1, y => 2 },
            ]);

            $vars{app}->lifecycle;

            my $expected = <<'GRID';
OOOOO
O#OOO
O#OOO
OOOOO
OOOOO
GRID
            is $expected, $vars{app}->render;
        };
    };

    describe '#seed' => sub {};
};

runtests unless caller;
