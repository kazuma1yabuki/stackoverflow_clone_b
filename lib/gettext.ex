use Croma

defmodule StackoverflowCloneB.Gettext do
  use SolomonLib.Gettext, otp_app: :stackoverflow_clone_b

  defun put_locale(locale :: v[String.t]) :: nil do
    Gettext.put_locale(__MODULE__, locale)
  end
end
