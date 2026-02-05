class Spearmint < Formula
  desc "CLI tool to sync developer products and gamepasses to Roblox"
  homepage "https://github.com/UrbanIndigo/spearmint"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.3/spearmint-aarch64-apple-darwin.zip"
      sha256 "edf7d890558ceae7610cada69811b4e742c4ad7046309019a533032319d112c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.3/spearmint-x86_64-apple-darwin.zip"
      sha256 "c80c330f94beaf98b2497c40d47b9033ea0408e793213517b34abf07b6d1b3d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.3/spearmint-aarch64-unknown-linux-gnu.zip"
      sha256 "33967497722494c5d290d013f12a1cf4125c5989fa0433910f0e84d3593735e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.3/spearmint-x86_64-unknown-linux-gnu.zip"
      sha256 "765d59a7c825194ff23d5cfeec3b85888dbfbebbb1ec3811aad4a6e4c5f3400c"
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
