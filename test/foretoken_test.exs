defmodule ForetokenTest do
  use ExUnit.Case

  defp take(b) do
    Foretoken.take(b, 100, 5)
  end

  test "take/4" do
    Enum.each(1..5, fn _ ->
      assert take("b1") == :ok
    end)
    {:error, dur} = take("b1")
    :timer.sleep(dur)
    assert take("b1") == :ok
    {:error, _} = take("b1")
  end

  test "take/4 should accept tuples and lists" do
    assert take({:a, :b})   == :ok
    assert take(["a", "b"]) == :ok
  end

  test "take/4 should raise if `tokens_to_take` is too large" do
    assert      Foretoken.take("b2", 100, 5, 5) == :ok
    catch_error Foretoken.take("b2", 100, 5, 6)
  end

  defp with_short_inactive_threshold(f) do
    try do
      Application.put_env(:foretoken, :inactive_threshold, 50)
      f.()
    after
      Application.delete_env(:foretoken, :inactive_threshold)
    end
  end

  defp lookup(b) do
    :ets.lookup(:foretoken_buckets, b) |> List.first()
  end

  defp run_cleanup() do
    send(Foretoken.InactiveBucketCleaner, :timeout)
    _ = :sys.get_state(Foretoken.InactiveBucketCleaner) # wait
  end

  test "automatic cleanup of inactive bucket" do
    with_short_inactive_threshold(fn ->
      assert take("x") == :ok
      assert take("y") == :ok
      assert lookup("x")
      assert lookup("y")

      run_cleanup()
      assert lookup("x")
      assert lookup("y")

      :timer.sleep(100)
      assert take("x") == :ok
      run_cleanup()
      assert lookup("x")
      refute lookup("y")

      :timer.sleep(100)
      run_cleanup()
      refute lookup("x")
      refute lookup("y")
    end)
  end
end
