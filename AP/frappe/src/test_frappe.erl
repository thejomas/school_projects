-module(test_frappe).

%% eunit
-include_lib("eunit/include/eunit.hrl").

-export([test_all/0, test_everything/0]).
-export([]). % Remember to export the other functions from Q2.2

% You are allowed to split your testing code in as many files as you
% think is appropriate, just remember that they should all start with
% 'test_'.
% But you MUST have a module (this file) called test_frappe.

test_all() ->
    eunit:test(
      [
       %%% START/STOP TEST %%%
       start_stop_frappe(),
       zero_cap_start_frappe(),
       neg_cap_start_frappe(),
       %%% INSERT TEST %%%
       basic_insert_frappe(),
       negative_cost_insert_frappe(),
       big_cost_insert_frappe(),
       lru_insert_frappe(),
       insert_same_element(),
       %%% SET TEST %%%
       basic_set_frappe(),
       negative_cost_set_frappe(),
       big_cost_set_frappe(),
       lru_set_frappe(),
       simple_overwrite_set(),
       lru_overwrite_set(),
       %%% READ TEST ###
       simple_read_frappe(),
       fail_read_frappe(),
       lru_read_frappe(),
       set_overwrite_read_frappe(),
       advanced_read_frappe(),
       sanity_advanced_read_frappe(),
       %%% UPDATE TEST ###
       simple_update_frappe(),
       negative_update_frappe(),
       %%% ALL_ITEMS TEST ###
       simple_all_items_test(),
       zero_all_items_test(),
       %%% EVERYTHING TEST %%%
       everything_test_frappe()
      ], [verbose]).

test_everything() ->
        eunit:test(
      [
       %%% STATE TEST %%%
       state_test_frappe()
      ], [verbose]),
    test_all().

