-module(frappe).%%% Change State Queue to only have keys, Change KWMap to also have cap? Also handle MCap => C > 0
-behaviour(gen_server).
-compile(worker).

% You are allowed to split your Erlang code in as many files as you
% find appropriate.
% However, you MUST have a module (this file) called frappe.

% API
-export([fresh/1,
         set/4,
         read/2,
         insert/4,
         update/4,
         upsert/3,
         stable/3,
         all_items/1,
         stop/1
        ]).

% Callback
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).
-export([]).

% Helper Functions
%% make_room(Q, C Ks) when C =< 0 ->
%%     {Q,Ks};
make_room(Q, C, Ks) ->
    {Ret, NewQ} = queue:out(Q),
    case Ret of
        {empty, Q} ->
            {empty_queue, Q, C, Ks};%Should never get here
        {value, {Key, Cost}} ->
            if C - Cost > 0 ->
                    make_room(NewQ, C - Cost, [Key|Ks]);
               true -> {ok, NewQ, C - Cost, [Key|Ks]}
            end
    end.

clear_out([], Cache, KWMap) ->
    {ok, Cache, KWMap};
clear_out([Key|Ks], Cache, KWMap) ->
    {KPid, NewKWMap} = maps:take(Key, KWMap),
    %% case Ret of error -> {reply, {error, key_not_in_map},[]},
    gen_server:stop(KPid),
    NewCache = maps:remove(Key,Cache),
    clear_out(Ks, NewCache, NewKWMap).

% User API
fresh(Cap) ->
    if
        Cap =< 0 ->
            {error, non_positive_capacity};
        true     ->
            gen_server:start(?MODULE, Cap, [])
    end.

%% Check C < MCap
set(_FS, _Key, _Value, C) when C =< 0 -> {error, negative_cost_element};
set(FS, Key, Value, C) ->%% Kører det her i en ny process, eller skal jeg skabe en worker til det?
    {ok, {{_Cache,MCap,RCap},Q,KWMap}} = gen_server:call(FS, get_state),
    if
        C > MCap -> {error, cost_too_big};
        true ->
            case maps:find(Key, KWMap) of
                error      ->
                    insert(FS, Key, Value, C);
                {ok, KWPid} ->
                    TempQ = queue:filter(fun(Item) ->
                                                 case Item of
                                                     {Key, _Ci}   -> true;
                                                     {_Keyi, _Ci} -> false
                                                 end end, Q),
                    {Key, OldC} = queue:get(TempQ),
                    gen_server:stop(KWPid),%% Might give people wrong error messages?** But prios set.
                    {ok, NewKWPid} = gen_server:start(worker, Value, []),
                    %% Get killed Keys OldC,
                    if
                        (C-OldC) > RCap ->
                            gen_server:call(FS, {make_room, C-OldC}),
                            gen_server:call(FS, {insert_worker, Key, Value, C, OldC, NewKWPid});%% Could write ok and move this and the next down to after the if
                        true -> %% ok -> fall through?
                            gen_server:call(FS, {insert_worker, Key, Value, C, OldC, NewKWPid})
                    end,
                    ok
            end
    end.
%% **Relevant: https://stackoverflow.com/questions/44226189/how-to-terminate-gen-server-gracefully-without-crash-report
%% **Relevant: https://www.erlang.org/doc/reference_manual/processes.html#errorsz
%% Start a new Key process, give K...Get Key PID, stop process, start new process, send {set, Value} to it

read(FS, Key) ->
    {ok, {{Cache,_MCap,_RCap},Q,KWMap}} = gen_server:call(FS, get_state),
    case maps:find(Key, Cache) of
        {ok, Value} ->
            {ok, KWPid} = maps:find(Key, KWMap),
            TempQ = queue:filter(fun(Item) ->
                                         case Item of
                                             {Key, _Ci}   -> true;
                                             {_Keyi, _Ci} -> false
                                         end end, Q),
            {Key, C} = queue:get(TempQ),
            gen_server:call(FS, {insert_worker, Key, Value, C, C, KWPid}),
            {ok, Value};
        error ->
            nothing
    end.

insert(_FS, _Key, _Value, C) when C =< 0 -> {error, negative_cost_element};
insert(FS, Key, Value, C) ->%% Check non positive Cs (and test).
    {ok, {{_Cache,MCap,RCap},_Q,KWMap}} = gen_server:call(FS, get_state),
    if C > MCap ->
            {error, cost_too_big};
       true     ->
            case maps:find(Key, KWMap) of
                {ok, _KWPid} ->
                    {error, key_exsists};
                error      ->
                    {ok, NewKWPid} = gen_server:start(worker, Value, []),
                    if C > RCap ->
                            gen_server:call(FS, {make_room, C}),
                            gen_server:call(FS, {insert_worker, Key, Value, C, 0, NewKWPid});
                       true -> %% Do fall through how?
                            gen_server:call(FS, {insert_worker, Key, Value, C, 0, NewKWPid})
                    end,
                    ok
            end
    end.

