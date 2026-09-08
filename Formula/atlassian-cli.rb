class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassiancli.com"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.0/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "394fd49ebeb753222eb95c840a1691435a1faaaa85665f96185431ef9d8b4422"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.0/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "728c339896c27b5f05efb4f118c4ffdcee332ab91b70b2d5e6de6e602ddef166"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.0/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0530084a5d5fd50f47eed09a6d3fb8f23e51c3156a7f796180b2242c172a5223"
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
