#!/usr/bin/env perl

use Test::Spec;

use Life::Tile;

describe 'Life::Tile' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = Life::Tile->new({
            chr_alive => q{#},
            chr_dead => q{ },
        });
    };

    describe '#determine_state' => sub {
        context 'when alive' => sub {
            before each => sub { $vars{app}->alive(1) };

            context 'with 2 alive neighbours' => sub {
                it 'should not flip' => sub {
                    $vars{app}->determine_state(2);

                    is 1, $vars{app}->alive;
                };
            };

            context 'with 3 alive neighbours' => sub {
                it 'should not flip' => sub {
                    $vars{app}->determine_state(3);

                    is 1, $vars{app}->alive;
                };
            };

            context 'with any other amount of alive neighbours' => sub {
                it 'should flip' => sub {
                    $vars{app}->determine_state(1);

                    is 0, $vars{app}->next_state;
                };
            };
        };

        context 'when dead' => sub {
            context 'with 3 alive neighbours' => sub {
                it 'should flip' => sub {
                    $vars{app}->determine_state(3);

                    is 1, $vars{app}->next_state;
                };
            };

            context 'with any other amount of alive neighbours' => sub {
                it 'should not flip' => sub {
                    $vars{app}->determine_state(1);

                    is 0, $vars{app}->alive;
                };
            };
        };
    };

    describe '#flip' => sub {
        context 'when alive' => sub {
            before each => sub { $vars{app}->alive(1) };

            it 'should set the next state to dead' => sub {
                $vars{app}->flip;

                is 0, $vars{app}->next_state;
            };
        };

        context 'when dead' => sub {
            it 'should set the next state alive' => sub {
                $vars{app}->flip;

                is 1, $vars{app}->next_state;
            };
        };
    };

    describe '#render' => sub {
        context 'when alive' => sub {
            before each => sub { $vars{app}->alive(1) };

            it 'should return the alive character' => sub {
                is q{#}, $vars{app}->render;
            };
        };

        context 'when dead' => sub {
            it 'should return the dead character' => sub {
                is q{ }, $vars{app}->render;
            };
        };
    };
};

runtests unless caller;
