use Croma

defmodule Foretoken do
  readme_contents = File.read!(Path.join([__DIR__, "..", "README.md"])) |> String.replace_prefix("# #{inspect(__MODULE__)}\n\n", "")

  @moduledoc """
  #{readme_contents}

  ---

  See also `Foretoken.Config`.
  """

  @type reason :: {:not_enough_token, milliseconds_to_wait :: pos_integer}
                | :nonexisting_bucket

  @doc """
  Tries to take the specified number of token(s) from the bucket identified by `bucket`.

  If the specified bucket does not exist, it's created on-demand filled with `max_tokens` tokens.
  If the bucket exists, current number of tokens is computed (using `milliseconds_per_token` and `max_tokens`)
  and, if available, `tokens_to_take` tokens are removed from the bucket.
  When there are no enough tokens in the bucket this function returns `{:error, milliseconds_to_wait}`,
  where `milliseconds_to_wait` is the duration after which the requested tokens become available.
  Note that waiting for `milliseconds_to_wait` doesn't guarantee success at the next `take/5`;
  another concurrent process may precede the current process.

  Although you can use basically arbitrary term for `bucket` argument,
  atoms with `$` and integers (such as `:"$1"`, `:"$2"`, ...) are not usable.
  """
  defun take(bucket                     :: any,
             milliseconds_per_token     :: g[pos_integer],
             max_tokens                 :: g[pos_integer],
             tokens_to_take             :: g[pos_integer] \\ 1,
             create_nonexisting_bucket? :: g[boolean] \\ true) :: :ok | {:error, reason} do
    if tokens_to_take <= max_tokens do
      Foretoken.Ets.take(bucket, tokens_to_take, milliseconds_per_token, max_tokens, create_nonexisting_bucket?)
    else
      raise ArgumentError, "`tokens_to_take` cannot exceed `max_tokens`"
    end
  end
end
