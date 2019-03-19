%% @author {{author}}
%% @copyright {{year}} {{author}}

%% @doc Uses macros.

-module('uses_macros').
-author("{{author}}").
-export([catch_with_stacktrace/1]).

%% OTP 21 is the first to define OTP_RELEASE and the first to support
%% EEP-0047 direct stack trace capture.
-ifdef(OTP_RELEASE).
-if(?OTP_RELEASE >= 21).
-define(HAS_DIRECT_STACKTRACE, true).
-endif.
-endif.

-ifdef(HAS_DIRECT_STACKTRACE).
-define(CAPTURE_EXC_PRE(Type, What, Trace), Type:What:Trace).
-define(CAPTURE_EXC_GET(Trace), Trace).
-else.
-define(CAPTURE_EXC_PRE(Type, What, Trace), Type:What).
-define(CAPTURE_EXC_GET(Trace), erlang:get_stacktrace()).
-endif.

catch_with_stacktrace(F) ->
    try
        F()
    catch
        ?CAPTURE_EXC_PRE(Type, What, Trace) ->
            {error, {Type, What, ?CAPTURE_EXC_GET(Trace)}}
    end.
