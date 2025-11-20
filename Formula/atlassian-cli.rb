class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://github.com/omar16100/atlassian-cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.2/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "da1e7e80b696d7be136a7e0af9350e1439beee044a2065835f1d406892298f86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.2/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "366ff2d36f5ee98a2233e3a412d41439a29c542bb41b116ba0eb7b49b9773c46"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.1.2/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7838e847902b3ab6ef2f0bad89bbdba799beb5602bee75d3d35d5a6cccf2ba36"
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
