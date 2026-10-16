class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassian-cli.pages.dev"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.12.0/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3f4f74482ce1e86924f70b02c7e58cd9a46f25243854d2c13ce893516dca6546"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.12.0/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2aced4e785602539ceef6a16f7c33ad31db29b1d59608759b0cf86292cc1ad03"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.12.0/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "65f60c29d34b53a85ebbc1706b105d373f9d2d39ebd2b2b1379c09bcdf0b6cc6"
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
