class Acz < Formula
  desc "File compressor built on adaptive arithmetic coding"
  homepage "https://github.com/darrelllong/acz"
  url "https://github.com/darrelllong/acz/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d8595b50ad64c699d088de499a9e715271881066a703e941f3ebe84bdac59a16"
  # BSD-3-Clause with an added condition: the dedication to Glen G. Langdon
  # must be kept in all copies and derivative works.
  license :cannot_represent
  head "https://github.com/darrelllong/acz.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "acz")
    man1.install "docs/acz.1"
    man1.install_symlink "acz.1" => "unacz.1"
    man1.install_symlink "acz.1" => "aczcat.1"
  end

  test do
    (testpath/"in.txt").write("abracadabra\n" * 1000)
    system bin/"acz", "in.txt"
    assert_path_exists testpath/"in.txt.acz"
    assert_operator (testpath/"in.txt.acz").size, :<, 1000
    assert_equal (testpath/"in.txt").read, shell_output("#{bin}/aczcat in.txt.acz")
    system bin/"acz", "-t", "in.txt.acz"
    mv "in.txt", "orig.txt"
    system bin/"unacz", "in.txt.acz"
    assert_equal (testpath/"orig.txt").read, (testpath/"in.txt").read
  end
end