%%% Fucks up RCap
update(_FS, _Key, _Value, C) when C =< 0 -> {error, negative_cost_element};
update(FS, Key, Value, C) ->
    %% Check that Key exsists. Then update it. call worker, when i get a reply i can update it, but not with set...
    {ok, {{_Cache,MCap,RCap},Q,KWMap}} = gen_server:call(FS, get_state),
    if C > MCap ->
            {error, cost_too_big};
       true     ->
            case maps:find(Key, KWMap) of
                error       ->
                    {error, key_does_not_exsist};
                {ok, KWPid} ->
                    TempQ = queue:filter(fun(Item) ->
                                                 case Item of
                                                     {Key, _Ci}   -> true;
                                                     {_Keyi, _Ci} -> false
                                                 end end, Q),
                    {Key, OldC} = queue:get(TempQ),
                    gen_server:call(KWPid, {update, Value}),
                    if C > RCap ->
                            gen_server:call(FS, {make_room, C - OldC}),
                            gen_server:call(FS, {insert_worker, Key, Value, C, OldC, KWPid});
                       true ->
                            gen_server:call(FS, {insert_worker, Key, Value, C, OldC, KWPid})
                    end,
                    ok
            end
    end.

upsert(_, _, _) ->
  not_implemented.

stable(_, _, _) ->
  not_implemented.

all_items(FS) ->%% map(read)
    {ok, {{Cache,_MCap,_RCap},Q,_KWMap}} = gen_server:call(FS, get_state),
    %% Items = [],%% Use list as accumulator
    QList = queue:to_list(Q),
    %% CacheList = maps:to_list(Cache),
    lists:map(fun({K, C}) -> {K, maps:get(K, Cache), C} end, QList).


stop(FS) -> gen_server:call(FS, stop),%% Kill other active processes.
            gen_server:stop(FS).

%%%%% STATE:{{     #cache, max_cap, remaining_cap},                 queue, #key_worker}
%%%%%     = {{#{Key=>Data},    Cap,           Cap}, queue:new({Key, Cap}), #{Key=>Pid}}

% Callback functions
init(Cap) ->
             {ok, {{#{},Cap,Cap},queue:new(),#{}}}.

% Blocking
% Module:handle_call(Request, From, State) -> Result (= {reply,Reply,NewState})
handle_call(stop, _From, {_CacheData, _Q, KWMap}) ->
    %% Wanted to use maps:foreach
    maps:foreach(fun(_K, V) ->
                         gen_server:stop(V)
                 end, KWMap),
    {reply, ok, []};%% Empty state since we are stopping. (Bad?)

handle_call(get_state, _From, State) ->
    {reply, {ok, State}, State};

handle_call({make_room, C}, _From, {{Cache, MCap, RCap}, Q, KWMap}) ->
    Diff = C - RCap,
    {ok, NewQ, NewC, Ks} = make_room(Q,Diff,[]),% From Ks filter Cache, and filter+stop KWMap
    %For each Key in Ks do gen_server:stop(find(Key, KWMap)), and maps:remove(Key,Cache)
    {ok, NewCache, NewKWMap} = clear_out(Ks, Cache, KWMap),
    {reply, ok, {{NewCache, MCap, C - NewC}, NewQ, NewKWMap}};

handle_call({insert_worker, Key, Value, C, OldC, KWPid}, _From, {{Cache, MCap, RCap}, Q, KWMap}) ->
    Bool = maps:is_key(Key, Cache),
    if
        %% Either filter queue, or rewrite State so cache has {Key, {Value, C}} and Q only has Key.
        Bool ->
            TempQ = queue:filter(fun(Item) ->
                                         case Item of
                                             {Key, _Ci}   -> false;
                                             {_Keyi, _Ci} -> true
                                         end end, Q),
            NewQ = queue:in({Key, C}, TempQ);
        true ->
            NewQ = queue:in({Key, C}, Q)
    end,
    NewCache = maps:put(Key, Value, Cache),
    NewKWMap = maps:put(Key, KWPid, KWMap),
    {reply, ok, {{NewCache, MCap, RCap - C + OldC}, NewQ, NewKWMap}}.


% Non-blocking
%% Now FS needs to update queue and cache.
handle_cast({new_KeyWorker, _Key, _NewKPid, _Value}, _State) -> not_implemented.
%% handle_cast(_Reason, _State) -> not_implemented.

terminate(_Reason, _State) -> ok.


%%% Hvad hvis en slette operation tager lang tid, og der så når at kommer svar
%%%  fra en worker i mens? Det kan vel godt håndteres?
