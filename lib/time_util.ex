use Croma

defmodule StackoverflowCloneB.TimeUtil do
  alias SolomonLib.{Time, IsoTimestamp}
  defun to_iso_timestamp_sec({Time, {y, mon, d}, {h, min, s}, _} :: Time.t) :: IsoTimestamp.t do
    import SolomonLib.StringFormat
    "#{y}-#{pad2(mon)}-#{pad2(d)}T#{pad2(h)}:#{pad2(min)}:#{pad2(s)}+00:00"
  end
end
