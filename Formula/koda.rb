class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-hub"
  version "0.1.26"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.26/koda-aarch64-apple-darwin.tar.xz"
    sha256 "401f4e996f4656d3ec7f6e7efeb9fa656e80dd7bbee41ceb354724f74e3fe66a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.26/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6be88b07cc73b9e1df6f09ade2670ab5cccec87a12a256b532c25d3e2cae45e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-hub/releases/download/v0.1.26/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "27322e4094ac213d6974be490d56254090a77bf4de13e801ad7c6e39d196c9d2"
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
