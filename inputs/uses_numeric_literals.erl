-module(uses_numeric_literals).
-export([return_ffff/0, return_tab/0, return_1111/0]).

%% We want to preserve literals as-is.

return_ffff() ->
    16#ffff.

return_tab() ->
    $\t.

return_1111() ->
    2#1111.
