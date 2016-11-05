defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores value by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "deleting key from bucket", %{bucket: bucket} do
    KV.Bucket.put(bucket, "beer", 5)

    assert KV.Bucket.delete(bucket, "beer") == 5
    assert KV.Bucket.get(bucket, "beer") == nil
  end

end
