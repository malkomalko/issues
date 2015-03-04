defmodule Issues.GithubIssues do

  @user_agent [{"User-agent", "Elixir robmalko@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
      |> convert_to_list_of_hashdicts
  end

  def handle_response({
    :ok, %HTTPoison.Response{status_code: 200, body: body}}
  ), do: {:ok, :jsx.decode(body)}
  def handle_response(_), do: {:error, []}

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def convert_to_list_of_hashdicts({_, list}) do
    list |> Enum.map(&Enum.into(&1, HashDict.new))
  end

end
