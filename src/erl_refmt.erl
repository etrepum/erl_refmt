-module(erl_refmt).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    lists:foreach(fun process_file/1, Args),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

read_file_unicode(Filename) ->
    Encoding = case epp:read_encoding(Filename) of
        none -> utf8;
        Other -> Other
    end,
    case file:read_file(Filename) of
        {ok, B} ->
            case unicode:characters_to_list(B, Encoding) of
                Res when is_list(Res) ->
                    {ok, Res};
                _ ->
                    {error, invalid_utf8}
            end;
        {error, Err} ->
            {error, {file_error, Err}}
    end.

process_file(Filename) ->
    {ok, S} = read_file_unicode(Filename),
    {ok, Tokens, _Line} = erl_scan:string(S, 0, [return, text]),
    ok.

%% See also:

%% erl_parse:parse_exprs(Tokens)
%% erl_parse:parse_form(Tokens)
%% erl_parse:parse_term(Tokens)
%% erl_parse:parse_term(Tokens ++ [{dot, erl_anno:new(1)}])
%% erl_eval:extended_parse_exprs(Tokens)
%% erl_eval:extended_parse_term(Tokens++[{dot, erl_anno:new(1)}])


%% http://erlang.org/doc/man/erl_anno.html
%% http://erlang.org/doc/man/erl_parse.html
%% http://erlang.org/doc/man/epp.html
%% http://erlang.org/doc/man/erl_eval.html
%% http://erlang.org/doc/man/erl_syntax.html
%% http://erlang.org/doc/man/epp_dodger.html