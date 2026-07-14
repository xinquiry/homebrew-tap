class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-releases"
  version "0.1.14"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.14/koda-aarch64-apple-darwin.tar.xz"
    sha256 "90d46ed3da90126391b8bf31ba97d5f8ce48f6b9358d1b268d2b13de9b86bf41"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.14/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f142fefac54f157a150ba7f9d5dc2b2dccb3f33ec3cc56d431977ae9e1338bbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.14/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c28cc68756fa2778c7cea9c535278b77695cb34513b0f7fe8e37a9aafb0a6426"
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
