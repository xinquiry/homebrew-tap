class Koda < Formula
  desc "Koda command-line coding-agent runtime."
  homepage "https://github.com/xinquiry/koda-releases"
  version "0.1.21"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.21/koda-aarch64-apple-darwin.tar.xz"
    sha256 "ead2593c66fe8fb8b90cfb3dbc6cfb541d61039657be637c8e5f2bd36e1bc8a3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.21/koda-aarch64-unknown-linux-musl.tar.xz"
      sha256 "38be489267ca1d11e32dd75f452e7a48c87da4d86925b531d67668deab851740"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xinquiry/koda-releases/releases/download/v0.1.21/koda-x86_64-unknown-linux-musl.tar.xz"
      sha256 "79c47a43e35760662e713464a59e7c72dfbc6a0b8a143b73e38d3677cf5d2c1f"
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
