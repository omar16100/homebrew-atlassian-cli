class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://github.com/omar16100/atlassian-cli"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.1/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "964f5d812746f9a96e8d435b71b707908d116bf1f20349f23f9fe4ba1fc39dc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.1/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "62c71884c9dd1d2f323e2766a5723403d541864a79872ce3b39edc6d04a20e17"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.1/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dcfed503ebc134f8e9fe16e09e2f708a50efc6e5dc55b66209b5f5046f4e741d"
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
