class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-releases"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.8/koda-aarch64-apple-darwin.tar.xz"
    sha256 "db6d80c80c83eeaea1b219787c4d9453a1c0e79c7f29568076d05e9452a73fea"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.8/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9bbe64dffcb908bf645e03451868b9c3b35eee51ae169f8ccb58050c85a7df47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.8/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "98e7eeb761c652f2d7d396cb01379b1a2fa50a32b0fe3112ee4e6a88445fe9a9"
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
