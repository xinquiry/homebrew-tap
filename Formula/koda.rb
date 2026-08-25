class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-releases"
  version "0.1.24"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.24/koda-aarch64-apple-darwin.tar.xz"
    sha256 "50a8c2cf9082b5c7b117c882f217faee0e96d824d8b0c00dbfe0df6b4a61b7b0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.24/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1c9204664def056ee28466b590e85342d497cc99e4d45b463ab497ae0da71318"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.24/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "28f05e2fa25d05e53140c83480d8a90e404a2b119cc0c091b810689d42820f62"
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
