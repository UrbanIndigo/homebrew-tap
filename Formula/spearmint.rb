class Spearmint < Formula
  desc "CLI tool to sync developer products and gamepasses to Roblox"
  homepage "https://github.com/UrbanIndigo/spearmint"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.5/spearmint-aarch64-apple-darwin.zip"
      sha256 "74c88f24e91e1d371e630b4a9cc41bd5dbd8aaa04c2c7252625716bcd4f33367"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.5/spearmint-x86_64-apple-darwin.zip"
      sha256 "2233fa481803405e3c897070f9c31f2f6a070c6ae5a8328d426044ca52acbe0c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.5/spearmint-aarch64-unknown-linux-gnu.zip"
      sha256 "9da00acb6a037657c56247c278937fc3945bb0f3f5bfb01edd40172ae6ff8359"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.5/spearmint-x86_64-unknown-linux-gnu.zip"
      sha256 "8522d9dac8304c260d9d0003de8a21997304d826862969a84e804a9b52c2820a"
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
