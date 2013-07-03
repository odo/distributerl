%%
%% @doc TODO: Add description to quperl_common_test
%%
%% @author sage
%%
%% @copyright 2009-2013 Timadorus Project

-module(quperl_common_test).

%%
%% Include files
%%
-include_lib("eunit/include/eunit.hrl").

%%
%% Exported Functions
%%
-export([]).

%%
%% Fixtures
%%

info_test_() ->
    { setup, fun() -> ok end,
      fun() -> ?debugFmt("~n############################################~n      starting ~p~n############################################~n  ", [?MODULE]) end }.

initial_test_() ->
    { "some initial tests",
      setup,

      fun() ->
              %%     application:start(sasl),
              ok
      end,

      fun(_Args) ->
              %%     application:stop(sasl),
              ok
      end,
      fun(_Foo) -> [
                    ?_test(test_basic())
                   ]
      end }.



%%
%% Local Functions
%%

test_basic() ->
    A = [{one,"one data"},{two,"two data"},{three,"three data"},
	 {four,"four data"},{five,"five data"}],
    B = [{one,"one data"},{two,"other two"},{three,"three data"},
	 {four,"other four"},{five,"five data"}],
    A2 = build_tree(A),
    B2 = build_tree(B),
    assert(diff(A2,B2), lists:usort([two, four])),

	C = [{one,"one data"}],
    C2 = build_tree(C),
    assert(diff(A2,C2), lists:usort([two, three, four, five])),

	D = insert({four, sha("changed!")}, A2),
    assert(diff(A2,D), [four]),

	E = insert({five, sha("changed more!")}, D),
    assert(diff(D,E), [five]),
    assert(diff(A2,E), lists:usort([four, five])),
    
	F = delete(five,D),
    G = delete(five,E),
    assert(diff(F,G), []),
    
	H = delete(two,A2),
    assert(diff(A2,H), [two]),
    assert(diff(C2,undefined), [one]),
    
	STree1 = build_tree([{"hello", "hi"},{"and", "what"}]),
    STree2 = build_tree([{"hello", "hi"},{"goodbye", "bye"}]),
    assert(diff(STree1, STree2), lists:usort(["and", "goodbye"])),
  ok.

