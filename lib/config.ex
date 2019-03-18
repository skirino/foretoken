use Croma

defmodule Foretoken.Config do
  @default_inactive_threshold      10 * 60_000
  @default_bucket_cleanup_interval 10 * 60_000

  @moduledoc """
  `Foretoken` defines the following application configs:

  - `:inactive_threshold`:
    Threshold duration (in milliseconds) to judge whether each bucket can be removed or not.
    Buckets that haven't been used within this duration are regarded as removable.
    In order to avoid losing status of a bucket by removal,
    this duration should be longer than `max_tokens * milliseconds_per_token`.
    Note that `Foretoken.take/5` by default creates a bucket on-demand if it doesn't exist.
    Defaults to `#{@default_inactive_threshold}`.
  - `:bucket_cleanup_interval`:
    Time interval (in milliseconds) between periodic cleanup of inactive buckets.
    Defaults to `#{@default_bucket_cleanup_interval}`.
  """

  defun inactive_threshold() :: pos_integer do
    Application.get_env(:foretoken, :inactive_threshold, @default_inactive_threshold)
  end

  defun bucket_cleanup_interval() :: pos_integer do
    Application.get_env(:foretoken, :bucket_cleanup_interval, @default_bucket_cleanup_interval)
  end
end
