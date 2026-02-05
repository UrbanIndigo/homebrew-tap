class Spearmint < Formula
  desc "CLI tool to sync developer products and gamepasses to Roblox"
  homepage "https://github.com/UrbanIndigo/spearmint"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.2/spearmint-aarch64-apple-darwin.tar.xz"
      sha256 "f3ea3176e1f88ae0c08a65f0abf09987fa4d657a84c60a6ee69623164722a754"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.2/spearmint-x86_64-apple-darwin.tar.xz"
      sha256 "71fbd0519f430ca00658e540dee12d6767ee5b06d858b0fdf8a0fd7a495f57de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.2/spearmint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a423bd183f726c331b81eba7d4c85c00988f577af0efc193a3aaee837061e684"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.2/spearmint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6582e21a0f04ebddeaf4f80ad546bedb7d7785f512c7a342d9e8ed42286fda37"
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
