require 'test_helper'

class WorkerImageTest < ActiveSupport::TestCase

  test "class filepaths" do
    assert_equal "app/assets/images/default_avatars", Worker.default_avatar_dir
    assert_equal ["vimg02.png", "vimg01.png", "vimg04.png", "vimg05.png", "vimg03.png"], Worker.avatar_filepaths

    assert_equal "/home/guest/.gnome2/cheese/media/", Worker.cheese_dir
    assert_equal [], Worker.cheese_filepaths
  end

  test "default avatar image" do
    worker = Worker.create(name: "Test Worker 101")
    assert_equal "/assets/default_avatars/vimg01.png", worker.avatar_url
  end

end
