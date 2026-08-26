class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-hub"
  version "0.1.25"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.25/koda-aarch64-apple-darwin.tar.xz"
    sha256 "e82b42e0c53b40ec2bd06ec21613ad07e2ee1655b7df75f2f059189e212b9b94"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.25/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "81581b4375658887e9ad617cbd1d0726f9251d33bba031d5a4023b146fd1eda8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.25/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7bd008da56fac73aa0598a562e29ff22d3fed1f47579076e562a5c907c62acdc"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "koda"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "koda"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "koda"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
