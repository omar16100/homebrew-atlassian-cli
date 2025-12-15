class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://github.com/omar16100/atlassian-cli"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.8/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ca72f8965d4d0cb6a62f601a0711dd874b2cf6da430b4efc15f594d438fb6eca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.8/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "970465bf610d0cb224cf38b924c63d3751d83535d2b48cacd7aed35e150b5b8e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.8/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e3d3001c545bf8320266dd877c66c405e4a4eb4633bcda60d3308e418cd81d23"
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
