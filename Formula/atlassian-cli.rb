class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://github.com/omar16100/atlassian-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.0/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3230f3fb6777a1fc76c3148f208febedc0ecf5e31e61db6300ad30fed2966c26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.0/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "397bbf989a4ef733b1a5748702d76016411c33bbb15370fe8ada35799d128cd0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.0/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "665c31eabdc41fdb8863efe368c8e8791008c408a6b1d3eb94e10a329e033560"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "atlassian-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "atlassian-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "atlassian-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
