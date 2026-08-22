class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassiancli.com"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.1/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e55086992a8ecdb2533ab211e4b914d9367c12bed9e56e039a98eaa6d3e13fec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.1/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8731d5c24bf0814c6e0dbaa180eed1465226afff301fef2513be9f7c2d2f9515"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.1/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ae2d8ef4eac7b390c7d85bdf609d19e21b4db720db317ab86a10c9d0072e30ab"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "atlassian-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atlassian-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atlassian-cli"
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
