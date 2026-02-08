class Spearmint < Formula
  desc "CLI tool to sync developer products and gamepasses to Roblox"
  homepage "https://github.com/UrbanIndigo/spearmint"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.6/spearmint-aarch64-apple-darwin.zip"
      sha256 "859690b29b945b49aa3ffe4500e59fb35d0f42f0c1b959879eccf09d9da844fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.6/spearmint-x86_64-apple-darwin.zip"
      sha256 "57eeba4af9a5de965cd1a14b62c0405b786f95fae0232f6498723d591ad1e08a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.6/spearmint-aarch64-unknown-linux-gnu.zip"
      sha256 "480d97122dbd7ba405e329c6c92316401f436f0ce9ba265d9ef805c50f4bd8c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.6/spearmint-x86_64-unknown-linux-gnu.zip"
      sha256 "22ec134b9b328b1bcb7c362e85ad02abee11dbced2c178fd2097bc6b78ead451"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "spearmint" if OS.mac? && Hardware::CPU.arm?
    bin.install "spearmint" if OS.mac? && Hardware::CPU.intel?
    bin.install "spearmint" if OS.linux? && Hardware::CPU.arm?
    bin.install "spearmint" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
