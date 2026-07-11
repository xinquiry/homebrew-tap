class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-releases"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.10/koda-aarch64-apple-darwin.tar.xz"
    sha256 "4c0f3f7298043fbaad126cea96270cadf351b6dd35727556eaff4d8dea0da1bc"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.10/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8e2618f11a89e26099f83ba90c2a1819ceb26b548ed7f2e0283bf632d3faf8b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.10/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8d745edefb0556382ca7ba25e334134bc429a0b2f4a95160147ea6f5877cd1e6"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "koda" if OS.mac? && Hardware::CPU.arm?
    bin.install "koda" if OS.linux? && Hardware::CPU.arm?
    bin.install "koda" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
