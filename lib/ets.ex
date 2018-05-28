use Croma

defmodule Foretoken.Ets do
  @table :foretoken_buckets

  defun init() :: :ok do
    :ets.new(@table, [:named_table, :set, :public, {:write_concurrency, true}])
    :ok
  end

  def take(bucket, tokens_to_take, millis_per_token, max_tokens) do
    now = System.monotonic_time(:milliseconds)
    ms = match_spec(bucket, tokens_to_take, millis_per_token, max_tokens, now)
    case :ets.select_replace(@table, ms) do
      1 -> :ok
      0 ->
        case :ets.lookup(@table, bucket) do
          [{_bucket, tokens, updated_at}] ->
            dur_float = (tokens_to_take - tokens) * millis_per_token - (now - updated_at)
            dur_int   = max(trunc(Float.ceil(dur_float)), 1)
            {:error, dur_int}
          [] ->
            case :ets.insert_new(@table, {bucket, 1.0 * (max_tokens - tokens_to_take), now}) do
              true  -> :ok
              false -> take(bucket, tokens_to_take, millis_per_token, max_tokens) # failed to insert due to concurrent insert, retry
            end
        end
    end
  end

  defp match_spec(bucket, tokens_to_take, millis_per_token, max_tokens, now) do
    current_tokens        = {:+, :"$1", {:/, {:-, now, :"$2"}, millis_per_token}}
    current_tokens_capped = {:/, {:-, {:+, current_tokens, max_tokens}, {:abs, {:-, current_tokens, max_tokens}}}, 2}
    [
      {
        {bucket, :"$1", :"$2"},
        [{:>=, current_tokens_capped, tokens_to_take}],
        [{{{:const, bucket}, {:-, current_tokens_capped, tokens_to_take}, now}}],
      },
    ]
  end

  def delete_all_stale(monotonic_millis_threshold) do
    ms = [{{:_, :_, :"$1"}, [{:<, :"$1", monotonic_millis_threshold}], [true]}]
    :ets.select_delete(@table, ms)
  end
end
