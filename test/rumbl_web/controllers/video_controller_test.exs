#defmodule RumblWeb.VideoControllerTest do
#  use RumblWeb.ConnCase
#
#  alias Rumbl.Media
#
#  @create_attrs %{description: "some description", title: "some title", url: "some url"}
#  @update_attrs %{description: "some updated description", title: "some updated title", url: "some updated url"}
#  @invalid_attrs %{description: nil, title: nil, url: nil}
#
#  def fixture(:video) do
#    {:ok, video} = Media.create_video(@create_attrs)
#    video
#  end
#
#  describe "index" do
#    test "lists all videos", %{conn: conn} do
#      conn = get conn, video_path(conn, :index)
#      assert html_response(conn, 200) =~ "Listing Videos"
#    end
#  end
#
#  describe "new video" do
#    test "renders form", %{conn: conn} do
#      conn = get conn, video_path(conn, :new)
#      assert html_response(conn, 200) =~ "New Video"
#    end
#  end
#
#  describe "create video" do
#    test "redirects to show when data is valid", %{conn: conn} do
#      conn = post conn, video_path(conn, :create), video: @create_attrs
#
#      assert %{id: id} = redirected_params(conn)
#      assert redirected_to(conn) == video_path(conn, :show, id)
#
#      conn = get conn, video_path(conn, :show, id)
#      assert html_response(conn, 200) =~ "Show Video"
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post conn, video_path(conn, :create), video: @invalid_attrs
#      assert html_response(conn, 200) =~ "New Video"
#    end
#  end
#
#  describe "edit video" do
#    setup [:create_video]
#
#    test "renders form for editing chosen video", %{conn: conn, video: video} do
#      conn = get conn, video_path(conn, :edit, video)
#      assert html_response(conn, 200) =~ "Edit Video"
#    end
#  end
#
#  describe "update video" do
#    setup [:create_video]
#
#    test "redirects when data is valid", %{conn: conn, video: video} do
#      conn = put conn, video_path(conn, :update, video), video: @update_attrs
#      assert redirected_to(conn) == video_path(conn, :show, video)
#
#      conn = get conn, video_path(conn, :show, video)
#      assert html_response(conn, 200) =~ "some updated description"
#    end
#
#    test "renders errors when data is invalid", %{conn: conn, video: video} do
#      conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
#      assert html_response(conn, 200) =~ "Edit Video"
#    end
#  end
#
#  describe "delete video" do
#    setup [:create_video]
#
#    test "deletes chosen video", %{conn: conn, video: video} do
#      conn = delete conn, video_path(conn, :delete, video)
#      assert redirected_to(conn) == video_path(conn, :index)
#      assert_error_sent 404, fn ->
#        get conn, video_path(conn, :show, video)
#      end
#    end
#  end
#
#  defp create_video(_) do
#    video = fixture(:video)
#    {:ok, video: video}
#  end
#end


defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(%{username: username})
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "required user auth for all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, video_path(conn, :new)),
        get(conn, video_path(conn, :index)),
        get(conn, video_path(conn, :show, "123")),
        get(conn, video_path(conn, :edit, "123")),
        get(conn, video_path(conn, :update, "123")),
        get(conn, video_path(conn, :create, %{})),
        get(conn, video_path(conn, :delete, "123")),
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  @tag login_as: "max"
  test "list all user's video on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "funny cats")
    other_video = insert_video(insert_user(%{username: "other"}), title: "another video")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing Videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end
end