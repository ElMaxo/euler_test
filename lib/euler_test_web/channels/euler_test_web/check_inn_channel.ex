defmodule EulerTestWeb.CheckInnChannel do
  @moduledoc false
  use Phoenix.Channel

  def join("check-inn:unauth", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_inn_check", %{"body" => body}, socket) do
    alias EulerTest.Repo
    {valid, valid_str} =
      case check_inn(body) do
        :ok ->
          {true, ": корректен"}
        :error ->
          {false, ": некорректен"}
      end
    checked = NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
    Repo.insert(%EulerTest.InnChecks{inn: body, valid: valid, checked: checked})
    push(socket, "inn_check_reply", %{:body =>
      "[" <> NaiveDateTime.to_string(checked)  <> "] " <> body <> valid_str})
    {:noreply, socket}
  end

  defp check_inn(<<_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8>> = inn) do
    # tail-recursive anonymus function
    bin_to_digits = fn this, bin, acc ->
      case String.next_codepoint(bin) do
        {d, rest} ->
          this.(this, rest, [String.to_integer(d)|acc])
        nil ->
          acc
      end
    end
    inn_digits = Enum.reverse(bin_to_digits.(bin_to_digits, inn, []))
    mult = [2, 4, 10, 3, 5, 9, 4, 6, 8]
    digits_with_mult = List.zip([Enum.drop(inn_digits, -1), mult])
    mult_sum = Enum.reduce(digits_with_mult, 0, fn {d, m}, acc -> d * m + acc end)
    crc_base = div(mult_sum, 11) * 11
    crc =
      if mult_sum - crc_base == 10 do
        0
      else
        mult_sum - crc_base
    end
    case hd(Enum.reverse(inn_digits)) do
      ^crc ->
        :ok
      _ ->
        :error
    end
  end

  defp check_inn(<<_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8,_::8>> = inn) do
    inn_digits = bin_to_digits(inn, [])
    [d12,d11|_] = Enum.reverse(inn_digits)
    mult = [7,2,4,10,3,5,9,4,6,8,0]
    digits_with_mult = List.zip([Enum.drop(inn_digits, -1), mult])
    mult_sum = Enum.reduce(digits_with_mult, 0, fn {d, m}, acc -> d * m + acc end)
    crc_base = div(mult_sum, 11) * 11
    crc1 =
      if mult_sum - crc_base == 10 do
        0
      else
        mult_sum - crc_base
      end
    case d11 do
      ^crc1 ->
        mult = [3,7,2,4,10,3,5,9,4,6,8,0]
        digits_with_mult = List.zip([inn_digits, mult])
        mult_sum = Enum.reduce(digits_with_mult, 0, fn {d, m}, acc -> d * m + acc end)
        crc_base = div(mult_sum, 11) * 11
        crc2 =
          if mult_sum - crc_base == 10 do
            0
          else
            mult_sum - crc_base
          end
        case d12 do
          ^crc2 ->
            :ok
          _ ->
            :error
        end
      _ ->
        :error
    end
  end

  defp check_inn(_) do
    :error
  end

  # tail recursion with guards
  defp bin_to_digits(bin, acc) when is_binary(bin) do
    bin_to_digits(String.next_codepoint(bin), acc)
  end
  defp bin_to_digits({sym, rest}, acc) do
    bin_to_digits(rest, [String.to_integer(sym)|acc])
  end
  defp bin_to_digits(nil, acc) do
    Enum.reverse(acc)
  end


end
