-module(worker).
-behaviour(gen_server).
%%% A module for the worker gen_servers %%%
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

%% Workers are essentially just a message queue?
init(Value) -> {ok, Value}.

% Blocking
handle_call({update, NewValue}, _From, _Value) ->
    {reply, ok, NewValue}.

%% handle_call(upsert, _State) ->
%%     not_implemented.

% Non-blocking
handle_cast(stable, _State) -> ok.
    %% not_implemented.

terminate(_Reason, _State) -> ok.


%% TODO (i aften):
%% Lav read -> update -> all_values
%% Lav tests til hver når de er done
%% Lav state-dependant tests

%% TODO (i morgen tidlig):
%% Lav diagram over Frappe
%% Lav rapport til erlang...
%% Test Haskell Resolver + Coder
%% Check coverage
%% Skriv Haskell rapport om

%% TODO (hvis tid):
%% Kig på om QC er doable?
%% Lav Parser færdig
%% ??
%% ~Omskriv State~ (udskudt)