%%%%%%%%%%%%%%%%%%%% START/STOP TESTS %%%%%%%%%%%%%%%%%%%%
start_stop_frappe() ->
    {"Start a Frappe server and stop it",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             %% {{_Cache, MCap, _RCap}, _Q, _KWMap} = sys:get_state(FS),
             %% ?assertMatch(MCap, 42),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
zero_cap_start_frappe() ->
    {"Start a Frappe server with zero capacity",
     fun() ->
             ?assertMatch({error, _Reason}, frappe:fresh(0))
     end}.
neg_cap_start_frappe() ->
    {"Start a Frappe server with negative capacity",
     fun() ->
             ?assertMatch({error, _Reason}, frappe:fresh(-42))
     end}.

%%%%%%%%%%%%%%%%%%%% INSERT TESTS %%%%%%%%%%%%%%%%%%%%
basic_insert_frappe() ->
    {"Insert one legal element",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 1)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
negative_cost_insert_frappe() ->
    {"Insert one element with negative cost",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch({error, _Reason}, frappe:insert(FS, a, "not my grade", -3)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
big_cost_insert_frappe() ->
    {"Insert one element with cost greater than capacity",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch({error, _Reason}, frappe:insert(FS, dank, "meme", 420)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
lru_insert_frappe() ->
    {"Insert elements untill the LRU queue deletes an element",
     fun() ->
             {ok, FS} = frappe:fresh(50),
             ?assertMatch(ok, frappe:insert(FS, happy, ":D", 13)),
             ?assertMatch(ok, frappe:insert(FS, unhappy, "D:", 13)),
             ?assertMatch(ok, frappe:insert(FS, cool, "B)", 13)),
             ?assertMatch(ok, frappe:insert(FS, laugh, "xD", 37)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
insert_same_element() ->
    {"Insert the same element twice",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch(ok, frappe:insert(FS, a, 13, 37)),
             ?assertMatch({error, _Reason}, frappe:insert(FS, a, 37, 13)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.


%%%%%%%%%%%%%%%%%%%% SET TESTS %%%%%%%%%%%%%%%%%%%%
basic_set_frappe() ->
    {"Set one legal element",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch(ok, frappe:set(FS, grade, "AP", 12)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
negative_cost_set_frappe() ->
    {"Set one element with negative cost",
     fun() ->
             {ok, FS} = frappe:fresh(42),
             ?assertMatch({error, _Reason}, frappe:set(FS, a, "not my grade", -3)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
big_cost_set_frappe() ->
    {"Set one element with cost greater than capacity",
     fun() ->
             {ok, FS} = frappe:fresh(420),
             ?assertMatch({error, _Reason}, frappe:set(FS, anon, "H4xx0r", 1337)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
lru_set_frappe() ->
    {"Set elements untill the LRU queue deletes an element",
     fun() ->
             {ok, FS} = frappe:fresh(50),
             ?assertMatch(ok, frappe:set(FS, happy, ":D", 13)),
             ?assertMatch(ok, frappe:set(FS, unhappy, "D:", 13)),
             ?assertMatch(ok, frappe:set(FS, cool, "B)", 13)),
             ?assertMatch(ok, frappe:set(FS, laugh, "xD", 37)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
simple_overwrite_set() ->
    {"Set and overwrite one element",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 1)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 2)),
             ?assertMatch(ok, frappe:set(FS, b, "new_two", 4)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
lru_overwrite_set() ->
    {"Set and overwrite one element resulting a deletion",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 4)),
             ?assertMatch(ok, frappe:set(FS, b, "new_two", 5)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.

%%%%%%%%%%%%%%%%%%%% READ TEST %%%%%%%%%%%%%%%%%%%%
simple_read_frappe() ->
    {"Insert some elements and read their values",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 4)),
             ?assertMatch({ok, "one"}, frappe:read(FS, a)),
             ?assertMatch({ok, "two"}, frappe:read(FS, b)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
fail_read_frappe() ->
    {"Read a non exsisting value, fail, insert it and read it again",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(nothing, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch({ok, "one"}, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
lru_read_frappe() ->
    {"Read a value, force a deletion, read it again and fail",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "now you read me", 10)),
             ?assertMatch({ok, "now you read me"}, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:insert(FS, b, "now you don't", 1)),
             ?assertMatch(nothing, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
set_overwrite_read_frappe() ->
    {"Read a value, overwrite it with set, read the new value",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch({ok, "one"}, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:set(FS, a, new_one, 2)),
             ?assertMatch({ok, new_one}, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
advanced_read_frappe() ->
    {"Use read to check LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 4)),
             ?assertMatch({ok, "one"}, frappe:read(FS, a)),%a front of queue
             ?assertMatch(ok, frappe:insert(FS, c, "three", 5)),
             ?assertMatch({ok, "one"}, frappe:read(FS, a)),
             ?assertMatch(nothing, frappe:read(FS, b)),
             ?assertMatch({ok, "three"}, frappe:read(FS, c)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 4)),
             ?assertMatch(nothing, frappe:read(FS, a)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
sanity_advanced_read_frappe() ->
    {"Sanity check that read updated the LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 4)),
             ?assertMatch(ok, frappe:insert(FS, c, "three", 5)),
             ?assertMatch(nothing, frappe:read(FS, a)),
             ?assertMatch({ok, "two"}, frappe:read(FS, b)),
             ?assertMatch({ok, "three"}, frappe:read(FS, c)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.

%%%%%%%%%%%%%%%%%%%% UPDATE TEST %%%%%%%%%%%%%%%%%%%%
simple_update_frappe() ->
    {"Sanity check that read updated the LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:update(FS, a, "new_one", 1)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
negative_update_frappe() ->
    {"Sanity check that read updated the LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch({error, _Reason}, frappe:update(FS, a, "new_one", 1)),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 3)),
             ?assertMatch(ok, frappe:update(FS, a, "new_one", 1)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.

%%%%%%%%%%%%%%%%%%%% ALL_ITEMS TEST %%%%%%%%%%%%%%%%%%%%
simple_all_items_test() ->
    {"Sanity check that read updated the LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 1)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 2)),
             ?assertMatch(ok, frappe:insert(FS, c, "three", 3)),
             ?assertMatch([{a,"one",1},{b,"two",2},{c,"three",3}], frappe:all_items(FS)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.
zero_all_items_test() ->
    {"Sanity check that read updated the LRU queue",
     fun() ->
             {ok, FS} = frappe:fresh(10),
             ?assertMatch([], frappe:all_items(FS)),
             ?assertMatch(ok, frappe:stop(FS))
     end}.

%%%%%%%%%%%%%%%%%%%% EVERYTHING TEST %%%%%%%%%%%%%%%%%%%%
everything_test_frappe() ->
    {"Testing a bit of everything",
     fun() ->
             {ok, FS} = frappe:fresh(7),
             ?assertMatch(ok, frappe:insert(FS, a, "one", 1)),
             ?assertMatch(ok, frappe:insert(FS, b, "two", 2)),
             ?assertMatch(ok, frappe:set(FS, c, "three", 3)),
             ?assertMatch(ok, frappe:set(FS, c, "new_three", 3)),
             ?assertMatch(ok, frappe:update(FS, b, "two", 4)),
             ?assertMatch(nothing, frappe:read(FS, a)),
             ?assertMatch({ok,"new_three"}, frappe:read(FS, c)),
             ?assertMatch({error, _Reason}, frappe:insert(FS, c, "old_three", 3)),
             ?assertMatch([{b,"two",4},{c,"new_three",3}], frappe:all_items(FS)),
             ?assertMatch(ok, frappe:set(FS, d, "four", 1)),
             ?assertMatch({ok,"new_three"}, frappe:read(FS, c)),
             ?assertMatch(nothing, frappe:read(FS, b)),
             ?assertMatch({error, _Reason}, frappe:update(FS, a, "one", 1))
     end}.


%%%%%%%%%%%%%%%%%%%% STATE TEST %%%%%%%%%%%%%%%%%%%%
%% {{_Cache, _MCap, _RCap}, _Q, _KWMap} = sys:get_state(FS).
state_test_frappe() ->
    {"Checking if the state is handled correctly",
     fun() ->
             {ok, FS} = frappe:fresh(16),
             ?assertMatch(ok, frappe:insert(FS, happy, ":)", 2)),
             ?assertMatch(ok, frappe:insert(FS, unhappy, ":(", 1)),
             ?assertMatch(ok, frappe:set(FS, happy, ":D", 4)),
             ?assertMatch(ok, frappe:set(FS, laugh, "xD", 12)),
             ?assertMatch({ok, ":D"}, frappe:read(FS, happy)),
             {{Cache, MCap, RCap}, Q, KWMap} = sys:get_state(FS),
             ?assertMatch({{Cache, MCap, RCap}, Q}, {{#{happy => ":D",laugh => "xD"}, 16, 0}, {[{happy,4}],[{laugh,12}]}}),
             ?assertMatch([{laugh,"xD",12},{happy,":D",4}], frappe:all_items(FS)),
             {{Cache, MCap, RCap}, Q, KWMap} = sys:get_state(FS),
             ?assertMatch({{Cache, MCap, RCap}, Q}, {{#{happy => ":D",laugh => "xD"}, 16, 0}, {[{happy,4}],[{laugh,12}]}}),
             ?assertMatch(ok, frappe:stop(FS))
     end}.


%%% Multiple servers
%%% Big queue? So Frappe Server is stalling while calculating?
