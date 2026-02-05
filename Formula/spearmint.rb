class Spearmint < Formula
  desc "CLI tool to sync developer products and gamepasses to Roblox"
  homepage "https://github.com/UrbanIndigo/spearmint"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.1/spearmint-aarch64-apple-darwin.tar.xz"
      sha256 "a6459726c7baf036040a3519e39d6813297a274011c4d9cfa89d93960eb51a45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.1/spearmint-x86_64-apple-darwin.tar.xz"
      sha256 "c554a6e0bf68bf090f086ad99bb2206f8513f5615375bd55a5ff59b440b880f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.1/spearmint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd6e53012095970d3f9194f480d8249fc841b44ae8d88267b7cf26daac41d88e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/UrbanIndigo/spearmint/releases/download/v0.1.1/spearmint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f60a5211b717b1a0767805062147054488fc4965763c522af6dc6380d466abb0"
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
