#!/usr/bin/env perl

use Test::Output;
use Test::Spec;

use Life::Simulation;

describe 'Life::Simulation' => sub {
    describe '.new' => sub {
        it 'should seed and render the grid' => sub {
            ensure_render(sub { new_simulation() });
        };
    };

    describe '#on_ticker_tick' => sub {
        it 'should render the grid' => sub {
            my $app = new_simulation();

            # The nested "lifecycle" call kills this tile, so reanimate it
            $app->grid->tiles->[1]->[1]->alive(1);

            ensure_render(sub { $app->on_ticker_tick });
        };
    };
};

runtests unless caller;

sub new_simulation {
    return Life::Simulation->new({
        dimension     => 5,
        seed          => [{ x => 1, y => 1 }],
        chr_tile_dead => q{O},
    });
}

sub ensure_render {
    my $cref = shift;

    my $expected = <<'GRID';
OOOOO
O#OOO
OOOOO
OOOOO
OOOOO
GRID

    {
        open STDOUT, '>/dev/null';
        stdout_like { $cref->() } qr{$expected$}m;
    }

    return 1;
}
